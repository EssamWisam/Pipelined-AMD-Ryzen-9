library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FU is
    port(

        -- The two output selectors, they work in the same way, each selects mux input to be the Rsrc data or the forwarded data
        sel1,sel2: out std_logic_vector(1 downto 0);
        
        -- ID_EX_Rdst  : current instruction destination index
        -- ID_EX_Rsrc1 : current instruction src1 index
        -- ID_EX_Rsrc2 : current instruction src2 index
        ID_EX_Rdst,ID_EX_Rsrc1,ID_EX_Rsrc2: in std_logic_vector(2 downto 0);

        -- EX_MEM_Rdst : previous instruction destination index 
        -- MEM_WB_Rdst : before-previous instruction destination index 
        EX_MEM_Rdst,MEM_WB_Rdst: in std_logic_vector(2 downto 0)
    );
end FU;


architecture FU of FU is
begin
    -- if (input instruction Rsrc == previous instruction Rdst)
    -- then 
        --> select the alu-to-alu forwarded signal
    -- else
        --> if (input instruction Rsrc == before-previous instruction Rdst)
        -- then 
            --> select the mem-to-alu forwarded signal
        -- else
            -- select the input data, no forwarding takes place
    
    sel1<=  "10" when (ID_EX_Rsrc1=EX_MEM_Rdst) else
            "01" when (ID_EX_Rsrc1=MEM_WB_Rdst) else
            "00" ;
    sel2<=  "10" when (ID_EX_Rsrc2=EX_MEM_Rdst) else
            "01" when (ID_EX_Rsrc2=MEM_WB_Rdst) else
            "00";
end FU ; 