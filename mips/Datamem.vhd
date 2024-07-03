-- Datamem.vhd
-- Implementation of Data Memory (RAM)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_mem is
port (
  clk, rst: in std_logic;
  input, WriteData: in std_logic_vector(31 downto 0);
  MemRead, MemWrite: in std_logic;
  output: out std_logic_vector(31 downto 0)
);
end entity data_mem;

architecture behavioral of data_mem is

  type ram_type is array (natural range <>) of std_logic_vector(31 downto 0);
  signal ram: ram_type(0 to 15) := (others => (others => '0'));

begin

  main: process(clk)
    variable addr: integer;
  begin

    if rst = '1' then
      -- clear RAM on reset
      ram <= (others => (others => '0'));
      output <= (others => '0');
    elsif rising_edge(clk) then
      addr := to_integer(unsigned(input));

      if MemWrite = '1' and addr <= 15 then
        ram(addr) <= WriteData;
      end if;

      if MemRead = '1' and addr <= 15 then
        output <= ram(addr);
      else
        output <= (others => '0');
      end if;
    end if;
  end process;

end architecture behavioral;
