-- 32Mux2to1_tb.vhd
-- Test Bench for 32-bit 2:1 MUX

library ieee;
use ieee.std_logic_1164.all;

entity mux2_32_tb is end entity mux2_32_tb;

architecture behavioral of mux2_32_tb is
  component mux2_32
  port (
    i0, i1: in std_logic_vector(31 downto 0); 
    o: out std_logic_vector(31 downto 0);
    sel: in std_logic
  );
  end component;

  signal i0, i1, o: std_logic_vector(31 downto 0);
  signal sel: std_logic;

begin
  uut: mux2_32 port map (
    i0 => i0,
    i1 => i1,
    o => o,
    sel => sel
  );

  stim_proc: process
    type pattern_type is record
      i0, i1: std_logic_vector(31 downto 0);
      sel: std_logic;
      o: std_logic_vector(31 downto 0);
    end record;

    type pattern_array is array (natural range <>) of pattern_type;
    constant patterns: pattern_array := (
      -- sel = '0', output should be i0
      (x"00000000", x"FFFFFFFF", '0', x"00000000"),
      (x"AAAAAAAA", x"55555555", '0', x"AAAAAAAA"),
      (x"12345678", x"87654321", '0', x"12345678"),
      (x"FFFFFFFF", x"00000000", '0', x"FFFFFFFF"),
      (x"0F0F0F0F", x"F0F0F0F0", '0', x"0F0F0F0F"),
      -- sel = '1', output should be i1
      (x"00000000", x"FFFFFFFF", '1', x"FFFFFFFF"),
      (x"AAAAAAAA", x"55555555", '1', x"55555555"),
      (x"12345678", x"87654321", '1', x"87654321"),
      (x"FFFFFFFF", x"00000000", '1', x"00000000"),
      (x"0F0F0F0F", x"F0F0F0F0", '1', x"F0F0F0F0"),

      -- Required test cases
      (x"AAAAAAAA", x"BBBBBBBB", '1', x"BBBBBBBB"), -- sel = '1', output should be i1
      (x"AAAAAAAA", x"BBBBBBBB", '0', x"AAAAAAAA")  -- sel = '0', output should be i0
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
