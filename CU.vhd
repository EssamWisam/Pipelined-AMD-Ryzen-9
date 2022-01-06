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

    --signal 

begin
    
end ControlUnit ; -- ControlUnit