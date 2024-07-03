-- Mux2to1_tb.vhd
-- Test Bench of 1-bit 2:1 MUX

library ieee;
use ieee.std_logic_1164.all;

-- A test bench entity is usually empty
entity mux2_1_tb is end entity mux2_1_tb;

architecture behavioral of mux2_1_tb is
  -- Component declaration for the 1-bit 2:1 MUX
  component mux2_1
  port (
    i0, i1: in std_logic;
    o: out std_logic;
    sel: in std_logic
  );
  end component;

  -- Signal declarations to connect to the MUX
  signal i0, i1, sel, o: std_logic;

begin
  -- Instantiate the MUX commonly labeled as uut - Unit Under Test
  uut: mux2_1 port map (
    i0 => i0,
    i1 => i1,
    o => o,
    sel => sel
  );

  -- Stimulus process: Apply values to inputs and observe behavior
  stim_proc: process
    -- Record that states the input values and the expected output
    type pattern_type is record
      -- The inputs of the MUX
      i0, i1, sel: std_logic;
      -- The expected output of the MUX
      o: std_logic;
    end record;

    -- The pattern array that allows us to easily add more cases, or test exhaustively, or test exhaustively.
    type pattern_array is array (natural range <>) of pattern_type;

    -- The list of test cases - the patterns to apply
    constant patterns: pattern_array := (
      ('0', '0', '0', '0'),
      ('0', '0', '1', '0'),
      ('0', '1', '0', '0'),
      ('0', '1', '1', '1'),
      ('1', '0', '0', '1'),
      ('1', '0', '1', '0'),
      ('1', '1', '0', '1'),
      ('1', '1', '1', '1')
    );
  begin
    -- Check each pattern
    for i in patterns'range loop

      -- Set the inputs
      i0 <= patterns(i).i0;
      i1 <= patterns(i).i1;
      sel <= patterns(i).sel;

      -- Wait for the results
      wait for 10 ns;

      -- Check the results
      assert o = patterns(i).o
      report "test failed for pattern " & integer'image(i)
      severity error;

    end loop;

    -- finish the simulation
    report "end of simulation"
    severity note;
    wait;

  end process;

end architecture behavioral;
