library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IF_ID_Buffer is
  port (
    clk:in std_logic ;
    rst:in std_logic ;
    enable:in std_logic ;
    inInstruction   : in std_logic_vector   (15 downto 0);
    inImm           : in std_logic_vector   (15 downto 0);
    inPC            : in std_logic_vector   (31 downto 0);
    inG             : in std_logic_vector   (63 downto 0);

    outOpCode       : out std_logic_vector   (6  downto 0);
    outImm          : out std_logic_vector   (15 downto 0);
    outRdst_index   : out std_logic_vector   (2  downto 0);
    outRsrc1_index  : out std_logic_vector   (2  downto 0);
    outRsrc2_index  : out std_logic_vector   (2  downto 0);
    outInt_index    : out std_logic_vector   (1  downto 0);
    outPC           : out std_logic_vector   (31 downto 0)
    --outG            : out std_logic_vector   (59 downto 0)
  );
end IF_ID_Buffer;

architecture IF_ID of IF_ID_Buffer is

    signal not_clk       : std_logic;
    signal G             : std_logic_vector   (63 downto 0);
    signal opCode        : std_logic_vector   (6 downto 0);
    signal Imm           : std_logic_vector   (15 downto 0);
    signal Rdst_index    : std_logic_vector   (2  downto 0);
    signal Rsrc1_index   : std_logic_vector   (2  downto 0);
    signal Rsrc2_index   : std_logic_vector   (2  downto 0);
    signal Int_index     : std_logic_vector   (1  downto 0);
    signal PC            : std_logic_vector   (31 downto 0);

begin

            outOpCode       <= opCode     ;
            outImm          <= Imm        ;
            outRdst_index   <= Rdst_index ;
            outRsrc1_index  <= Rsrc1_index;
            outRsrc2_index  <= Rsrc2_index;
            outInt_index    <= Int_index  ;
            outPC           <= PC;        

  process (clk,rst,enable)
	begin
		if rising_edge(clk) then
      if (enable /= '0' and  rst /= '1') then
            opCode       <= inInstruction (6  downto  0) ;
            Rdst_index   <= inInstruction (9  downto  7) ;
            Rsrc1_index  <= inInstruction (12 downto 10) ;
            Rsrc2_index  <= inInstruction (15 downto 13) ;
            Int_index    <= inInstruction (11 downto 10) ;
            Imm          <= inImm ;
            PC           <= inPC ;        
            G            <= inG ;
      end if; 
      if (rst = '1') then 
            opCode       <= (others=>'0');
            Rdst_index   <= (others=>'0');
            Rsrc1_index  <= (others=>'0');
            Rsrc2_index  <= (others=>'0');
            Int_index    <= (others=>'0');
            Imm          <= (others=>'0');
            PC           <= (others=>'0');      
            G            <= (others=>'0');       
      end if;     
		end if;    
	end process;




end IF_ID ; 