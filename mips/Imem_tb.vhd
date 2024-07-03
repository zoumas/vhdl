-- Imem_tb.vhd
-- Test Bench for Instruction Memory (ROM)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity imem_tb is end entity imem_tb;

architecture behavioral of imem_tb is

  component imem is
  port (
    addr: in std_logic_vector(31 downto 0);
    instruction: out std_logic_vector(31 downto 0)
  );
  end component imem;

  constant CLK_PERIOD : time := 10 ns;

  signal addr : std_logic_vector(31 downto 0) := (others => '0');
  signal instruction_out : std_logic_vector(31 downto 0) := (others => '0');

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

  uut: imem port map (
    addr => addr,
    instruction => instruction_out
  );

  stim_proc : process
  begin
    for i in mem'range loop
      addr <= std_logic_vector(to_unsigned(i, 32));
      wait for CLK_PERIOD;
      assert instruction_out = mem(i)
        report "instruction mismatch at address " & integer'image(i)
        severity error;
    end loop;

    report "end of simulation"
    severity note;
    wait;

  end process stim_proc;

end architecture behavioral;
