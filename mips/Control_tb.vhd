-- Control_tb.vhd
-- Test Bench of Control Unit
library ieee;
use ieee.std_logic_1164.all;

entity control_tb is end entity control_tb;

architecture behavioral of control_tb is

  component control
  port (
    clk: in std_logic;
    input: in std_logic_vector(5 downto 0);
    RegWrite: out std_logic;
    AluOp: out std_logic_vector(1 downto 0);
    AluSrc,
    MemWrite,
    MemRead,
    RegDst,
    MemToReg,
    Jump,
    Branch: out std_logic
  );
  end component;

  signal clk: std_logic := '0';
  signal input: std_logic_vector(5 downto 0);
  signal RegWrite: std_logic;
  signal AluOp: std_logic_vector(1 downto 0);
  signal
    AluSrc,
    MemWrite,
    MemRead,
    RegDst,
    MemToReg,
    Jump,
    Branch: std_logic;

begin
  uut: control port map (
    clk => clk,
    input => input,
    RegWrite => RegWrite,
    AluOp => AluOp,
    AluSrc => AluSrc,
    MemWrite => MemWrite,
    MemRead => MemRead,
    RegDst => RegDst,
    MemToReg => MemToReg,
    Jump => Jump,
    Branch => Branch
    );

  stim_proc: process

    type pattern_type is record
      input: std_logic_vector(5 downto 0);
      RegWrite: std_logic;
      AluOp: std_logic_vector(1 downto 0);
      AluSrc: std_logic;
      MemWrite: std_logic;
      MemRead: std_logic;
      RegDst: std_logic;
      MemToReg: std_logic;
      Jump: std_logic;
      Branch: std_logic;
    end record;

    type pattern_array is array (natural range <>) of pattern_type;

    constant patterns: pattern_array := (
      -- addi $0, $0, 0 (opcode = 001000)
      (
        input => "001000",
        RegWrite => '1', 
        AluOp => "00",
        AluSrc => '1',
        MemWrite => '0',
        MemRead => '0',
        RegDst => '0',
        MemToReg => '0',
        Jump => '0',
        Branch => '0'
      ),
      -- sw $6, 0($4) (opcode = 101011)
      (
        input => "101011",
        RegWrite => '0',
        AluOp => "00",
        AluSrc => '1',
        MemWrite => '1',
        MemRead => '0',
        RegDst => '0',
        MemToReg => '0',
        Jump => '0',
        Branch => '0'
      ),
      -- bne $5, $0, L1 (opcode = 000101)
      (
        input => "000101",
        RegWrite => '0',
        AluOp => "01",
        AluSrc => '0',
        MemWrite => '0',
        MemRead => '0',
        RegDst => '0', 
        MemToReg => '0',
        Jump => '0',
        Branch => '1'
      )
    );

  begin
    clk <= '0';
    wait for 5 ns;
    clk <= '1';
    wait for 5 ns;

    for i in patterns'range loop
      input <= patterns(i).input;

      wait for 10 ns;

      assert RegWrite = patterns(i).RegWrite
      report "unexpected RegWrite value for index " & integer'image(i)
      severity error;

      assert AluOp = patterns(i).AluOp
      report "unexpected AluOp value for index " & integer'image(i)
      severity error;

      assert AluSrc = patterns(i).AluSrc
      report "unexpected AluSrc value for index " & integer'image(i)
      severity error;

      assert MemWrite = patterns(i).MemWrite
      report "unexpected MemWrite value for index " & integer'image(i)
      severity error;

      assert MemRead = patterns(i).MemRead
      report "unexpected MemRead value for index " & integer'image(i)
      severity error;

      assert RegDst = patterns(i).RegDst
      report "unexpected RegDst value for index " & integer'image(i)
      severity error;

      assert MemToReg = patterns(i).MemToReg
      report "unexpected MemToReg value for index " & integer'image(i)
      severity error;

      assert Jump = patterns(i).Jump
      report "unexpected Jump value for index " & integer'image(i)
      severity error;

      assert Branch = patterns(i).Branch
      report "unexpected Branch value for index " & integer'image(i)
      severity error;
    end loop;

    report "end of simulation"
    severity note;
    wait;

  end process;

end architecture behavioral;
