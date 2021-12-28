LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY stack_module IS
	PORT (
		clk : IN STD_LOGIC;--rising edge
		rst : IN STD_LOGIC;
		operation : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		address : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END stack_module;

ARCHITECTURE stack_module OF stack_module IS
	SIGNAL address_reg : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL address_reg_temp_pop : STD_LOGIC_VECTOR(31 DOWNTO 0);
BEGIN
	--stack pointer logic
	PROCESS (clk)
	BEGIN
		IF rising_edge(clk) THEN
			IF rst = '1' THEN
				address_reg <= x"000FFFFF";
			ELSE
				IF operation = "001" THEN
					address_reg_temp_pop <= address_reg;
					address_reg <= STD_LOGIC_VECTOR(unsigned(address_reg) + 1);
				ELSIF operation = "010" THEN
					address_reg_temp_pop <= address_reg;
					address_reg <= STD_LOGIC_VECTOR(unsigned(address_reg) - 1);
				ELSIF operation = "011" THEN
					address_reg_temp_pop <= address_reg;
					address_reg <= STD_LOGIC_VECTOR(unsigned(address_reg) + 2);
				ELSIF operation = "100" THEN
					address_reg_temp_pop <= address_reg;
					address_reg <= STD_LOGIC_VECTOR(unsigned(address_reg) - 2);
				END IF;
			END IF;
		END IF;
	END PROCESS;
	--out
	WITH operation SELECT
		address <=
		address_reg WHEN "010",
		address_reg WHEN "100",
		address_reg_temp_pop WHEN OTHERS;
END stack_module;