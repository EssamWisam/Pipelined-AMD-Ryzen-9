LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY reg_file IS
	PORT (
		clk : IN STD_LOGIC;--falling edge
		rst : IN STD_LOGIC;
		addr1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		addr2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		waddr : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		wdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		wren : IN STD_LOGIC;
		rdata1 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		rdata2 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END reg_file;
ARCHITECTURE reg_file OF reg_file IS
	SIGNAL reg0 : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL reg1 : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL reg2 : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL reg3 : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL reg4 : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL reg5 : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL reg6 : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL reg7 : STD_LOGIC_VECTOR(15 DOWNTO 0);
BEGIN
	--read data1
	WITH addr1 SELECT
		rdata1 <=
		reg0 WHEN "000",
		reg1 WHEN "001",
		reg2 WHEN "010",
		reg3 WHEN "011",
		reg4 WHEN "100",
		reg5 WHEN "101",
		reg6 WHEN "110",
		reg7 WHEN others;
	--read data2
	WITH addr2 SELECT
		rdata2 <=
		reg0 WHEN "000",
		reg1 WHEN "001",
		reg2 WHEN "010",
		reg3 WHEN "011",
		reg4 WHEN "100",
		reg5 WHEN "101",
		reg6 WHEN "110",
		reg7 WHEN others;

	--write back
	PROCESS (clk)
	BEGIN
		IF rising_edge(clk) THEN
			--reset
			IF rst = '1' THEN
				reg0 <= x"0000";
				reg1 <= x"0000";
				reg2 <= x"0000";
				reg3 <= x"0000";
				reg4 <= x"0000";
				reg5 <= x"0000";
				reg6 <= x"0000";
				reg7 <= x"0000";
			ELSE
				IF wren = '1' THEN
					IF waddr = "000" THEN
						reg0 <= wdata;
					ELSIF waddr = "001" THEN
						reg1 <= wdata;
					ELSIF waddr = "010" THEN
						reg2 <= wdata;
					ELSIF waddr = "011" THEN
						reg3 <= wdata;
					ELSIF waddr = "100" THEN
						reg4 <= wdata;
					ELSIF waddr = "101" THEN
						reg5 <= wdata;
					ELSIF waddr = "110" THEN
						reg6 <= wdata;
					ELSIF waddr = "111" THEN
						reg7 <= wdata;
					END IF;
				END IF;
			END IF;
		END IF;
	END PROCESS;
END reg_file;