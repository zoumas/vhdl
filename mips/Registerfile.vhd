-- Registerfile.vhd
-- Implementation of Register File
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_file is
port (
  RegIn1, RegIn2, RegToWrite: in std_logic_vector(4 downto 0);
  RegWrite: in std_logic;
  DataToWrite: in std_logic_vector(31 downto 0);
  RegOut1, RegOut2: out std_logic_vector(31 downto 0)
);
end entity register_file;

architecture behavioral of register_file is
  type registers is array (0 to 15) of std_logic_vector(31 downto 0);

  signal rs: registers := (others => (others => '0'));
  signal x: std_logic_vector(31 downto 0) := (others => 'X');
begin

  process(RegIn1, RegIn2, RegWrite, RegToWrite, DataToWrite)
  begin
    if RegWrite = '1' and DataToWrite /= x then
      rs(to_integer(unsigned(RegToWrite))) <= DataToWrite;
    else
      RegOut1 <= rs(to_integer(unsigned(RegIn1)));
      RegOut2 <= rs(to_integer(unsigned(RegIn2)));
    end if;

  end process;

end architecture behavioral;
