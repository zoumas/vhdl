-- Signextension_tb.vhd
-- Test Bench of Sign Extension Unit

library ieee;
use ieee.std_logic_1164.all;

entity signext_tb is end entity signext_tb;

architecture behavioral of signext_tb is
  component signext is
  port (
    input: in std_logic_vector(15 downto 0);
    output: out std_logic_vector(31 downto 0)
  );
  end component signext;

  signal input: std_logic_vector(15 downto 0);
  signal output: std_logic_vector(31 downto 0);

  type pattern_type is record
    input: std_logic_vector(15 downto 0);
    output: std_logic_vector(31 downto 0);
  end record;

  type pattern_array is array (natural range <>) of pattern_type;

  constant patterns: pattern_array := (
    (x"FFFF", x"FFFFFFFF"),
    (x"AAAA", x"FFFFAAAA"),
    (x"5555", x"00005555"),
    (x"0000", x"00000000")
  );

begin
 uut: signext
  port map(
     input => input,
     output => output
 );

 stim_proc: process
 begin
  for i in patterns'range loop
    input <= patterns(i).input;

    wait for 10 ns;

    assert output = patterns(i).output
    report "unexpected output value for input at index " & integer'image(i)
    severity error;

  end loop;

  assert false
    report "end of simulation"
    severity note;
  wait;
   
 end process stim_proc;
  
end architecture behavioral;
