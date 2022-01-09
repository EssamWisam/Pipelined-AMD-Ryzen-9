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
	signal result_regz : std_logic_vector(15 downto 0);
	signal flag_regz :  std_logic_vector(3 downto 0);
begin
	--logic
	process (clk)
	variable result_reg : std_logic_vector(15 downto 0);
	variable flag_reg :  std_logic_vector(3 downto 0);
	begin
		if rising_edge(clk) then
			if op = "000" then			-- forward upper
				result_reg := a;
			elsif op = "001" then		-- forward loer
				result_reg := b;
			elsif op = "010" then		-- and
				result_reg := a and b;
				flag_reg(3) := '1' when result_reg = x"0000" else '0';					--zero flag
				flag_reg(2) := result_reg(15); 													--sign flag
			elsif op = "011" then		-- add
				(flag_reg(1 downto 0), result_reg) := std_logic_vector(unsigned("00" & a) + unsigned("00" & b));
				flag_reg(3) := '1' when result_reg = x"0000" else '0';					
				flag_reg(2) := result_reg(15); 													
			elsif op = "100" then		-- subtract
				(flag_reg(1 downto 0), result_reg) := std_logic_vector(unsigned("00" & a) - unsigned("00" & b));
				flag_reg(3) := '1' when result_reg = x"0000" else '0';					
				flag_reg(2) := result_reg(15); 													
			elsif op = "101" then		-- increment
				result_reg := std_logic_vector(unsigned(a) + 1);
				flag_reg(3) := '1' when result_reg = x"0000" else '0';					
				flag_reg(2) := result_reg(15);
			elsif  op = "110" then		--setc
				flag_reg(1 downto 0) := "01";
			elsif op = "111" then		--not
				result_reg := not a;
				flag_reg(3) := '1' when result_reg = x"0000" else '0';					
				flag_reg(2) := result_reg(15); 													
			end if;
		end if;
		result_regz <= result_reg;
		flag_regz <= flag_reg;
	end process;
	--out
	result <= result_regz;
	flag_in <= flag_regz;


end alu;