library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity cpu is
	port (
		clk : in std_logic := '0';
		reset : in std_logic;
		in_port : in std_logic_vector(15 downto 0);
		out_port : out std_logic_vector(15 downto 0)
	);
end cpu;
architecture cpu of cpu is
	signal inst_memo : std_logic_vector(31 downto 0);--inptut from instruction memory (temporary)
	signal stage1_reg : std_logic_vector(127 downto 0);--f/d
	signal stage2_reg : std_logic_vector(127 downto 0);--d/e
	signal stage3_reg : std_logic_vector(127 downto 0);--e/m
	signal stage4_reg : std_logic_vector(127 downto 0);--m/wb
	signal alu_operand1 : std_logic_vector(15 downto 0);--operand for alu
	signal alu_operand2 : std_logic_vector(15 downto 0);--operand for alu
	signal wb_data : std_logic_vector(15 downto 0);--data for write back
begin

	--?fetch logic
	--fetch-decode-buffer
	process (clk)
	begin
		if rising_edge(clk) then
			stage1_reg(31 downto 0) <= inst_memo(31 downto 0);
			--?pc to stage1_reg
		end if;
	end process;

	--decode logic
	reg_file : entity work.reg_file port map(clk, stage1_reg(12 downto 10), stage1_reg(15 downto 13), stage4_reg(39 downto 37), wb_data, stage4_reg(14), stage2_reg(55 downto 40), stage2_reg(71 downto 56));

	--decode-execute-buffer
	process (clk)
	begin
		if rising_edge(clk) then
			stage2_reg(39 downto 37) <= stage1_reg(9 downto 7);--&rdst(3)
			stage2_reg(87 downto 72) <= stage1_reg(31 downto 16);--imm(16)
			stage2_reg(89 downto 88) <= stage1_reg(8 downto 7);--ind(2)
			stage2_reg(92 downto 90) <= stage1_reg(12 downto 10);--&rsrc1(3)
			stage2_reg(95 downto 93) <= stage1_reg(15 downto 13);--&rsrc2(3)
			stage2_reg(127 downto 96) <= stage1_reg(63 downto 32);--pc(32)
			--cs logic
			if stage1_reg(4 downto 0) = "10000" then -- mov
				stage2_reg(27 downto 0) <= "0000000000000100000000000000";
			elsif stage1_reg(4 downto 0) = "10001" then -- add
				stage2_reg(27 downto 0) <= "0000000000000100000000001100";
			elsif stage1_reg(4 downto 0) = "10010" then -- sub
				stage2_reg(27 downto 0) <= "0000000000000100000000010000";
			elsif stage1_reg(4 downto 0) = "10011" then -- and
				stage2_reg(27 downto 0) <= "0000000000000100000000001000";
			elsif stage1_reg(4 downto 0) = "10100" then -- iadd
				stage2_reg(27 downto 0) <= "0000000000000100000000001101";
			end if;
		end if;
	end process;

	--execute-logic
	--mux1(operand1)
	with stage2_reg(0) select
	alu_operand1 <=
		stage2_reg(55 downto 40) when '0', --rsrc1(16)
		stage2_reg(87 downto 72) when others;--imm(16)
	--mux2(operand1)
	alu_operand2 <= stage2_reg(71 downto 56);--rsrc2(16)

	alu : entity work.alu port map(clk, alu_operand1, alu_operand2, stage2_reg(4 downto 2), stage3_reg(87 downto 72));

	--execute-memory-buffer
	process (clk)
	begin
		if rising_edge(clk) then
			stage3_reg(36 downto 0) <= stage2_reg(36 downto 0);--cs(28)&g(9)
			stage3_reg(39 downto 37) <= stage2_reg(39 downto 37);--&rdst(3)
			stage3_reg(55 downto 40) <= stage2_reg(55 downto 40); --rsrc1(16)
			stage3_reg(89 downto 88) <= stage2_reg(89 downto 88); --ind(2)
			stage3_reg(92 downto 90) <= stage2_reg(92 downto 90);--&rsrc1(3)
			stage3_reg(95 downto 93) <= stage2_reg(95 downto 93);--&rsrc2(3)
			stage3_reg(127 downto 96) <= stage2_reg(127 downto 96);--pc(32)
		end if;
	end process;

	--?memory logic

	--memory-writeback-buffer
	process (clk)
	begin
		if rising_edge(clk) then
			stage4_reg(36 downto 0) <= stage3_reg(36 downto 0);--cs(28)&g(9)
			stage4_reg(39 downto 37) <= stage3_reg(39 downto 37);--&rdst(3)
			stage4_reg(55 downto 40) <= stage3_reg(55 downto 40);--rsrc1(16)
			stage4_reg(87 downto 72) <= stage3_reg(87 downto 72);--result(16)
		end if;
	end process;

	--writeback logic
	--mux7 (wf)
	with stage4_reg(11) select
	wb_data <=
		stage4_reg(87 downto 72) when '0', --result of the alu(16)
		stage4_reg(71 downto 56) when others;--memo data(16)

end cpu;