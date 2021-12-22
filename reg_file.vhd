library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity reg_file is
	port (
		clk : in std_logic;
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
	signal not_clk : std_logic;
	signal reg0 : std_logic_vector(15 downto 0);
	signal reg1 : std_logic_vector(15 downto 0);
	signal reg2 : std_logic_vector(15 downto 0);
	signal reg3 : std_logic_vector(15 downto 0);
	signal reg4 : std_logic_vector(15 downto 0);
	signal reg5 : std_logic_vector(15 downto 0);
	signal reg6 : std_logic_vector(15 downto 0);
	signal reg7 : std_logic_vector(15 downto 0);
begin
	not_clk <= not clk;
	--data1
	process (clk)
	begin
		if rising_edge(clk) then
			if addr1 = "000" then
				rdata1 <= reg0;
			elsif addr1 = "001" then
				rdata1 <= reg1;
			elsif addr1 = "010" then
				rdata1 <= reg2;
			elsif addr1 = "011" then
				rdata1 <= reg3;
			elsif addr1 = "100" then
				rdata1 <= reg4;
			elsif addr1 = "101" then
				rdata1 <= reg5;
			elsif addr1 = "110" then
				rdata1 <= reg6;
			elsif addr1 = "111" then
				rdata1 <= reg7;
			end if;
		end if;
	end process;

	--data2
	process (clk)
	begin
		if rising_edge(clk) then
			if addr2 = "000" then
				rdata2 <= reg0;
			elsif addr2 = "001" then
				rdata2 <= reg1;
			elsif addr2 = "010" then
				rdata2 <= reg2;
			elsif addr2 = "011" then
				rdata2 <= reg3;
			elsif addr2 = "100" then
				rdata2 <= reg4;
			elsif addr2 = "101" then
				rdata2 <= reg5;
			elsif addr2 = "110" then
				rdata2 <= reg6;
			elsif addr2 = "111" then
				rdata2 <= reg7;
			end if;
		end if;
	end process;

	--write back
	process (not_clk)
	begin
		if rising_edge(not_clk) then
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
	end process;
end reg_file;