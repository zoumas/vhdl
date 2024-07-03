-- LeftShift.vhd
-- Implementation of 32-bit Left Shifter by 2

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lshifter32 is
port (
  input: in std_logic_vector(31 downto 0);
  output: out std_logic_vector(31 downto 0)
);
end entity lshifter32;

architecture behavioral of lshifter32 is
  signal tmp: unsigned(31 downto 0);
begin
  tmp <= to_unsigned(to_integer(signed(input)), tmp'length) sll 2;
  output <= std_logic_vector(to_signed(to_integer(tmp), output'length));
end architecture behavioral;
