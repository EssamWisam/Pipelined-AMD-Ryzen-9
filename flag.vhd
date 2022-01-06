library ieee;
use ieee.std_logic_1164.all;
 
entity flag_reg is
   port( 
      clk,rst : in std_logic;
      en : in std_logic;
      flag_in : in std_logic_vector(3 downto 0);
      flag_out : out std_logic_vector(3 downto 0)
   );
end flag_reg;
 
architecture a_flag_reg of flag_reg is
begin
   process (clk,rst,en)
      begin
         if rst = '1' then
            flag_out <= (others=>'0');
         elsif rising_edge(clk) and en='1' then
            flag_out <= flag_in;
         end if;
   end process; 
end a_flag_reg;
 