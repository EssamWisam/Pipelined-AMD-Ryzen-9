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
			case addr1 is
				when "000" =>
					rdata1 <= reg0;
				when "001" =>
					rdata1 <= reg1;
				when "010" =>
					rdata1 <= reg2;
				when "011" =>
					rdata1 <= reg3;
				when "100" =>
					rdata1 <= reg4;
				when "101" =>
					rdata1 <= reg5;
				when "110" =>
					rdata1 <= reg6;
				when others =>
					rdata1 <= reg7;
			end case;
		end if;
	end process;

	--data2
	process (clk)
	begin
		if rising_edge(clk) then
			case addr2 is
				when "000" =>
					rdata2 <= reg0;
				when "001" =>
					rdata2 <= reg1;
				when "010" =>
					rdata2 <= reg2;
				when "011" =>
					rdata2 <= reg3;
				when "100" =>
					rdata2 <= reg4;
				when "101" =>
					rdata2 <= reg5;
				when "110" =>
					rdata2 <= reg6;
				when others =>
					rdata2 <= reg7;
			end case;
		end if;
	end process;

	--write back
	process (not_clk)
	begin
		if rising_edge(not_clk) then
			if wren = '1' then
				case waddr is
					when "000" =>
						reg0 <= wdata;
					when "001" =>
						reg1 <= wdata;
					when "010" =>
						reg2 <= wdata;
					when "011" =>
						reg3 <= wdata;
					when "100" =>
						reg4 <= wdata;
					when "101" =>
						reg5 <= wdata;
					when "110" =>
						reg6 <= wdata;
					when others =>
						reg7 <= wdata;
				end case;
			end if;
		end if;
	end process;
end reg_file;