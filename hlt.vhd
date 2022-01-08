library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity frz is
	port (
		clk, rst : in std_logic;
		opcode : in std_logic_vector (4 downto 0);
      freeze : out std_logic
	);
end frz;

architecture frz of frz is
	signal freeze_reg : std_logic;
   signal is_hlt : std_logic;
begin
	--logic
	process (clk)
	begin
		if rising_edge(clk) then 
			if opcode="01001" then		--HLT               
				freeze_reg <= '1';
				is_hlt <= '1';
			elsif is_hlt = '0' or rst = '1' then
				freeze_reg <= '0';
			end if;
		end if;
	end process;
	--out
	freeze <= freeze_reg;
end frz;