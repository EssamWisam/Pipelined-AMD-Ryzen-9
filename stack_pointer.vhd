library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity stack_module is
	port (
		clk : in std_logic;--rising edge
		rst : in std_logic;
		operation : in std_logic_vector(2 downto 0);
		address : out std_logic_vector(31 downto 0)
	);
end stack_module;

architecture stack_module of stack_module is
	signal address_reg : std_logic_vector(31 downto 0);
	signal address_reg_temp_pop : std_logic_vector(31 downto 0);
begin
	--stack pointer logic
	process (clk)
	begin
		if rising_edge(clk) then
			if rst = '1' then
				address_reg_temp_pop <= x"00100000";
				address_reg <= x"000fffff";
			else
				if operation = "001" then
					address_reg_temp_pop <= address_reg;
					address_reg <= std_logic_vector(unsigned(address_reg) + 1);		-- pop 16-bit
				elsif operation = "010" then
					address_reg_temp_pop <= address_reg;
					address_reg <= std_logic_vector(unsigned(address_reg) - 1);		-- push 16-bit
				elsif operation = "011" then
					address_reg_temp_pop <= address_reg;
					address_reg <= std_logic_vector(unsigned(address_reg) + 2);		-- pop 32-bit
				elsif operation = "100" then
					address_reg_temp_pop <= address_reg;
					address_reg <= std_logic_vector(unsigned(address_reg) - 2);		-- push 32-bit
				end if;
			end if;
		end if;
	end process;
	--out
	with operation select
		address <=
		address_reg when "010",
		address_reg when "100",
		address_reg_temp_pop when others;
end stack_module;