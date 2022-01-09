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


force -freeze sim:/cpu/clk 0 0, 1 {50 ps} -r 100
force -freeze sim:/cpu/reg_file/rst 1 0
run
force -freeze sim:/cpu/reg_file/rst 0 0
run
run
force -freeze sim:/cpu/in_port  X\"5\" 0  
run
force -freeze sim:/cpu/in_port  X\"19\" 0
run
force -freeze sim:/cpu/in_port  X\"FFFF\" 0
run
force -freeze sim:/cpu/in_port  X\"F320\" 0
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

#IN R1        #add 5 in R1
#IN R2        #add 19 in R2
#IN R3        #FFFF
#IN R4        #F320
#MOV R3,R5    #R5 = FFFF , flags no change
#ADD R4,R1,R4    #R4= F325 , C-->0, N-->1, Z-->0
#SUB R6,R5,R4    #R6= 0CDA , C-->0, N-->0,Z-->0 here carry is implemented as borrow you can implement it as not borrow
#AND R4,R7,R4    #R4= 0000 , C-->no change, N-->0, Z-->1
#IADD R2,R2,FFFF #R2= 0018 (C = 1,N,Z= 0)
#ADD R2,R1,R2    #R2= 001D (C,N,Z= 0)