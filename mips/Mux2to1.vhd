-- Mux2to1.vhd
-- Implementation of 1-bit 2:1 MUX

library ieee;
use ieee.std_logic_1164.all;

-- Define the 1-bit 2:1 MUX entity
entity mux2_1 is
-- i0, i1, sel are inputs while o is output all of type std_logic.
port (
  i0, i1: in std_logic; 
  o: out std_logic;
  sel: in std_logic
);
end entity mux2_1;

-- A behavioral architecture describes how a component should behave
-- without concern about time and implementation restrictions.
architecture behavioral of mux2_1 is
begin
  o <= i0 when sel = '0' else i1;
end architecture behavioral;

