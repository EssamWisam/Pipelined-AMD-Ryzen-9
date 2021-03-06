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
	--pretty much all the signals we'll need in the processor
	SIGNAL not_clk : STD_LOGIC;
	SIGNAL inst_memo : STD_LOGIC_VECTOR(31 DOWNTO 0);       --input from instruction memory (temporary)
	SIGNAL stage1_reg : STD_LOGIC_VECTOR(127 DOWNTO 0);	  --f/d
	SIGNAL stage2_reg : STD_LOGIC_VECTOR(127 DOWNTO 0);	  --d/e
	SIGNAL stage3_reg : STD_LOGIC_VECTOR(127 DOWNTO 0);	  --e/m
	SIGNAL stage4_reg : STD_LOGIC_VECTOR(127 DOWNTO 0);	  --m/wb
	SIGNAL alu_operand1 : STD_LOGIC_VECTOR(15 DOWNTO 0);	  --operand for alu
	SIGNAL alu_operand2 : STD_LOGIC_VECTOR(15 DOWNTO 0);	  --operand for alu
	SIGNAL wb_data : STD_LOGIC_VECTOR(15 DOWNTO 0);			  --data for write back
	SIGNAL memo_addr : STD_LOGIC_VECTOR(31 DOWNTO 0);		  --address for data memory
	SIGNAL stack_addr : STD_LOGIC_VECTOR(31 DOWNTO 0);		  --address for stack
	SIGNAL CS : STD_LOGIC_VECTOR(27 DOWNTO 0);				  --control signals
	SIGNAL read_data1 : STD_LOGIC_VECTOR(15 DOWNTO 0);		  --data for rsrc1
	SIGNAL read_data2 : STD_LOGIC_VECTOR(15 DOWNTO 0);		  --data for rsrc2
	SIGNAL alu_result : STD_LOGIC_VECTOR(15 DOWNTO 0);		  --result of alu
	SIGNAL memo_data16 : STD_LOGIC_VECTOR(15 DOWNTO 0);	  --data 16 form data memory
	SIGNAL memo_data32 : STD_LOGIC_VECTOR(31 DOWNTO 0);	  --data 32 form data memory
	SIGNAL index : STD_LOGIC_VECTOR(1 DOWNTO 0);				  --index
    SIGNAL exec_result:  std_logic_vector(15 DOWNTO 0); -- the output of the final mux in the execution stage
	SIGNAL MUX2_SEL      :   std_logic_vector(1 downto 0);
	SIGNAL MUX3_SEL      :   std_logic_vector(1 downto 0);
	SIGNAL MUX1_RESULT   :    std_logic_vector(15 DOWNTO 0);
	SIGNAL ID_EX_FLUSH   :  STD_LOGIC;
	SIGNAL IF_ID_enable  :  STD_LOGIC;
	SIGNAL hazard_freeze :  STD_LOGIC;
	SIGNAL WHO_FRREZED   :  STD_LOGIC;

	-- flag register signals:
	signal flag_in : std_logic_vector(3 downto 0);
	signal flag_in_alu : std_logic_vector(3 downto 0);
	signal flag_in_jlu : std_logic_vector(3 downto 0);
	signal flag_out : std_logic_vector(3 downto 0);
	signal flag_en: std_logic;	
	signal pc_addr : std_logic_vector(31 downto 0);
	signal extended_Rsrc : std_logic_vector(31 downto 0);
	signal cs_2_3 : std_logic_vector(27 downto 0);
	signal cond: std_logic;
	signal freeze: std_logic;
	signal flush_jmp: std_logic;
	signal flush_call: std_logic;
	signal exp1: std_logic;
	signal exp2: std_logic;
	signal cs_3_4 : std_logic_vector(27 downto 0);
	signal exp_fetch_bool: std_logic;

	-- RET, RTI  Singnals:
	signal is_RET_RTI_INT_CALL  : std_logic;
	
BEGIN
	not_clk <= NOT clk;

	process(not_clk)
	begin
		if rising_edge(not_clk) then
			if rst = '1' then
				exp_fetch_bool <='0';
			elsif exp_fetch_bool ='1' then
				exp_fetch_bool <='0';
			elsif exp1 = '1' or exp2 = '1' then
				exp_fetch_bool <='1';
			end if;
		end if;
	end process;

	--PC module
	extended_Rsrc<= x"0000" & stage3_reg(55 downto 40);
	pc_reg:ENTITY work.pc port map (
		clk,
		rst,
		exp1,--ex1
		exp2,--ex2
		freeze,--freeze
		stage3_reg(25),--Cond
		inst_memo(6),--isLongInst
		stage3_reg(13 downto 12),--pc_src
		X"00000002",--ex1_addr
		X"00000004",--ex2_addr
		stage4_reg(127 downto 96),--data_32
		extended_Rsrc,--extended_Rsrc
		pc_addr,--next_addr
		stage3_reg(127 DOWNTO 96), --pc for exp
		inst_memo(31 downto 0) --pc for exp
	);
	--instruction memory module
	instruction_memory: ENTITY work.inst_memory port map (
		not_clk,
		pc_addr, --pc
		inst_memo(15 DOWNTO 0), --instruction
		inst_memo(31 DOWNTO 16) --immediate
		);
	--fetch-decode-buffer
	IF_ID_buffer : ENTITY work.IF_ID_buffer PORT MAP (
		clk,
		rst or flush_jmp or exp1 or exp2 or exp_fetch_bool or cond,
		IF_ID_enable,
		inst_memo(15 DOWNTO 0), 										--inInstruction
		inst_memo(31 DOWNTO 16), 										--inImm
		pc_addr, 														--pc
		x"0000000000000000", 											--inG
		stage1_reg(6 DOWNTO 0), 										--outOpCode
		stage1_reg(31 DOWNTO 16), 										--outImm
		stage1_reg(9 DOWNTO 7), 										--outRdst_index
		stage1_reg(12 DOWNTO 10), 										--outRsrc1_index
		stage1_reg(15 DOWNTO 13), 										--outRsrc2_index
		index, 															--outInt_index
		stage1_reg(63 DOWNTO 32)										--outPC
		);

	--decode logic
	--regester file module
	reg_file : ENTITY work.reg_file PORT MAP(not_clk, rst, stage1_reg(12 DOWNTO 10), stage1_reg(15 DOWNTO 13), stage4_reg(39 DOWNTO 37), wb_data, stage4_reg(14), read_data1, read_data2);
	--CU logic
	PROCESS (not_clk)
	BEGIN
		IF rising_edge(not_clk) THEN
			IF stage1_reg(4 DOWNTO 0) = "10000" THEN    			-- mov
				CS <= "0000000000000100000000000000";
			ELSIF stage1_reg(4 DOWNTO 0) = "01100" THEN 			-- inc
				CS <= "0000000000000100000000010100";
			ELSIF stage1_reg(4 DOWNTO 0) = "01010" THEN 			-- setc
				CS <= "0000000000000000000000011000";	
			ELSIF stage1_reg(4 DOWNTO 0) = "10001" THEN 			-- add
				CS <= "0000000000000100000000001100";
			ELSIF stage1_reg(4 DOWNTO 0) = "10010" THEN 			-- sub
				CS <= "0000000000000100000000010000";
			ELSIF stage1_reg(4 DOWNTO 0) = "10011" THEN 			-- and
				CS <= "0000000000000100000000001000";
			ELSIF stage1_reg(4 DOWNTO 0) = "10100" THEN 			-- iadd
				CS <= "0000000000000100000000001101";
			ELSIF stage1_reg(4 DOWNTO 0) = "00001" THEN 			-- PUSH
				CS <= "0000000000000000001011000000";
			ELSIF stage1_reg(4 DOWNTO 0) = "00010" THEN 			-- POP
				CS <= "0000000000000100100101000000";
			ELSIF stage1_reg(4 DOWNTO 0) = "00011" THEN 			-- LDM
				CS <= "0000000000000100000000000001";
			ELSIF stage1_reg(4 DOWNTO 0) = "00100" THEN 			-- LDD
				CS <= "0000000000000100100000101101";
			ELSIF stage1_reg(4 DOWNTO 0) = "00101" THEN 			-- STD
				CS <= "0000000000000000000010101101";
			ELSIF stage1_reg(4 DOWNTO 0) = "01101" THEN             -- OUT
				CS <= "0000010000000000000000000000";
			ELSIF stage1_reg(4 DOWNTO 0) = "01110" THEN             -- IN
				CS <= "0000000000000100000000000010";	
			ELSIF stage1_reg(4 DOWNTO 0) = "11000" THEN 			-- JMP
				CS <= "0000000000100010000000000000";
			ELSIF stage1_reg(4 DOWNTO 0) = "11001" THEN 			-- JEQ
				CS <= "0000000010100010000000000000";
			ELSIF stage1_reg(4 DOWNTO 0) = "11010" THEN 			-- JNE
				CS <= "0000000100100010000000000000";
			ELSIF stage1_reg(4 DOWNTO 0) = "11011" THEN 			-- JLT
				CS <= "0010000110100010000000000000";
			ELSIF stage1_reg(4 DOWNTO 0) = "11110" THEN				-- INT
				CS <= "0000001100101000000001000000";
			ELSIF stage1_reg(4 DOWNTO 0) = "11100" THEN				-- CALL
				CS <= "0000001000100010010011000000";
			ELSIF stage1_reg(4 DOWNTO 0) = "01000" THEN				-- NOP
				CS <= "0000000000000000000000000000";
			ELSIF stage1_reg(4 DOWNTO 0) = "01001" THEN				-- HLT
				CS <= "0001000000000000000000000000";
			ELSIF stage1_reg(4 DOWNTO 0) = "11101" THEN				-- RET
				CS <= "0000001010100001000001000000";
			ELSIF stage1_reg(4 DOWNTO 0) = "11111" THEN				-- RTI
				CS <= "0000001110110001000001000000";
			ELSIF stage1_reg(4 DOWNTO 0) = "01011" THEN				-- NOT
				CS <= "0000000000000100000000011100";

			ELSE
				CS <= "0000000000000000000000000000";
			END IF;
		END IF;
	END PROCESS;
	--frz module
	frz_module: ENTITY work.frz port map (
		not_clk,
		rst,
		stage1_reg(4 DOWNTO 0), --opcode
		freeze ,  --freeze
		hazard_freeze,
		WHO_FRREZED,
		WHO_FRREZED
		);
 
	HAZARD_DETECTION_UNIT: ENTITY WORK.HDU PORT MAP (
		stage2_reg(27 DOWNTO 0),
		stage3_reg(27 DOWNTO 0), 
		stage4_reg(27 DOWNTO 0),
		stage1_reg(12 DOWNTO 10), 										--outRsrc1_index IF/ID
		stage1_reg(15 DOWNTO 13), 										--outRsrc2_index IF/ID
		stage2_reg(39 DOWNTO 37), 	                                    --outRdst_index  ID/EX
		stage3_reg(39 DOWNTO 37), 	                                    --outRdst_index  EX/MEM
		stage4_reg(39 DOWNTO 37), 	                                    --outRdst_index  MEM/WB
		IF_ID_enable,
		hazard_freeze,
		ID_EX_FLUSH
	    );	

	--decode-execute-buffer
	ID_EX_buffer : ENTITY work.ID_EX_buffer PORT MAP (
		clk,
		rst or flush_jmp or exp1 or exp2 OR ID_EX_FLUSH or cond,
		'1',
		CS,
		"000000000", 					--inG
		stage1_reg(9 DOWNTO 7), 		--inRdst_index
		read_data1,						--inRsrc_data1
		read_data2, 					--inRsrc_data2
		stage1_reg(31 DOWNTO 16), 		--inImm
		index, 							--inInt_index
		stage1_reg(12 DOWNTO 10), 		--inRsrc1_index
		stage1_reg(15 DOWNTO 13), 		--inRsrc2_index
		stage1_reg(63 DOWNTO 32), 		--inPC
		stage2_reg(27 DOWNTO 0), 		--outCS
		OPEN, 							--outG
		stage2_reg(39 DOWNTO 37), 		--outRdst_index
		stage2_reg(55 DOWNTO 40), 		--outRsrc_data1
		stage2_reg(71 DOWNTO 56), 		--outRsrc_data2
		stage2_reg(87 DOWNTO 72), 		--outImm
		stage2_reg(89 DOWNTO 88), 		--outInt_index
		stage2_reg(92 DOWNTO 90), 		--outRsrc1_index
		stage2_reg(95 DOWNTO 93), 		--outRsrc2_index
		stage2_reg(127 DOWNTO 96)		--outPC
		);

	--execute-logic
	--mux1
	WITH stage2_reg(0) SELECT
	MUX1_RESULT <=
		stage2_reg(55 DOWNTO 40) WHEN '0', --rsrc1(16)
		stage2_reg(87 DOWNTO 72) WHEN OTHERS;--imm(16)
    
	--Forwarding Unit              ----Rsrc1_index           ----Rsrc2_index           ---Rdst_index
	FU : entity work.FU PORT MAP (
		stage2_reg(92 DOWNTO 90), 
		stage2_reg(95 DOWNTO 93),
		stage3_reg(39 DOWNTO 37), 
		stage4_reg(39 DOWNTO 37),
		MUX3_SEL,
		MUX2_SEL,
		stage3_reg(14),
		stage4_reg(14)
		);	

	--MUX3(OPERAND 1)
	WITH MUX3_SEL SELECT
	alu_operand1 <= 
		stage3_reg(87 DOWNTO 72) WHEN "10",
		wb_data WHEN "01",
		MUX1_RESULT WHEN OTHERS;

	--mux2(operand2)
	WITH MUX2_SEL SELECT
	alu_operand2 <= 
	     stage3_reg(87 DOWNTO 72) WHEN "10",
	     wb_data WHEN "01",
	     stage2_reg(71 DOWNTO 56) WHEN OTHERS;--rsrc2(16)
	--alu module
	alu : ENTITY work.alu PORT MAP(not_clk, alu_operand1, alu_operand2, stage2_reg(4 DOWNTO 2), alu_result, flag_in_alu);
	-- stage2_reg(15) is SaveF, stage2_reg(16) is ResF, this should solve the flag register saving/restoring problem 
	-- depending only on the respective signals.
	flag: entity work.flag_reg port map (clk, rst, stage2_reg(15),stage2_reg(16), flag_in, flag_out);
	jlu: entity work.jlu port map (
		not_clk,
		stage2_reg(17),--pcc
		flag_out,--flag_out
		stage2_reg(21 DOWNTO 19),--jm
		cond,--Cond
		flag_in_jlu--flag_in
	);
	with stage2_reg(17) select
		flag_in	<= 	flag_in_jlu WHEN '1',
				  	flag_in_alu WHEN OTHERS;
	cs_2_3 <= stage2_reg(27 DOWNTO 26) & cond & stage2_reg(24 DOWNTO 0);
	flush_module: ENTITY work.flush PORT MAP(
		not_clk,
		stage2_reg(17),
		stage2_reg(21 DOWNTO 19),
		cond,
		flush_jmp,
		flush_call
		);
    --output 
	process (clk)
	begin
		if rising_edge(clk) then
			if stage2_reg(22) = '1' then 
				out_port <=  alu_result;
			end if;	 
		end if;
	end process;
    
    --input 
	with stage2_reg(1) select
	exec_result <=
		in_port when '1', 
		alu_result when others;

	--execute-memory-buffer
	EX_MEM_buffer : ENTITY work.EX_MEM_buffer PORT MAP (
		clk,
		rst or flush_jmp or exp1 or exp2,
		'1',
		cs_2_3, 						--inCS
		stage2_reg(36 DOWNTO 28), 		--inG1
		stage2_reg(39 DOWNTO 37), 		--inRdst_index
		stage2_reg(55 DOWNTO 40), 		--inRsrc_data1
		x"0000", 						--inG2
		exec_result, 					--inResult
		stage2_reg(89 DOWNTO 88), 		--inInt_index
		stage2_reg(92 DOWNTO 90), 		--inRsrc1_index
		stage2_reg(95 DOWNTO 93), 		--inRsrc2_index
		stage2_reg(127 DOWNTO 96),		--inPC
		stage3_reg(27 DOWNTO 0), 		--outCS
		stage3_reg(55 DOWNTO 40), 		--outRsrc_data1
		stage3_reg(87 DOWNTO 72), 		--outResult
		stage3_reg(39 DOWNTO 37), 		--outRdst_index
		stage3_reg(89 DOWNTO 88), 		--outInt_index
		stage3_reg(127 DOWNTO 96)		--outPC
		);

	--memory logic
	--Stack pointer
	stack_module : ENTITY work.stack_module PORT MAP(clk, rst, stage3_reg(10 DOWNTO 8), stack_addr);	-- stage3_reg(10 downto 8): SPA
	--mux5(memo_addr)
	WITH stage3_reg(6 DOWNTO 5) SELECT	-- stage3_reg(6 downto 5): AddSrc 
	memo_addr <=
		(x"0000") & stage3_reg(87 DOWNTO 72) WHEN "01", --result of alu
		stack_addr WHEN "10", --stack_addr
		(OTHERS => '0') WHEN OTHERS;--temp
	-- ____________________________________________________________________________________
	-- RET, RTI, INT, CALL
	 is_RET_RTI_INT_CALL <= '1' when (stage3_reg(6 downto 5)&stage3_reg(18 downto 17)="1001") else '0';	-- AddSrc=10, PCC=01 ===> RET|RTI|INT|CALL
	-- ____________________________________________________________________________________

	 --memory module
	data_memory : ENTITY work.data_memory PORT MAP(
		not_clk, 
		stage3_reg(7), -- MEMW
		memo_addr,
		is_RET_RTI_INT_CALL,	-- is_32_bit ? --
		stage3_reg(55 DOWNTO 40),  --inRsrc_data1 
		stage3_reg(127 DOWNTO 96), -- PC
		memo_data16, 
		memo_data32,
		exp2,
		exp1,
		stage3_reg(6 DOWNTO 5)
		);
	cs_3_4 <= stage3_reg(27 DOWNTO 15)&(stage3_reg(14) and (not exp1) and (not exp2))&stage3_reg(13 downto 0);
	--memory-writeback-buffer
	MEM_WB_buffer : ENTITY work.MEM_WB_buffer PORT MAP (
		clk,
		rst,
		'1',
		cs_3_4, 	--inCS
		stage3_reg(36 DOWNTO 28), 	--inG
		stage3_reg(39 DOWNTO 37), 	--inRdst_index
		stage3_reg(55 DOWNTO 40), 	--inRsrc_data1
		memo_data16, 					--inData16
		stage3_reg(87 DOWNTO 72), 		--inResult
		memo_data32, 					--inData32
		"00", 							--inG2
		"000", 							--inG3
		"000", 							--inG4
		stage4_reg(27 DOWNTO 0), 		--outCS
		stage4_reg(39 DOWNTO 37), 		--outRdst_index
		stage4_reg(87 DOWNTO 72), 		--outResult
		stage4_reg(127 DOWNTO 96), 		--outData32
		stage4_reg(71 DOWNTO 56)		--outData16
		);

	--writeback logic
	--mux7 (select writeback value)
	WITH stage4_reg(11) SELECT
	wb_data <=
		stage4_reg(87 DOWNTO 72) WHEN '0', 		--result of the alu(16)
		stage4_reg(71 DOWNTO 56) WHEN OTHERS;	--memo data(16)

END cpu;