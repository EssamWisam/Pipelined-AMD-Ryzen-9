vsim work.cpu
add wave -position end  sim:/cpu/clk
add wave -position end  sim:/cpu/rst
add wave -position end  sim:/cpu/in_port
add wave -position end  sim:/cpu/out_port
add wave -position end  sim:/cpu/pc_addr
add wave -position end  sim:/cpu/pc_reg/epc
add wave -position end  sim:/cpu/stack_addr
add wave -position end  sim:/cpu/flag_out
add wave -position end  sim:/cpu/reg_file/reg0
add wave -position end  sim:/cpu/reg_file/reg1
add wave -position end  sim:/cpu/reg_file/reg2
add wave -position end  sim:/cpu/reg_file/reg3
add wave -position end  sim:/cpu/reg_file/reg4
add wave -position end  sim:/cpu/reg_file/reg5
add wave -position end  sim:/cpu/reg_file/reg6
add wave -position end  sim:/cpu/reg_file/reg7
add wave -position 2 sim:/cpu/stack_module/*
add wave -position end sim:/cpu/data_memory/*

force -freeze sim:/cpu/clk 0 0, 1 {50 ps} -r 100
force -freeze sim:/cpu/reg_file/rst 1 0
run
force -freeze sim:/cpu/reg_file/rst 0 0
run
run
force -freeze sim:/cpu/in_port  X\"19\" 0  
run
force -freeze sim:/cpu/in_port  X\"FFFF\" 0
run
force -freeze sim:/cpu/in_port  X\"F320\" 0
run
force -freeze sim:/cpu/in_port  X\"10\" 0
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run

#IN R2        #R2=19 add 19 in R2
#IN R3        #R3=FFFF
#IN R4        #R4=F320
#LDM R1,5     #R1=5
#PUSH R1      #SP=FFFFFFFE,M[FFFFFFFF]=5
#PUSH R2      #SP=FFFFFFFD,M[FFFFFFFE]=19
#POP R1       #SP=FFFFFFFE,R1=19
#POP R2       #SP=FFFFFFFF,R2=5
#IN R5        #R5= 10, you should run this test case another time and load R5 with FD60
#STD R2,200(R5)   #M[210]=5, Exception in the 2nd run
#STD R1,201(R5)   #M[211]=19
#LDD R3,201(R5)   #R3=19
#LDD R4,200(R5)   #R4=5
#POP R3  #exception
#ADD R1, R2, R3 #should not execute as their is an exception
