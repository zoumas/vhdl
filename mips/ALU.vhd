-- ALU.vhd
-- Implementation of Arithmetic and Logic Unit (ALU)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is port (
  i0, i1: in std_logic_vector(31 downto 0);
  op: in std_logic_vector(3 downto 0);
  zero: out std_logic;
  result: out std_logic_vector(31 downto 0)
);
end entity alu;

architecture behavioral of alu is
  component adder32
  port (
    i0, i1: in std_logic_vector(31 downto 0);
    ci: in std_logic_vector(0 downto 0);
    s: out std_logic_vector(31 downto 0);
    co: out std_logic
  );
  end component;

  signal fa_out: std_logic_vector(31 downto 0);
  signal x: std_logic_vector(31 downto 0) := (others => 'X');
  signal co: std_logic;
begin

  fa: adder32 port map (
    i0 => i0,
    i1 => i1,
    ci => "0",
    co => co,
    s => fa_out
  );

  with op select result <=
    fa_out when "0001",
    fa_out when "1101",
    x when others;

  zero <=
    '1' when fa_out = std_logic_vector(to_signed(0, 32)) else
    '1' when ((op = "1011") and (i0 /= i1)) else -- bne
    '1' when ((op = "1010") and (i0 = i0)) else -- beq
    '0';

end architecture behavioral;
