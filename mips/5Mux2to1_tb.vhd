-- Mux2to1_5_tb.vhd
-- Test Bench of 5-bit 2:1 MUX

library ieee;
use ieee.std_logic_1164.all;

entity mux2_5_tb is end entity mux2_5_tb;

architecture behavioral of mux2_5_tb is
  component mux2_5
  port (
    i0, i1: in std_logic_vector(4 downto 0); 
    o: out std_logic_vector(4 downto 0);
    sel: in std_logic
  );
  end component;

  signal i0, i1, o: std_logic_vector(4 downto 0);
  signal sel: std_logic;

begin
  uut: mux2_5 port map (
    i0 => i0,
    i1 => i1,
    o => o,
    sel => sel
  );

  stim_proc: process
    type pattern_type is record
      i0, i1: std_logic_vector(4 downto 0);
      sel: std_logic;
      o: std_logic_vector(4 downto 0);
    end record;

    type pattern_array is array (natural range <>) of pattern_type;
    constant patterns: pattern_array := (
      -- sel = '0', output should be i0
      ("00000", "00000", '0', "00000"),
      ("00001", "00010", '0', "00001"),
      ("00100", "01000", '0', "00100"),
      ("11111", "00000", '0', "11111"),
      ("10101", "01010", '0', "10101"),
      -- sel = '1', output should be i1
      ("00000", "00000", '1', "00000"),
      ("00001", "00010", '1', "00010"),
      ("00100", "01000", '1', "01000"),
      ("11111", "00000", '1', "00000"),
      ("10101", "01010", '1', "01010"),

      -- Required test cases
      ("11010", "01011", '1', "01011"), -- sel = '0', output should be i0
      ("11010", "01011", '0', "11010")  -- sel = '1', output should be i1
    );
  begin
    for i in patterns'range loop

      i0 <= patterns(i).i0;
      i1 <= patterns(i).i1;
      sel <= patterns(i).sel;

      wait for 10 ns;

      assert o = patterns(i).o
      report "test failed for pattern " & integer'image(i)
      severity error;

    end loop;

    report "end of simulation"
    severity note;
    wait;

  end process;

end architecture behavioral;
