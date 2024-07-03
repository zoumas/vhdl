-- 5Mux2to1.vhd
-- Implementation of 5-bit MUX 2:1

library ieee;
use ieee.std_logic_1164.all;

entity mux2_5 is
port (
  i0, i1: in std_logic_vector(4 downto 0); 
  o: out std_logic_vector(4 downto 0);
  sel: in std_logic
);
end entity mux2_5;

architecture behavioral of mux2_5 is
begin
  o <= i0 when sel = '0' else i1;
end architecture behavioral;
