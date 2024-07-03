-- ALUcontrol_tb.vhd
-- Test Bench of ALU Control Unit
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_control_tb is end entity alu_control_tb;

architecture behavioral of alu_control_tb is
  signal op : std_logic_vector(1 downto 0);
  signal funct : std_logic_vector(5 downto 0);
  signal ctrl : std_logic_vector(3 downto 0);

  constant CLK_PERIOD : time := 10 ns;

component alu_control is
port (
  op : in std_logic_vector(1 downto 0);
  funct : in std_logic_vector(5 downto 0);
  ctrl : out std_logic_vector(3 downto 0)
);
end component alu_control;

begin
  uut: alu_control port map (
    op => op,
    funct => funct,
    ctrl => ctrl
  );

  stim_proc: process
    type pattern_type is record
      funct : std_logic_vector(5 downto 0);
      op : std_logic_vector(1 downto 0);
      expected_ctrl : std_logic_vector(3 downto 0);
    end record;

    type pattern_array is array (natural range <>) of pattern_type;

    constant patterns: pattern_array := (
      (funct => "100000", op => "10", expected_ctrl => "0010"),
      (funct => "100010", op => "10", expected_ctrl => "0110"),
      (funct => "111111", op => "00", expected_ctrl => "0010"),
      (funct => "111111", op => "01", expected_ctrl => "0110")
    );

  begin

    for i in patterns'range loop

      funct <= patterns(i).funct;
      op <= patterns(i).op;

      wait for CLK_PERIOD;

      assert ctrl = patterns(i).expected_ctrl
      report "unexpected control value for pattern " & integer'image(i)
      severity error;

    end loop;

    report "end of simulation"
    severity note;
    wait;

  end process stim_proc;

end architecture behavioral;
