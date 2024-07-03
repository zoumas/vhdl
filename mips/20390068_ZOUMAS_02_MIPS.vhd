-- 20390068_ZOUMAS_02_MIPS.vhd
-- Implementation of MIPS processor

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mips is
    port (
        clk, rst: in std_logic
    );
end entity mips;

architecture behavioral of mips is

    component adder32 is port (
      i0, i1: in std_logic_vector(31 downto 0);
      ci: in std_logic_vector(0 downto 0);
      s: out std_logic_vector(31 downto 0)
    );
    end component adder32;

    component alu is port (
      i0, i1: in std_logic_vector(31 downto 0);
      op: in std_logic_vector(3 downto 0);
      zero: out std_logic;
      result: out std_logic_vector(31 downto 0)
    );
    end component alu;

    component pc is port (
      input: in std_logic_vector(31 downto 0);
      clk, rst: in std_logic;
      output: out std_logic_vector(31 downto 0)
    );
    end component pc;

    component imem is port (
      addr: in std_logic_vector(31 downto 0);
      instruction: out std_logic_vector(31 downto 0)
    );
    end component imem;

    component register_file is port (
      RegIn1, RegIn2, RegToWrite: in std_logic_vector(4 downto 0);
      RegWrite: in std_logic;
      DataToWrite: in std_logic_vector(31 downto 0);
      RegOut1, RegOut2: out std_logic_vector(31 downto 0)
    );
    end component register_file;

    component alu_control is port (
      op : in std_logic_vector(1 downto 0);
      funct : in std_logic_vector(5 downto 0);
      ctrl : out std_logic_vector(3 downto 0)
    );
    end component alu_control;

    component control is port (
      clk: in std_logic;
      input: in std_logic_vector(5 downto 0);
      AluOp: out std_logic_vector(1 downto 0);
      AluSrc,
      MemWrite,
      MemRead,
      RegDst,
      RegWrite,
      MemToReg,
      Jump,
      Branch: out std_logic
    );
    end component control;

    component data_mem is port (
      clk, rst: in std_logic;
      input, WriteData: in std_logic_vector(31 downto 0);
      MemRead, MemWrite: in std_logic;
      output: out std_logic_vector(31 downto 0)
    );
    end component data_mem;

    component mux2_5 is port (
      i0, i1: in std_logic_vector(4 downto 0); 
      o: out std_logic_vector(4 downto 0);
      sel: in std_logic
    );
    end component mux2_5;

    component mux2_32 is port (
      i0, i1: in std_logic_vector(31 downto 0);
      o: out std_logic_vector(31 downto 0);
      sel: in std_logic
    );
    end component mux2_32;

    component signext is port (
      input: in std_logic_vector(15 downto 0);
      output: out std_logic_vector(31 downto 0)
    );
    end component signext;

    signal
        RegWrite,
        ALUSrc,
        MemWrite,
        MemRead,
        RegDst,
        MemToReg,
        Jump,
        Zero,
        Branch,
        BranchTaken: std_logic;

    signal AluOp: std_logic_vector(1 downto 0);
    signal ALUControl_OUT: std_logic_vector(3 downto 0);
    signal MUX_REG_OUT: std_logic_vector(4 downto 0);

    signal
        PC_FA_IM, -- ProgramCounter -> FullAdder / InstructionMemory
        FA_PC_OUT,
        IM_OUT,
        ONE,
        ALU_OUT,
        RegOut1,
        RegOut2,
        DataToWrite,
        MUX_ALU_OUT,
        SignExt_OUT,
        RAM_OUT,
        ShiftJump2MuxJump,
        MuxJump2PC,
        MuxBranch2MuxJump,
        ALU_Branch_OUT: std_logic_vector(31 downto 0);

begin
    ONE <= std_logic_vector(to_unsigned(1, 32));

    FA_PC: adder32 port map(
      i0 => PC_FA_IM,
      i1 => ONE,
      ci => "0",
      s => FA_PC_OUT
    );

    FA_BRANCH: adder32 port map(
      i0 => FA_PC_OUT,
      i1 => SignExt_OUT,
      ci => "0",
      s => ALU_Branch_OUT
    );

    pc_inst: pc port map(
      input => MuxJump2PC,
      clk => clk,
      rst => rst,
      output => PC_FA_IM
    );

    imem_inst: imem port map(
      addr => PC_FA_IM,
      instruction => IM_OUT
    );

    register_file_inst: register_file port map(
      RegIn1 => IM_OUT(25 downto 21),
      RegIn2 => IM_OUT(20 downto 16),
      RegToWrite => MUX_REG_OUT,
      RegWrite => RegWrite,
      DataToWrite => DataToWrite,
      RegOut1 => RegOut1,
      RegOut2 => RegOut2
    );

    control_inst: control port map(
      clk => clk,
      input => IM_OUT(31 downto 26),
      RegWrite => RegWrite,
      AluOp => AluOp,
      AluSrc => ALUSrc,
      MemWrite => MemWrite,
      MemRead => MemRead,
      RegDst => RegDst,
      MemToReg => MemToReg,
      Jump => Jump,
      Branch => Branch
    );

    alu_control_inst: alu_control port map(
      op => AluOp,
      funct => IM_OUT(5 downto 0),
      ctrl => ALUControl_OUT
    );

    alu_inst: alu port map(
      i0 => RegOut1,
      i1 => MUX_ALU_OUT,
      op => ALUControl_OUT,
      zero => Zero,
      result => ALU_OUT
    );

    data_mem_inst: data_mem port map(
      clk => clk,
      rst => rst,
      input => ALU_OUT,
      WriteData => RegOut2,
      MemRead => MemRead,
      MemWrite => MemWrite,
      output => RAM_OUT
    );

    MUX_REG: mux2_5 port map(
      i0 => IM_OUT(20 downto 16),
      i1 => IM_OUT(15 downto 11),
      o => MUX_REG_OUT,
      sel => RegDst
    );

    MUX_ALU_IN: mux2_32 port map(
      i0 => RegOut2,
      i1 => SignExt_OUT,
      o => MUX_ALU_OUT,
      sel => ALUSrc
    );

    MUX_RAM: mux2_32 port map(
      i0 => ALU_OUT,
      i1 => RAM_OUT,
      o => DataToWrite,
      sel => MemToReg
    );

    ShiftJump2MuxJump <= FA_PC_OUT(31 downto 28) & IM_OUT(25 downto 0) & "00";

    MUX_JUMP: mux2_32 port map(
      i0 => MuxBranch2MuxJump,
      i1 => ShiftJump2MuxJump,
      o => MuxJump2PC,
      sel => Jump
    );

    BranchTaken <= Branch and Zero;

    MUX_BRANCH: mux2_32 port map(
      i0 => FA_PC_OUT,
      i1 => ALU_Branch_OUT,
      o => MuxBranch2MuxJump,
      sel => BranchTaken
    );

    signext_inst: signext port map(
      input => IM_OUT(15 downto 0),
      output => SignExt_OUT
    );

end architecture behavioral;
