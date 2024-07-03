-- Datamem_tb.vhd
-- Test bench for Data Memory (RAM)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_mem_tb is end entity data_mem_tb;

architecture behavioral of data_mem_tb is

  component data_mem
  port (
    clk, rst: in std_logic;
    input, WriteData: in std_logic_vector(31 downto 0);
    MemRead, MemWrite: in std_logic;
    output: out std_logic_vector(31 downto 0)
  );
  end component;

  signal clk, rst: std_logic := '0';
  signal input, WriteData: std_logic_vector(31 downto 0) := (others => '0');
  signal MemRead, MemWrite: std_logic := '0';
  signal output: std_logic_vector(31 downto 0);

  constant clk_period: time := 10 ns;

  type pattern_type is record
    input: std_logic_vector(31 downto 0);
    WriteData: std_logic_vector(31 downto 0);
    MemRead, MemWrite: std_logic;
    expected_output: std_logic_vector(31 downto 0);
  end record;

  type pattern_array is array (natural range <>) of pattern_type;

  constant patterns: pattern_array := (
    -- Write operations
    (
      input => x"00000000",
      WriteData => x"00000005",
      MemRead => '0',
      MemWrite => '1',
      expected_output => (others => '0')
    ),
    (
      input => x"00000001", 
      WriteData => x"00000007",
      MemRead => '0',
      MemWrite => '1',
      expected_output => (others => '0')
    ),

    -- Read operations
    (
      input => x"00000000",
      WriteData => (others => '0'),
      MemRead => '1',
      MemWrite => '0',
      expected_output => x"00000005"
    ),
    (
      input => x"00000001",
      WriteData => (others => '0'),
      MemRead => '1',
      MemWrite => '0',
      expected_output => x"00000007"
    )
  );

begin

  uut: data_mem
  port map (
      clk => clk,
      rst => rst,
      input => input,
      WriteData => WriteData,
      MemRead => MemRead,
      MemWrite => MemWrite,
      output => output
  );

  clk_proc: process
  begin
    while now < 1000 ns loop
      clk <= '0';
      wait for clk_period / 2;
      clk <= '1';
      wait for clk_period / 2;
    end loop;
    wait;
  end process;

  stim_proc: process
  begin
    rst <= '1';
    wait for 20 ns;
    rst <= '0';

    for i in patterns'range loop
      input <= patterns(i).input;
      WriteData <= patterns(i).WriteData;
      MemRead <= patterns(i).MemRead;
      MemWrite <= patterns(i).MemWrite;

      wait for clk_period;

      assert output = patterns(i).expected_output
          report "test failed for pattern " & integer'image(i)
          severity error;
    end loop;

    -- observe clearing of RAM
    rst <= '1';
    wait for 20 ns;

    report "end of simulation"
    severity note;
    wait;

  end process;

end architecture behavioral;
