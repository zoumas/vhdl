-- PC.vhd
-- Implementation of Program Counter

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc is
port (
  input: in std_logic_vector(31 downto 0);
  clk, rst: in std_logic;
  output: out std_logic_vector(31 downto 0)
);
end entity pc;

architecture behavioral of pc is
  signal pc_internal: signed(31 downto 0);

begin

    process (clk, rst)
    begin
      if rst = '1' then
        pc_internal <= to_signed(0, pc_internal'length);
      elsif rising_edge(clk) then
        pc_internal <= signed(input);
      end if;
    end process;

    output <= std_logic_vector(pc_internal);

end architecture behavioral;
