library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity HDU is
    port(
 
        CS_ID_EX   :   in STD_LOGIC_VECTOR(27 DOWNTO 0);	
        CS_EX_MEM  :   in STD_LOGIC_VECTOR(27 DOWNTO 0);	
        CS_MEM_WB  :   in STD_LOGIC_VECTOR(27 DOWNTO 0);
        

        IF_ID_Rsrc1,IF_ID_Rsrc2            : in std_logic_vector(2 downto 0);
    
        ID_EX_Rdst,EX_MEM_Rdst,MEM_WB_Rdst : in std_logic_vector(2 downto 0);
        	

         IF_ID_enable : out std_logic; 
         freeze       : out std_logic;
         ID_EX_FLUSH  : OUT STD_LOGIC
    );
end HDU;


architecture HDU of HDU is
begin
    
    IF_ID_enable<=  '0' when (CS_ID_EX ="0000000000000100100000101101" and (IF_ID_Rsrc1=ID_EX_Rdst  or IF_ID_Rsrc2=ID_EX_Rdst )) else
                    '0' when (CS_EX_MEM="0000000000000100100000101101" and (IF_ID_Rsrc1=EX_MEM_Rdst or IF_ID_Rsrc2=EX_MEM_Rdst)) else
                    --'0' when (CS_MEM_WB="0000000000000100100000101101" and (IF_ID_Rsrc1=MEM_WB_Rdst or IF_ID_Rsrc2=MEM_WB_Rdst)) else
                    '1' ;
    
    freeze<=        '1' when (CS_ID_EX ="0000000000000100100000101101" and (IF_ID_Rsrc1=ID_EX_Rdst  or IF_ID_Rsrc2=ID_EX_Rdst )) else
                    '1' when (CS_EX_MEM="0000000000000100100000101101" and (IF_ID_Rsrc1=EX_MEM_Rdst or IF_ID_Rsrc2=EX_MEM_Rdst)) else
                    --'1' when (CS_MEM_WB="0000000000000100100000101101" and (IF_ID_Rsrc1=MEM_WB_Rdst or IF_ID_Rsrc2=MEM_WB_Rdst)) else
                    '0' ;
    
    ID_EX_FLUSH<=   '1' when (CS_ID_EX ="0000000000000100100000101101" and (IF_ID_Rsrc1=ID_EX_Rdst  or IF_ID_Rsrc2=ID_EX_Rdst )) else
                    '1' when (CS_EX_MEM="0000000000000100100000101101" and (IF_ID_Rsrc1=EX_MEM_Rdst or IF_ID_Rsrc2=EX_MEM_Rdst)) else
                    --'1' when (CS_MEM_WB="0000000000000100100000101101" and (IF_ID_Rsrc1=MEM_WB_Rdst or IF_ID_Rsrc2=MEM_WB_Rdst)) else
                    '0' ;

end HDU; 