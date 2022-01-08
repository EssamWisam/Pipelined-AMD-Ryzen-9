vsim work.cpu
add wave -position end  sim:/cpu/clk
add wave -position end  sim:/cpu/inst_memo
add wave -position end  sim:/cpu/pc_addr
add wave -position end  sim:/cpu/reg_file/reg0
add wave -position end  sim:/cpu/reg_file/reg1
add wave -position end  sim:/cpu/reg_file/reg2
add wave -position end  sim:/cpu/reg_file/reg3
add wave -position end  sim:/cpu/reg_file/reg4
add wave -position end  sim:/cpu/reg_file/reg5
add wave -position end  sim:/cpu/reg_file/reg6
add wave -position end  sim:/cpu/reg_file/reg7
add wave -position end  sim:/cpu/flag_out
add wave -position end  sim:/cpu/flag_en


force -freeze sim:/cpu/clk 0 0, 1 {50 ps} -r 100
force -freeze sim:/cpu/reg_file/rst 1 0
run
force -freeze sim:/cpu/reg_file/rst 0 0
force -freeze sim:/cpu/flag_en 1 0


force -freeze sim:/cpu/reg_file/reg1 X\"FFFF\" 0
force -freeze sim:/cpu/reg_file/reg2 X\"FFFF\" 0
force -freeze sim:/cpu/inst_memo X\"00000590\" 0
run
force -freeze sim:/cpu/inst_memo X\"00004611\" 0
run
force -freeze sim:/cpu/inst_memo X\"00004693\" 0
run
force -freeze sim:/cpu/inst_memo X\"000f2354\" 0
run
force -freeze sim:/cpu/inst_memo X\"00002b92\" 0
run
force -freeze sim:/cpu/inst_memo X\"00000d8c\" 0
run
force -freeze sim:/cpu/inst_memo X\"0000000a\" 0
run
run
run
run
run
#Test 1:
#intially
#R1 = 1
#R2 = 2
#MOV R3, R1
#ADD R4, R1, R2
#AND R5, R1, R2
#ADDI R6, R1, 15
#SUB R7, R2, R1
#INC R3