LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY cpu IS
	PORT (
		clk : IN STD_LOGIC := '0';
		rst : IN STD_LOGIC;
		in_port : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		out_port : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END cpu;
ARCHITECTURE cpu OF cpu IS
	SIGNAL not_clk : STD_LOGIC;
	SIGNAL inst_memo : STD_LOGIC_VECTOR(31 DOWNTO 0);--inptut from instruction memory (temporary)
	SIGNAL stage1_reg : STD_LOGIC_VECTOR(127 DOWNTO 0);--f/d
	SIGNAL stage2_reg : STD_LOGIC_VECTOR(127 DOWNTO 0);--d/e
	SIGNAL stage3_reg : STD_LOGIC_VECTOR(127 DOWNTO 0);--e/m
	SIGNAL stage4_reg : STD_LOGIC_VECTOR(127 DOWNTO 0);--m/wb
	SIGNAL alu_operand1 : STD_LOGIC_VECTOR(15 DOWNTO 0);--operand for alu
	SIGNAL alu_operand2 : STD_LOGIC_VECTOR(15 DOWNTO 0);--operand for alu
	SIGNAL wb_data : STD_LOGIC_VECTOR(15 DOWNTO 0);--data for write back
	SIGNAL memo_addr : STD_LOGIC_VECTOR(31 DOWNTO 0);--address for data memory
	SIGNAL stack_addr : STD_LOGIC_VECTOR(31 DOWNTO 0);--address for stack
	SIGNAL CS : STD_LOGIC_VECTOR(27 DOWNTO 0);--control signals
	SIGNAL read_data1 : STD_LOGIC_VECTOR(15 DOWNTO 0);--data for rsrc1
	SIGNAL read_data2 : STD_LOGIC_VECTOR(15 DOWNTO 0);--data for rsrc2
	SIGNAL alu_result : STD_LOGIC_VECTOR(15 DOWNTO 0);--result of alu
	SIGNAL memo_data16 : STD_LOGIC_VECTOR(15 DOWNTO 0);--data 16 form data memory
	SIGNAL memo_data32 : STD_LOGIC_VECTOR(31 DOWNTO 0);--data 32 form data memory
	SIGNAL index : STD_LOGIC_VECTOR(1 DOWNTO 0);--index

BEGIN
	not_clk <= NOT clk;
	--TODO:add fetch logic

	--fetch-decode-buffer
	IF_ID_buffer : ENTITY work.IF_ID_buffer PORT MAP (
		clk,
		inst_memo(15 DOWNTO 0), --inInstruction
		inst_memo(31 DOWNTO 16), --inImm
		x"00000000", --TODO:to be changed to pc
		x"0000000000000000", --inG
		stage1_reg(6 DOWNTO 0), --outOpCode
		stage1_reg(31 DOWNTO 16), --outImm
		stage1_reg(9 DOWNTO 7), --outRdst_index
		stage1_reg(12 DOWNTO 10), --outRsrc1_index
		stage1_reg(15 DOWNTO 13), --outRsrc2_index
		index, --outInt_index
		stage1_reg(63 DOWNTO 32)--outPC
		);

	--decode logic
	--regester file module
	reg_file : ENTITY work.reg_file PORT MAP(not_clk, rst, stage1_reg(12 DOWNTO 10), stage1_reg(15 DOWNTO 13), stage4_reg(39 DOWNTO 37), wb_data, stage4_reg(14), read_data1, read_data2);
	--CU logic
	PROCESS (not_clk)
	BEGIN
		IF rising_edge(not_clk) THEN
			IF stage1_reg(4 DOWNTO 0) = "10000" THEN -- mov
				CS <= "0000000000000100000000000000";
			ELSIF stage1_reg(4 DOWNTO 0) = "01100" THEN -- inc
				CS <= "0000000000000100000000010100";
			ELSIF stage1_reg(4 DOWNTO 0) = "10001" THEN -- add
				CS <= "0000000000000100000000001100";
			ELSIF stage1_reg(4 DOWNTO 0) = "10010" THEN -- sub
				CS <= "0000000000000100000000010000";
			ELSIF stage1_reg(4 DOWNTO 0) = "10011" THEN -- and
				CS <= "0000000000000100000000001000";
			ELSIF stage1_reg(4 DOWNTO 0) = "10100" THEN -- iadd
				CS <= "0000000000000100000000001101";
			ELSIF stage1_reg(4 DOWNTO 0) = "00001" THEN -- PUSH
				CS <= "0000000000000000001010100000";
			ELSIF stage1_reg(4 DOWNTO 0) = "00010" THEN -- POP
				CS <= "0000000000000100100100100000";
			ELSIF stage1_reg(4 DOWNTO 0) = "00011" THEN -- LDM
				CS <= "0000000000000100000000000001";
			ELSIF stage1_reg(4 DOWNTO 0) = "00100" THEN -- LDD
				CS <= "0000000000000100100000001101";
			ELSIF stage1_reg(4 DOWNTO 0) = "00101" THEN -- STD
				CS <= "0000000000000000000010001101";
				--TODO:complete the CU logic
			END IF;
		END IF;
	END PROCESS;

	--decode-execute-buffer
	ID_EX_buffer : ENTITY work.ID_EX_buffer PORT MAP (
		clk,
		CS,
		"000000000", --inG
		stage1_reg(9 DOWNTO 7), --inRdst_index
		read_data1, --inRsrc_data1
		read_data2, --inRsrc_data2
		stage1_reg(31 DOWNTO 16), --inImm
		index, --inInt_index
		stage1_reg(12 DOWNTO 10), --inRsrc1_index
		stage1_reg(15 DOWNTO 13), --inRsrc2_index
		stage1_reg(63 DOWNTO 32), --inPC
		stage2_reg(27 DOWNTO 0), --outCS
		OPEN, --outG
		stage2_reg(39 DOWNTO 37), --outRdst_index
		stage2_reg(55 DOWNTO 40), --outRsrc_data1
		stage2_reg(71 DOWNTO 56), --outRsrc_data2
		stage2_reg(87 DOWNTO 72), --outImm
		stage2_reg(89 DOWNTO 88), --outInt_index
		stage2_reg(92 DOWNTO 90), --outRsrc1_index
		stage2_reg(95 DOWNTO 93), --outRsrc2_index
		stage2_reg(127 DOWNTO 96)--outPC
		);

	--execute-logic
	--mux1(operand1)
	WITH stage2_reg(0) SELECT
	alu_operand1 <=
		stage2_reg(55 DOWNTO 40) WHEN '0', --rsrc1(16)
		stage2_reg(87 DOWNTO 72) WHEN OTHERS;--imm(16)
	--mux2(operand1)
	alu_operand2 <= stage2_reg(71 DOWNTO 56);--rsrc2(16)
	--alu module
	alu : ENTITY work.alu PORT MAP(not_clk, alu_operand1, alu_operand2, stage2_reg(4 DOWNTO 2), alu_result);

	--execute-memory-buffer
	EX_MEM_buffer : ENTITY work.EX_MEM_buffer PORT MAP (
		clk,
		stage2_reg(27 DOWNTO 0), --inCS
		stage2_reg(36 DOWNTO 28), --inG1
		stage2_reg(39 DOWNTO 37), --inRdst_index
		stage2_reg(55 DOWNTO 40), --inRsrc_data1
		x"0000", --inG2
		alu_result, --inResult
		stage2_reg(89 DOWNTO 88), --inInt_index
		stage2_reg(92 DOWNTO 90), --inRsrc1_index
		stage2_reg(95 DOWNTO 93), --inRsrc2_index
		stage2_reg(127 DOWNTO 96), --inPC
		stage3_reg(27 DOWNTO 0), --outCS
		stage3_reg(55 DOWNTO 40), --outRsrc_data1
		stage3_reg(87 DOWNTO 72), --outResult
		stage3_reg(39 DOWNTO 37), --outRdst_index
		stage3_reg(89 DOWNTO 88), --outInt_index
		stage3_reg(127 DOWNTO 96)--outPC
		);

	--memory logic
	--Stack pointer
	stack_module : ENTITY work.stack_module PORT MAP(clk, rst, stage3_reg(10 DOWNTO 8), stack_addr);
	--mux5(memo_addr)
	WITH stage3_reg(6 DOWNTO 5) SELECT
	memo_addr <=
		(x"0000") & stage3_reg(87 DOWNTO 72) WHEN "00", --result of alu
		stack_addr WHEN "01", --stack_addr
		(OTHERS => '0') WHEN OTHERS;--temp
	--memory module
	data_memory : ENTITY work.data_memory PORT MAP(not_clk, stage3_reg(7), memo_addr, '0', stage3_reg(55 DOWNTO 40), stage3_reg(127 DOWNTO 96), memo_data16, memo_data32);

	--memory-writeback-buffer
	MEM_WB_buffer : ENTITY work.MEM_WB_buffer PORT MAP (
		clk,
		stage3_reg(27 DOWNTO 0), --inCS
		stage3_reg(36 DOWNTO 28), --inG
		stage3_reg(39 DOWNTO 37), --inRdst_index
		stage3_reg(55 DOWNTO 40), --inRsrc_data1
		memo_data16, --inData16
		stage3_reg(87 DOWNTO 72), --inResult
		memo_data32, --inData32
		"00", --inG2
		"000", --inG3
		"000", --inG4
		stage4_reg(27 DOWNTO 0), --outCS
		stage4_reg(39 DOWNTO 37), --outRdst_index
		stage4_reg(87 DOWNTO 72), --outResult
		stage4_reg(127 DOWNTO 96), --outData32
		stage4_reg(71 DOWNTO 56)--outData16
		);

	--writeback logic
	--mux7 (select writeback value)
	WITH stage4_reg(11) SELECT
	wb_data <=
		stage4_reg(87 DOWNTO 72) WHEN '0', --result of the alu(16)
		stage4_reg(71 DOWNTO 56) WHEN OTHERS;--memo data(16)

END cpu;