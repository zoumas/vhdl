-- ALU_tb.vhd
-- Test Bench of Arithmetic and Logic Unit (ALU)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_tb is end entity alu_tb;

architecture behavioral of alu_tb is
  component alu is port (
    i0, i1: in std_logic_vector(31 downto 0);
    op: in std_logic_vector(3 downto 0);

    zero: out std_logic;
    result: out std_logic_vector(31 downto 0)
  );
  end component alu;

  signal i0, i1: std_logic_vector(31 downto 0);
  signal op: std_logic_vector(3 downto 0);
  signal zero: std_logic;
  signal result: std_logic_vector(31 downto 0);

  constant CLK_PERIOD: time := 10 ns;
begin

  uut: alu port map (
    i0 => i0,
    i1 => i1,
    op => op,
    zero => zero,
    result => result
  );

  stim_proc: process

    type pattern_type is record
      i0, i1: std_logic_vector(31 downto 0);
      op: std_logic_vector(3 downto 0);
      o: std_logic_vector(31 downto 0);
      zero: std_logic;
    end record;

    type pattern_array is array (natural range <>) of pattern_type;

    constant patterns: pattern_array := (
      -- Test 5 + (-4)
      (
        std_logic_vector(to_signed(5, 32)),
        std_logic_vector(to_signed(-4, 32)),
        "0001",
        std_logic_vector(to_signed(1, 32)),
        '0'
      ),
      -- Test 5 + (-5)
      (
        std_logic_vector(to_signed(5, 32)),
        std_logic_vector(to_signed(-5, 32)),
        "0001",
        std_logic_vector(to_signed(0, 32)),
        '1'
      ),
      -- Test 7 - 8
      (
        std_logic_vector(to_signed(7, 32)),
        std_logic_vector(to_signed(-8, 32)),
        "0001",
        std_logic_vector(to_signed(-1, 32)),
        '0'
      )
    );

  begin
    for i in patterns'range loop
      i0 <= patterns(i).i0;
      i1 <= patterns(i).i1;
      op <= patterns(i).op;

      wait for CLK_PERIOD;

      assert result = patterns(i).o
        report "unexpected output value for index " & integer'image(i)
        severity error;

      assert zero = patterns(i).zero
        report "unexpected zero flag value for index " & integer'image(i)
        severity error;
    end loop;

    report "end of simulation"
    severity note;
    wait;

  end process stim_proc;

end architecture behavioral;
