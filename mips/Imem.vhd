-- Imem.vhd
-- Implementation of Instruction Memory (ROM)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity imem is
port (
  addr: in std_logic_vector(31 downto 0);
  instruction: out std_logic_vector(31 downto 0)
);
end entity imem;

architecture behavioral of imem is
  type mem_type is array (0 to 15) of std_logic_vector(31 downto 0);
  signal mem : mem_type := (
    0 => x"20000000", -- addi $0, $0, 0
    1 => x"20420000", -- addi $2, $2, 0
    2 => x"20820000", -- addi $2, $4, 0
    3 => x"20030001", -- addi $3, $0, 1
    4 => x"20050003", -- addi $5, $0, 3
    5 => x"00603020", -- add $6, $3, $0
    6 => x"ac860000", -- sw $6, 0($4)
    7 => x"20630001", -- addi $3, $3, 1
    8 => x"20840001", -- addi $4, $4, 1
    9 => x"20a5ffff", -- addi $5, $5, -1
   10 => x"14a0fffa", -- bne $5, $0, L1
   others => (others => '0')
  );
begin

  main: process (addr)
    variable a: integer;
  begin
    a := to_integer(unsigned(addr));
    if a < 0 or a > 15 then
      instruction <= (others => 'X');
    else
      instruction <= mem(a);
    end if;
  end process;

end architecture behavioral;
