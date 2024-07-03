-- Registerfile_tb.vhd
-- Test Bench for Register File
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_file_tb is end entity register_file_tb;

architecture behavioral of register_file_tb is

  component register_file is
  port (
    RegIn1, RegIn2, RegToWrite: in std_logic_vector(4 downto 0);
    RegWrite: in std_logic;
    DataToWrite: in std_logic_vector(31 downto 0);
    RegOut1, RegOut2: out std_logic_vector(31 downto 0)
  );
  end component;

  signal RegIn1, RegIn2, RegToWrite: std_logic_vector(4 downto 0) := (others => '0');
  signal DataToWrite: std_logic_vector(31 downto 0) := (others => '0');
  signal RegWrite: std_logic;
  signal RegOut1, RegOut2: std_logic_vector(31 downto 0);

begin

  uut: register_file
    port map (
      RegIn1 => RegIn1,
      RegIn2 => RegIn2,
      RegToWrite => RegToWrite,
      DataToWrite => DataToWrite,
      RegWrite => RegWrite,
      RegOut1 => RegOut1,
      RegOut2 => RegOut2
    );

  stim_proc: process

    type pattern_type is record
      DataToWrite: std_logic_vector(31 downto 0);
      RegToWrite: std_logic_vector(4 downto 0);
      RegWrite: std_logic;
      RegIn1, RegIn2: std_logic_vector(4 downto 0);
      expected_RegOut1, expected_RegOut2: std_logic_vector(31 downto 0);
    end record;

    type pattern_array is array (natural range <>) of pattern_type;

    constant patterns: pattern_array := (
      -- Required cases

      -- Write operations
      (
        DataToWrite => x"00000005",
        RegToWrite => "00011",
        RegWrite => '1',
        RegIn1 => "00000",
        RegIn2 => "00000",
        expected_RegOut1 => (others => '0'),
        expected_RegOut2 => (others => '0')
      ),
      (
        DataToWrite => x"00000007", 
        RegToWrite => "00100", 
        RegWrite => '1', 
        RegIn1 => "00000", 
        RegIn2 => "00000", 
        expected_RegOut1 => (others => '0'), 
        expected_RegOut2 => (others => '0')
      ),
      (
        DataToWrite => x"00000009", 
        RegToWrite => "00101", 
        RegWrite => '1', 
        RegIn1 => "00000", 
        RegIn2 => "00000", 
        expected_RegOut1 => (others => '0'), 
        expected_RegOut2 => (others => '0')
      ),

      -- Read operations
      (
        DataToWrite => (others => '0'),
        RegToWrite => (others => '0'), 
        RegWrite => '0', 
        RegIn1 => "00011", 
        RegIn2 => "00100",
        expected_RegOut1 => x"00000005",
        expected_RegOut2 => x"00000007"
      )
    );

  begin
    for i in patterns'range loop

      DataToWrite <= patterns(i).DataToWrite;
      RegToWrite <= patterns(i).RegToWrite;
      RegWrite <= patterns(i).RegWrite;
      RegIn1 <= patterns(i).RegIn1;
      RegIn2 <= patterns(i).RegIn2;

      wait for 2 ns;

      assert RegOut1 = patterns(i).expected_RegOut1
      report "test failed for pattern " & integer'image(i) & " (RegOut1)"
      severity error;

      assert RegOut2 = patterns(i).expected_RegOut2
      report "test failed for pattern " & integer'image(i) & " (RegOut2)"
      severity error;
    end loop;

    report "end of simulation"
    severity note;
    wait;
  end process stim_proc;

end architecture behavioral;
