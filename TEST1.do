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
force -freeze sim:/cpu/in_port  X\"5\" 0
run
run
run
run
run
run
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
#SETC           #C --> 1
#NOP            #No change
#NOT R1         #R1 =FFFF , C--> no change, N --> 1, Z --> 0
#INC R1	       #R1 =0000 , C --> 1 , N --> 0 , Z --> 1
#IN R1	       #R1= 5,add 5 on the in port,flags no change	
#IN R2          #R2= 10,add 10 on the in port, flags no change
#NOT R2	       #R2= FFFFFFEF, C--> no change, N -->1,Z-->0
#INC R1         #R1= 6, C --> 0, N -->0, Z-->0
#OUT R1
#OUT R2
#HLT