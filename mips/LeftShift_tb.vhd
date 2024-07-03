-- LeftShift_tb.vhd
-- Test bench of 32-bit Left Shifter by 2

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lshifter32_tb is end entity lshifter32_tb;

architecture behavioral of lshifter32_tb is
  component lshifter32
  port (
    input: in std_logic_vector(31 downto 0);
    output: out std_logic_vector(31 downto 0)
  );
  end component;

  signal input : std_logic_vector(31 downto 0);
  signal output : std_logic_vector(31 downto 0);

  type pattern_type is record
    input : std_logic_vector(31 downto 0);
    output : std_logic_vector(31 downto 0);
  end record;

  type pattern_array is array (natural range <>) of pattern_type;

  constant patterns : pattern_array := (
    (input => x"00000000", output => x"00000000"), -- 0 << 2 = 0
    (input => x"00000001", output => x"00000004"), -- 1 << 2 = 4
    (input => x"00000002", output => x"00000008"), -- 2 << 2 = 8

    -- Required test case
    (input => x"0FFFFFFF", output => x"3FFFFFFC")

  );

begin
  uut: lshifter32 port map (
    input => input,
    output => output
  );

  stim_proc: process
  begin
    for i in patterns'range loop

      input <= patterns(i).input;

      wait for 10 ns;

      -- Check the results
      assert output = patterns(i).output
        report "test failed for pattern " & integer'image(i)
        severity error;
    end loop;

    -- Finish the simulation
    report "end of simulation"
    severity note;
    wait;

  end process;

end architecture behavioral;
