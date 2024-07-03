-- Control.vhd
-- Implementation of Control Unit
library ieee;
use ieee.std_logic_1164.all;

entity control is
port (
  clk: in std_logic;
  input: in std_logic_vector(5 downto 0);
  AluOp: out std_logic_vector(1 downto 0);
  AluSrc,
  RegDst,
  RegWrite,
  MemRead,
  MemWrite,
  MemToReg,
  Branch,
  Jump: out std_logic
);
end entity control;

architecture behavioral of control is
  constant lw: std_logic_vector(5 downto 0) := "100011";
  constant sw: std_logic_vector(5 downto 0) := "101011";
  constant add: std_logic_vector(5 downto 0) := "000000";
  constant addi: std_logic_vector(5 downto 0) := "001000";
  constant beq: std_logic_vector(5 downto 0) := "000100";
  constant bne: std_logic_vector(5 downto 0) := "000101";
  constant j: std_logic_vector(5 downto 0) := "000010";
begin

  main: process(clk, input)
  begin

    case input is
    when lw =>
      AluOp <= "00";
      RegDst <= '0';
      AluSrc <= '1';
      MemToReg <= '1';
      RegWrite <= '1';
      MemRead <= '1';
      MemWrite <= '0';
      Branch <= '0';
      Jump <= '0';
    when sw =>
      AluOp <= "00";
      RegDst <= '0';
      AluSrc <= '1';
      MemToReg <= '0';
      RegWrite <= '0';
      MemRead <= '0';
      MemWrite <= '1';
      Branch <= '0';
      Jump <= '0';
    when add =>
      AluOp <= "10";
      RegDst <= '1';
      AluSrc <= '0';
      MemToReg <= '0';
      RegWrite <= '1';
      MemRead <= '0';
      MemWrite <= '0';
      Branch <= '0';
      Jump <= '0';
    when addi =>
      AluOp <= "00";
      RegDst <= '0';
      AluSrc <= '1';
      MemToReg <= '0';
      RegWrite <= '1';
      MemRead <= '0';
      MemWrite <= '0';
      Branch <= '0';
      Jump <= '0';
    when beq =>
      AluOp <= "01";
      RegDst <= '0';
      AluSrc <= '0';
      MemToReg <= '0';
      RegWrite <= '0';
      MemRead <= '0';
      MemWrite <= '0';
      Branch <= '1';
      Jump <= '0';
    when bne =>
      AluOp <= "01";
      RegDst <= '0';
      AluSrc <= '0';
      MemToReg <= '0';
      RegWrite <= '0';
      MemRead <= '0';
      MemWrite <= '0';
      Branch <= '1';
      Jump <= '0';
    when j =>
      AluOp <= "XX";
      RegDst <= 'X';
      AluSrc <= 'X';
      MemToReg <= 'X';
      RegWrite <= 'X';
      MemRead <= 'X';
      MemWrite <= 'X';
      Branch <= 'X';
      Jump <= '1';
    when others =>
      AluOp <= "00";
      AluSrc <= '0';
      RegDst <= '0';
      RegWrite <= '0';
      MemRead <= '0';
      MemWrite <= '0';
      MemToReg <= '0';
      Branch <= '0';
      Jump <= '0';
    end case;
  end process main;

end architecture behavioral;
