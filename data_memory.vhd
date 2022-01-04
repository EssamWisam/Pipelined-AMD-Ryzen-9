library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity data_memory is
	port (
		clk : in std_logic;--falling edge
		write_en : in std_logic;
		addr : in std_logic_vector(31 downto 0);
		is_32_bit : in std_logic;
		data_in_16 : in std_logic_vector(15 downto 0);
		data_in_32 : in std_logic_vector(31 downto 0);
		data_out_16 : out std_logic_vector(15 downto 0);
		data_out_32 : out std_logic_vector(31 downto 0)
	);
end data_memory;
architecture data_memory of data_memory is
	type ram_type is array (0 to 2 ** 20 - 1) of std_logic_vector(15 downto 0);
	signal ram_data : ram_type;
	signal data_16_reg : std_logic_vector(15 downto 0);
	signal data_32_reg : std_logic_vector(31 downto 0);
begin
	data_out_16 <= data_16_reg;
	data_out_32 <= data_32_reg;
	--read form memory
	process (clk)
	begin
		if rising_edge(clk) then
			data_16_reg <= ram_data(to_integer(unsigned(addr)));
			if is_32_bit = '1' then
				data_32_reg(31 downto 16) <= ram_data(to_integer(unsigned(addr)));--upper endian
				data_32_reg(15 downto 0) <= ram_data(to_integer(unsigned(addr)) - 1);
			end if;
		end if;
	end process;

	--write to memory
	process (clk)
	begin
		if rising_edge(clk) then
			if write_en = '1' then
				if is_32_bit = '1' then
					ram_data(to_integer(unsigned(addr))) <= data_in_32(31 downto 16);--upper endian
					ram_data(to_integer(unsigned(addr)) - 1) <= data_in_32(15 downto 0);
				else
					ram_data(to_integer(unsigned(addr))) <= data_in_16;
				end if;
			end if;
		end if;
	end process;
end data_memory;