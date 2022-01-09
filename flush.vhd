library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity flush is
	port (
		clk : in std_logic;
		pcc : in std_logic;
		jm : in std_logic_vector(2 downto 0);
		Cond : in std_logic;
      	flush_jmp : out std_logic;
      	flush_call : out std_logic
	);
end flush;

architecture flush of flush is
	signal jmp_reg : std_logic;
   signal call_reg : std_logic;
begin
	--logic
	process (clk)
	begin
		if rising_edge(clk) then
         if pcc='1' and Cond='1' then        -- need to check that 0<=jmp<=4
            jmp_reg <= '1';
		   else
			   jmp_reg <='0';
            call_reg <= '0';
         end if;
		end if;
	end process;
	flush_jmp <= jmp_reg;
   flush_call <= call_reg;
end flush;