LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY data_memory IS
	PORT (
		clk : IN STD_LOGIC;--falling edge
		write_en : IN STD_LOGIC;
		addr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		is_32_bit : IN STD_LOGIC;
		data_in_16 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		data_in_32 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		data_out_16 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		data_out_32 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END data_memory;
ARCHITECTURE data_memory OF data_memory IS
	TYPE ram_type IS ARRAY (0 TO 2 ** 20 - 1) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL ram_data : ram_type;
	SIGNAL data_16_reg : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL data_32_reg : STD_LOGIC_VECTOR(31 DOWNTO 0);
BEGIN
	data_out_16 <= data_16_reg;
	data_out_32 <= data_32_reg;

	--read form memory
	PROCESS (clk)
	BEGIN
		IF rising_edge(clk) THEN
			--data_32_reg <= ram_data(to_integer(unsigned(addr))) & ram_data(to_integer(unsigned(addr) + 1));--little endian
			data_16_reg <= ram_data(to_integer(unsigned(addr)));
		END IF;
	END PROCESS;

	--write to memory
	PROCESS (clk)
	BEGIN
		IF rising_edge(clk) THEN
			IF write_en = '1' THEN
				IF is_32_bit = '1' THEN
					ram_data(to_integer(unsigned(addr))) <= data_in_32(31 DOWNTO 16);--little endian
					ram_data(to_integer(unsigned(addr) + 1)) <= data_in_32(15 DOWNTO 0);
				ELSE
					ram_data(to_integer(unsigned(addr))) <= data_in_16;
				END IF;
			END IF;
		END IF;
	END PROCESS;
END data_memory;