library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity alu is
	port (
		clk : in std_logic;
		a : in std_logic_vector(15 downto 0);
		b : in std_logic_vector(15 downto 0);
		op : in std_logic_vector(2 downto 0);
		result : out std_logic_vector(15 downto 0);
		flag_in : out std_logic_vector(3 downto 0)
	);
end alu;
architecture alu of alu is
	signal result_reg : std_logic_vector(15 downto 0);
begin
	--logic
	process (clk)
	begin
		if rising_edge(clk) then
			if op = "000" then			-- forward upper
				result_reg <= a;
			elsif op = "001" then		-- forward loer
				result_reg <= b;
			elsif op = "010" then		-- and
				result_reg <= a and b;
				flag_in(3) <= '1' when result = x"0000" else '0';					--zero flag
				flag_in(2) <= result(15); 													--sign flag
			elsif op = "011" then		-- add
				(flag_in(1 downto 0), result_reg) <= std_logic_vector(unsigned("00" & a) + unsigned("00" & b));
				flag_in(3) <= '1' when result = x"0000" else '0';					
				flag_in(2) <= result(15); 													
			elsif op = "100" then		-- subtract
				(flag_in(1 downto 0), result_reg) <= std_logic_vector(unsigned("00" & a) - unsigned("00" & b));
				flag_in(3) <= '1' when result = x"0000" else '0';					
				flag_in(2) <= result(15); 													
			elsif op = "101" then		-- increment
				result_reg <= std_logic_vector(unsigned(a) + 1);
				flag_in(3) <= '1' when result = x"0000" else '0';					
				flag_in(2) <= result(15);
			elsif op = "111" then		--not
				result_reg <= not a;
				flag_in(3) <= '1' when result = x"0000" else '0';					
				flag_in(2) <= result(15); 													
			end if;
		end if;
	end process;
	--out
	result <= result_reg;


end alu;