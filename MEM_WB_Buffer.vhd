library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MEM_WB_Buffer is
  port (
    clk:in std_logic ;
    
    inCS           : in std_logic_vector   (27 downto 0);
    inG            : in std_logic_vector   (27 downto 0);
    inRdst_index   : in std_logic_vector   (2  downto 0);
    inRsrc_data1   : in std_logic_vector   (15 downto 0);
    inData16       : in std_logic_vector   (15 downto 0);
    inResult       : in std_logic_vector   (15 downto 0);
    inData32       : in std_logic_vector   (31 downto 0);
    inG2           : in std_logic_vector   (1  downto 0);
    inG3           : in std_logic_vector   (2  downto 0);
    inG4           : in std_logic_vector   (2  downto 0);

    outCS           : out std_logic_vector   (27 downto 0);
    outRdst_index   : out std_logic_vector   (2  downto 0);
    outResult       : out std_logic_vector   (15 downto 0);
    outData32       : out std_logic_vector   (31 downto 0 )
    --outInt_index    : out std_logic_vector   (1  downto 0);
    --outRsrc1_index  : out std_logic_vector   (2  downto 0);
    --outRsrc2_index  : out std_logic_vector   (2  downto 0);
    --outRsrc_data1   : out std_logic_vector   (15 downto 0);
    --outRsrc_data2   : out std_logic_vector   (15 downto 0);

  );
end MEM_WB_Buffer;

architecture MEM_WB of MEM_WB_Buffer is

    signal not_clk       : std_logic                       ;
    signal CS            : std_logic_vector   (27 downto 0);
    signal Rdst_index    : std_logic_vector   (2  downto 0);
    signal Result        : std_logic_vector   (15 downto 0);
    signal Data16        : std_logic_vector   (15 downto 0);
    signal Data32        : std_logic_vector   (31 downto 0);
    signal Rsrc_data1    : std_logic_vector   (15 downto 0);
    signal G             : std_logic_vector   (27 downto 0);
    signal G2            : std_logic_vector   (1  downto 0);
    signal G3            : std_logic_vector   (2  downto 0);
    signal G4            : std_logic_vector   (2  downto 0);

begin
--   process (clk)
-- 	begin
-- 		if falling_edge(clk) then
            outCS           <= CS           ;
            outRdst_index   <= Rdst_index   ;
            outResult       <= Result       ;
            outData32       <= Data32       ;
--		end if;
        
--	end process;
  process (clk)
	begin
		if rising_edge(clk) then
            CS          <= inCS        ;
            Rdst_index  <= inRdst_index;
            Result      <= inResult    ;
            Data16      <= inData16    ;
            Data32      <= inData32    ;
            Rsrc_data1  <= inRsrc_data1;
            G           <= inG         ;
            G2          <= inG2        ;
            G3          <= inG3        ;        
            G4          <= inG4        ;
		end if;
        
	end process;

end MEM_WB ; -- MEM_WB