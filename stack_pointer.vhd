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
				address_reg <= x"000fffff";
			else
				if operation = "001" then
					address_reg_temp_pop <= address_reg;
					address_reg <= std_logic_vector(unsigned(address_reg) + 1);
				elsif operation = "010" then
					address_reg_temp_pop <= address_reg;
					address_reg <= std_logic_vector(unsigned(address_reg) - 1);
				elsif operation = "011" then
					address_reg_temp_pop <= address_reg;
					address_reg <= std_logic_vector(unsigned(address_reg) + 2);
				elsif operation = "100" then
					address_reg_temp_pop <= address_reg;
					address_reg <= std_logic_vector(unsigned(address_reg) - 2);
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