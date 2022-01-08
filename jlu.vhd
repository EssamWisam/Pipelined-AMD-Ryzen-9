library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity jlu is
	port (
		clk : in std_logic;
		pcc : in std_logic;
		flag_out: in std_logic_vector(3 downto 0);
		jm : in std_logic_vector(2 downto 0);
		Cond : out std_logic;
      flag_in : out std_logic_vector(3 downto 0)
	);
end jlu;

architecture jlu of jlu is
	signal Cond_reg : std_logic;
begin
	--logic
	process (clk)
	begin
		if rising_edge(clk) then 
			if pcc='1' then
				if jm = "000" and flag_out(3)='1' then			      	-- Check if zero
					Cond_reg <= '1';
					flag_in(3) <= '0';
				elsif jm = "001" and flag_out(2)='1' then					-- Check if negative
					Cond_reg <= '1';
					flag_in(2) <= '0';
				elsif jm = "010" and (flag_out(1 downto 0)="11" or flag_out(1 downto 0)="01") then	-- Check if carry
					Cond_reg <= '1';
					flag_in(1 downto 0) <= "00";
				elsif jm = "011" then
					Cond_reg <= '1';
					flag_in <= flag_out;
				else
					Cond_reg <= '0';										 		-- Still haven't considered other PC changers
				end if;
			else
				Cond_reg <='0';														-- Cond = 0 for non PC changers.
			end if;
		end if;
	end process;
	--out
	Cond <= Cond_reg;
end jlu;