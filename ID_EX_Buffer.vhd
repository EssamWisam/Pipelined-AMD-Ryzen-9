library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ID_EX_Buffer is
  port (
    clk:in std_logic ;
    
    inCS            : in std_logic_vector   (27 downto 0);
    inG             : in std_logic_vector   (27 downto 0);
    inRdst_index    : in std_logic_vector   (2  downto 0);
    inRsrc_data1    : in std_logic_vector   (15 downto 0);
    inRsrc_data2    : in std_logic_vector   (15 downto 0);
    inImm           : in std_logic_vector   (15 downto 0);
    inInt_index     : in std_logic_vector   (1  downto 0);
    inRsrc1_index   : in std_logic_vector   (2  downto 0);
    inRsrc2_index   : in std_logic_vector   (2  downto 0);
    inPC            : in std_logic_vector   (31 downto 0);

    outCS           : out std_logic_vector   (27 downto 0);
    outG            : out std_logic_vector   (27 downto 0);
    outRdst_index   : out std_logic_vector   (2  downto 0);
    outRsrc_data1   : out std_logic_vector   (15 downto 0);
    outRsrc_data2   : out std_logic_vector   (15 downto 0);
    outImm          : out std_logic_vector   (15 downto 0);
    outInt_index    : out std_logic_vector   (1  downto 0);
    outRsrc1_index  : out std_logic_vector   (2  downto 0);
    outRsrc2_index  : out std_logic_vector   (2  downto 0);
    outPC           : out std_logic_vector   (31 downto 0 )

  );
end ID_EX_Buffer;

architecture ID_EX of ID_EX_Buffer is

    signal not_clk       : std_logic                       ;
    signal CS            : std_logic_vector   (27 downto 0);
    signal G             : std_logic_vector   (27 downto 0);
    signal Rdst_index    : std_logic_vector   (2  downto 0);
    signal Rsrc_data1    : std_logic_vector   (15 downto 0);
    signal Rsrc_data2    : std_logic_vector   (15 downto 0);
    signal Imm           : std_logic_vector   (15 downto 0);
    signal Int_index     : std_logic_vector   (1  downto 0);
    signal Rsrc1_index   : std_logic_vector   (2  downto 0);
    signal Rsrc2_index   : std_logic_vector   (2  downto 0);
    signal PC            : std_logic_vector   (31 downto 0);

begin
  process (clk)
	begin
		if falling_edge(clk) then
            outCS           <= CS         ;
            outG            <= G          ;
            outRdst_index   <= Rdst_index ;
            outRsrc_data1   <= Rsrc_data1 ;
            outRsrc_data2   <= Rsrc_data2 ;
            outImm          <= Imm        ;
            outInt_index    <= Int_index  ;
            outRsrc1_index  <= Rsrc1_index;
            outRsrc2_index  <= Rsrc2_index;
            outPC           <= PC         ;        
		end if;
        
	end process;
  process (clk)
	begin
		if rising_edge(clk) then
            CS           <= inCS         ;
            G            <= inG          ;
            Rdst_index   <= inRdst_index ;
            Rsrc_data1   <= inRsrc_data1 ;
            Rsrc_data2   <= inRsrc_data2 ;
            Imm          <= inImm        ;
            Int_index    <= inInt_index  ;
            Rsrc1_index  <= inRsrc1_index;
            Rsrc2_index  <= inRsrc2_index;
            PC           <= inPC         ;        
		end if;
        
	end process;

end ID_EX ; -- ID_EX