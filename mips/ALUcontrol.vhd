-- ALUcontrol.vhd
-- Implementation of ALU Control Unit

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_control is
port (
  op : in std_logic_vector(1 downto 0);
  funct : in std_logic_vector(5 downto 0);
  ctrl : out std_logic_vector(3 downto 0)
);
end entity alu_control;

architecture behavioral of alu_control is
begin

  process(funct, op)
  begin

    case op is

    when "00" => -- lw, sw, addi
      ctrl <= "0010";
    when "01" => -- beq, bne
      ctrl <= "0110";
    when "10" => -- R-type

      case funct is
      when "100000" => -- add
        ctrl <= "0010";
      when "100010" => -- sub
        ctrl <= "0110";
      when others =>
        ctrl <= (others => '0');
      end case;

    when others =>
      ctrl <= "0000";
    end case;

  end process;

end architecture behavioral;
