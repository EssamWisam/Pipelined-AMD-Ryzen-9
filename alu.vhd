LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY alu IS
	PORT (
		clk : IN STD_LOGIC;--faling edge
		a : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		b : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		op : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		result : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END alu;
ARCHITECTURE alu OF alu IS
	SIGNAL result_reg : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL not_clk : STD_LOGIC;
BEGIN
	--logic
	not_clk <= NOT clk;
	PROCESS (clk)
	BEGIN
		--TODO:add flag register logic
		IF rising_edge(clk) THEN
			IF op = "000" THEN
				result_reg <= a;
			ELSIF op = "001" THEN
				result_reg <= b;
			ELSIF op = "010" THEN
				result_reg <= a AND b;
			ELSIF op = "011" THEN
				result_reg <= STD_LOGIC_VECTOR(unsigned(a) + unsigned(b));
			ELSIF op = "100" THEN
				result_reg <= STD_LOGIC_VECTOR(unsigned(a) - unsigned(b));
			ELSIF op = "101" THEN
				result_reg <= STD_LOGIC_VECTOR(unsigned(a) + 1);
				-- add set carry
			ELSIF op = "111" THEN
				result_reg <= NOT a;
			END IF;
		END IF;
	END PROCESS;
	--out
	result <= result_reg;

END alu;