-- Signextension.vhd
-- Implementation of Sign Extension Unit

library ieee;
use ieee.std_logic_1164.all;

entity signext is
port (
  input: in std_logic_vector(15 downto 0);
  output: out std_logic_vector(31 downto 0)
);
end entity signext;

architecture behavioral of signext is
begin
  output <= (15 downto 0 => input(15)) & input;
end architecture behavioral;
