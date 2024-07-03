-- Adder32.vhd
-- Implementation of 32-bit Full Adder

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder32 is
port (
  i0, i1: in std_logic_vector(31 downto 0);
  ci: in std_logic_vector(0 downto 0);
  s: out std_logic_vector(31 downto 0);
  co: out std_logic
);
end entity adder32;

architecture behavioral of adder32 is

  signal ts: std_logic_vector(32 downto 0);

begin

    ts <= std_logic_vector(
      to_signed(
        to_integer(signed(i0)) + to_integer(signed(i1)) + to_integer(signed(ci)),
        33
      )
    );
    s <= ts(31 downto 0);
    co <= ts(32);

  end architecture behavioral;
