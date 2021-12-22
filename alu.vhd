library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity alu is
	port (
		clk : in std_logic;
		a : in std_logic_vector(15 downto 0);
		b : in std_logic_vector(15 downto 0);
		op : in std_logic_vector(2 downto 0);
		result : out std_logic_vector(15 downto 0)
	);
end alu;
architecture alu of alu is
begin
	process (clk)
	begin
		if rising_edge(clk) then
			if op = "000" then
				result <= a;
			elsif op = "001" then
				result <= b;
			elsif op = "010" then
				result <= a and b;
			elsif op = "011" then
				result <= std_logic_vector(unsigned(a) + unsigned(b));
			elsif op = "100" then
				result <= std_logic_vector(unsigned(a) - unsigned(b));
			elsif op = "101" then
				result <= std_logic_vector(unsigned(a) + 1);
				-- add set carry
			elsif op = "111" then
				result <= not a;
			end if;
		end if;
	end process;
end alu;