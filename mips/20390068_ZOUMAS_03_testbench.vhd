-- 20390068_ZOUMAS_02_MIPS.vhd
-- Test Bench of MIPS processor
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mips_tb is
end entity mips_tb;

architecture testbench of mips_tb is

  signal clk, rst: std_logic := '0';

  component mips
  port (
    clk: in std_logic;
    rst: in std_logic
  );
  end component mips;

  signal simulation_done: boolean := false;

begin

  uut: mips port map (
    clk => clk,
    rst => rst
  );

  clk_process: process
  begin
    while not simulation_done loop
      clk <= '1';
      wait for 10 ns;
      clk <= '0';
      wait for 10 ns;
    end loop;
    wait;
  end process clk_process;


  stim_proc: process
  begin

    rst <= '1';
    wait for 20 ns;
    rst <= '0';

    wait for 10000 ns;

    simulation_done <= true;
    wait;
  end process stim_proc;

end architecture testbench;
