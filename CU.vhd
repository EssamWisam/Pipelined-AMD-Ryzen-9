library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CU is
  port (
        clk : in std_logic ;
        inOpcode    : in std_logic_vector (6 downto 0);
        outOpsrc    : out std_logic;
        outTFAOI    : out std_logic;
        outMEMW     : out std_logic;
        outWF       : out std_logic;
        outWB       : out std_logic;
        outSaveF    : out std_logic;
        outResF     : out std_logic;
        outWirteOut : out std_logic;
        outBit1     : out std_logic;
        outFreeze   : out std_logic;
        outCond     : out std_logic;
        outEXP1     : out std_logic;
        outEXP2     : out std_logic;
        outPCsrc    : out std_logic_vector (1 downto 0);
        outSPA      : out std_logic_vector (2 downto 0);
        outAddSrc   : out std_logic_vector (1 downto 0);
        outALUOP    : out std_logic_vector (2 downto 0);
        outPCC      : out std_logic_vector (1 downto 0);
        outJM       : out std_logic_vector (2 downto 0)
  ) ;
end CU;


architecture ControlUnit of CU is

     
  signal selALUOP : std_logic_vector(4 downto 0);
  
  signal A: std_logic;
  signal B: std_logic;
  signal C: std_logic;
  signal D: std_logic;
  signal E: std_logic;
  signal F: std_logic;
  signal G: std_logic;

  signal classOneOP: std_logic;
  signal classTwoOP: std_logic;
  signal classMemOP: std_logic;
  signal classBranchOP: std_logic;

  signal CS: std_logic_vector(27 downto 0);

begin
  A <= inOpcode(6);
  B <= inOpcode(5);
  C <= inOpcode(4);
  D <= inOpcode(3);
  E <= inOpcode(2);
  F <= inOpcode(1);
  G <= inOpcode(0);
  
  classOneOp    <=  (not C) and  D      ; -- 01
  classTwoOp    <=  C and  (not D)      ; -- 10
  classMemOp    <=  (not C) and (not D) ; -- 00
  classBranchOp <=  C and D             ; -- 11


  with inOpcode select
    CS <=   "0000000000000100000000000000" when "0010000",  -- MOV
            "0000000000000100000000010100" when "0001100",  -- INC
            "0000000000000000000000011000" when "0001010",  -- SETC
            "0000000000000100000000001100" when "0010001",  -- ADD
            "0000000000000100000000010000" when "0010010",  -- SUB
            "0000000000000100000000001000" when "0010011",  -- AND
            "0000000000000100000000001101" when "1010100",  -- ADDI
            "0000000000000000001010100000" when "0000001",  -- PUSH
            "0000000000000100100100100000" when "0000010",  -- POP
            "0000000000000100000000000001" when "1000011",  -- LDM
            "0000000000000100100000001101" when "0000100",  -- LDD
            "0000000000000000000010001101" when "0000101",  -- STD        
            "0000010000000000000000000000" when "0001101", -- OUT
            "0000000000000000000000000010" when "0001110",  -- IN
            "0001000000000000000000000000" when "0001001",  -- HLT
            "0000000000000000000000000000" when "0001000",  -- NOP
            "0000000000000000000000011100" when "0001011",  -- NOT
            "0000000000100010000000000000" when "0011000",  -- JZ
            "0000000010100010000000000000" when "0011001",  -- JN
            "0000000100100010000000000000" when "0011010",  -- JC
            "0010000110100010000000000000" when "0011011",  -- JM
            "0000001000100010000000000000" when "0011100",  -- CALL
            "0000001010100001000000000000" when "0111101",  -- RET
            "0000001110110001000000000000" when "0111111",  -- RTI
            "0000001100101000000000000000" when "0011110",  -- INT
            (others=>'0')                when others;
    outOpsrc    <=CS(0);
    outTFAOI    <=CS(1);
    outALUOP    <=CS(4 downto 2);
    outAddSrc   <=CS(6 downto 5);
    outMEMW     <=CS(7);
    outSPA      <=CS(10 downto 8);
    outWF       <=CS(11);
    outPCsrc    <=CS(13 downto 12);
    outWB       <=CS(14);
    outSaveF    <=CS(15);
    outResF     <=CS(16);
    outPCC      <=CS(18 downto 17);
    outJM       <=CS(21 downto 19);
    outWirteOut <=CS(22);
    outBit1     <=CS(23);
    outFreeze   <=CS(24);
    outCond     <=CS(25);
    outEXP1     <=CS(26);
    outEXP2     <=CS(27);
   
end ControlUnit ; -- ControlUnit