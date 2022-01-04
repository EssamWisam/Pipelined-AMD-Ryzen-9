library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity reg_file is
	port (
		clk : in std_logic;--falling edge
		rst : in std_logic;
		addr1 : in std_logic_vector(2 downto 0);
		addr2 : in std_logic_vector(2 downto 0);
		waddr : in std_logic_vector(2 downto 0);
		wdata : in std_logic_vector(15 downto 0);
		wren : in std_logic;
		rdata1 : out std_logic_vector(15 downto 0);
		rdata2 : out std_logic_vector(15 downto 0)
	);
end reg_file;
architecture reg_file of reg_file is
	signal reg0 : std_logic_vector(15 downto 0);
	signal reg1 : std_logic_vector(15 downto 0);
	signal reg2 : std_logic_vector(15 downto 0);
	signal reg3 : std_logic_vector(15 downto 0);
	signal reg4 : std_logic_vector(15 downto 0);
	signal reg5 : std_logic_vector(15 downto 0);
	signal reg6 : std_logic_vector(15 downto 0);
	signal reg7 : std_logic_vector(15 downto 0);
begin
	--read data1
	with addr1 select
		rdata1 <=
		reg0 when "000",
		reg1 when "001",
		reg2 when "010",
		reg3 when "011",
		reg4 when "100",
		reg5 when "101",
		reg6 when "110",
		reg7 when others;
	--read data2
	with addr2 select
		rdata2 <=
		reg0 when "000",
		reg1 when "001",
		reg2 when "010",
		reg3 when "011",
		reg4 when "100",
		reg5 when "101",
		reg6 when "110",
		reg7 when others;

	--write back
	process (clk)
	begin
		if rising_edge(clk) then
			--reset
			if rst = '1' then
				reg0 <= x"0000";
				reg1 <= x"0000";
				reg2 <= x"0000";
				reg3 <= x"0000";
				reg4 <= x"0000";
				reg5 <= x"0000";
				reg6 <= x"0000";
				reg7 <= x"0000";
			else
				if wren = '1' then
					if waddr = "000" then
						reg0 <= wdata;
					elsif waddr = "001" then
						reg1 <= wdata;
					elsif waddr = "010" then
						reg2 <= wdata;
					elsif waddr = "011" then
						reg3 <= wdata;
					elsif waddr = "100" then
						reg4 <= wdata;
					elsif waddr = "101" then
						reg5 <= wdata;
					elsif waddr = "110" then
						reg6 <= wdata;
					elsif waddr = "111" then
						reg7 <= wdata;
					end if;
				end if;
			end if;
		end if;
	end process;
end reg_file;