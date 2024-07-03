-- Adder32_tb.vhd
-- Test bench for 32-bit Full Adder

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder32_tb is end entity adder32_tb;

architecture behavioral of adder32_tb is
  component adder32
    port (
      i0, i1: in std_logic_vector(31 downto 0);
      ci: in std_logic_vector(0 downto 0);
      s: out std_logic_vector(31 downto 0);
      co: out std_logic
    );
  end component;

  signal i0, i1: std_logic_vector(31 downto 0);
  signal ci: std_logic_vector(0 downto 0);
  signal s: std_logic_vector(31 downto 0);
  signal co: std_logic;

begin
  uut: adder32 port map (
    i0 => i0,
    i1 => i1,
    ci => ci,
    s => s,
    co => co
  );

  stim_proc: process

    type pattern_type is record
      i0, i1: std_logic_vector(31 downto 0);
      ci: std_logic_vector(0 downto 0);
      s: std_logic_vector(31 downto 0);
      co: std_logic;
    end record;

    type pattern_array is array (natural range <>) of pattern_type;

    constant patterns: pattern_array := (
      -- Basic
      (x"00000000", x"00000000", "0", x"00000000", '0'),
      (x"00000000", x"00000001", "0", x"00000001", '0'),

      -- ALU test cases
      (x"00000005", x"FFFFFFFC", "0", x"00000001", '0'),
      (x"00000005", x"FFFFFFFB", "0", x"00000000", '0'),

      -- Required test cases
      (x"AAAAAAAA", x"BBBBBBBB", "0", x"66666665", '1'),
      (x"AAAAAAAA", x"55555556", "0", x"FFFFFFFC", '1')
    );

  begin

    i0 <= (others => '0');
    i1 <= (others => '0');
    ci <= "0";


    for i in patterns'range loop

      i0 <= patterns(i).i0;
      i1 <= patterns(i).i1;
      ci <= patterns(i).ci;

      wait for 10 ns;

      assert s = patterns(i).s
        report "unexpected sum value for index" & integer'image(i)
        severity error;

      assert co = patterns(i).co
      report "unexpected carry-out value for index " & integer'image(i) 
        severity error;

    end loop;

    -- finish the simulation
    report "end of simulation"
    severity note;
    wait;

  end process;

end architecture behavioral;
