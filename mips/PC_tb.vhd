-- PC_tb.vhd
-- Test bench of Program Counter (PC)

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc_tb is
end entity pc_tb;

architecture behavioral of pc_tb is
  component pc
    port (
      input: in std_logic_vector(31 downto 0);
      clk, rst: in std_logic;
      output: out std_logic_vector(31 downto 0)
    );
  end component pc;

  signal clk: std_logic := '0';
  signal rst: std_logic := '0';
  signal input: std_logic_vector(31 downto 0) := (others => '0');
  signal output: std_logic_vector(31 downto 0);

  constant CLOCK_PERIOD: time := 10 ns;

begin

  uut: pc port map (
    input => input,
    clk => clk,
    rst => rst,
    output => output
  );

  clk_proc: process
  begin
    while now < 200 ns loop
      clk <= '0';
      wait for CLOCK_PERIOD / 2;
      clk <= '1';
      wait for CLOCK_PERIOD / 2;
    end loop;
    wait;
  end process clk_proc;

  stim_proc: process

      type pattern_type is record
        input: std_logic_vector(31 downto 0);
        output: std_logic_vector(31 downto 0);
      end record;

      type pattern_array is array (natural range <>) of pattern_type;

      constant patterns: pattern_array := (
      (x"00000010", x"00000010"),  -- Load PC with 0x00000010
      (x"00000100", x"00000100"),  -- Load PC with 0x00000100
      (x"FFFFFFF0", x"FFFFFFF0"),  -- Load PC with 0xFFFFFFF0

      -- Required test cases
      (x"AAAA_BBBB", x"AAAA_BBBB"),
      (x"FFFF_CCCC", x"FFFF_CCCC")
      );
  begin
    rst <= '1';
    wait for CLOCK_PERIOD;
    rst <= '0';
    wait for CLOCK_PERIOD;

    for i in patterns'range loop
      input <= patterns(i).input;
      wait for CLOCK_PERIOD;

      assert output = patterns(i).output
      report "test failed for pattern " & integer'image(i)
      severity error;

      wait for CLOCK_PERIOD;
    end loop;

    report "end of simulation"
    severity note;
    wait;

  end process stim_proc;

end architecture behavioral;
