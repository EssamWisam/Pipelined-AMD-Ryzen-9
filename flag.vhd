library ieee;
use ieee.std_logic_1164.all;
 
entity flag_reg is
   port( 
      clk,rst : in std_logic;
      save,restore : in std_logic;
      flag_in : in std_logic_vector(3 downto 0);
      flag_out : out std_logic_vector(3 downto 0)
   );
end flag_reg;
 
architecture a_flag_reg of flag_reg is
   signal tempFlag: std_logic_vector (3 downto 0);
   
begin
   
   process (clk,rst)
   begin
      if rst = '1' then
         flag_out <= (others=>'0');
         tempFlag <= (others=>'0');
         elsif rising_edge(clk) and save='1' then
            tempFlag<=flag_in;
            flag_out <= flag_in;
         elsif rising_edge(clk) and restore='1' then
            flag_out<=tempFlag;
            tempFlag<=(others=>'0');
         elsif rising_edge(clk) then
            flag_out<=flag_in;
         end if;
   end process; 
end a_flag_reg;
 