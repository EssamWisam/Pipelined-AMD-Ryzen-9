library ieee;
use ieee.std_logic_1164.all;
 
entity EPC_reg is
   port( 
      clk,rst : in std_logic;
      excepting_inst_in : in std_logic_vector(31 downto 0);
      excepting_inst_out : out std_logic_vector(31 downto 0)
   );
end EPC_reg;
 
architecture a_EPC_reg of EPC_reg is
begin
   process (clk,rst)
      begin
         if rst = '1' then
            excepting_inst_out <= (others=>'U');
         elsif rising_edge(clk) then
            excepting_inst_out <= excepting_inst_in;
         end if;
   end process; 
end a_EPC_reg;
 