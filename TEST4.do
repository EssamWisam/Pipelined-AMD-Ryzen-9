vsim work.cpu
add wave -position end  sim:/cpu/clk
add wave -position end  sim:/cpu/rst
add wave -position end  sim:/cpu/in_port
add wave -position end  sim:/cpu/out_port
add wave -position end  sim:/cpu/pc_addr
add wave -position end  sim:/cpu/pc_reg/epc
add wave -position end  sim:/cpu/stack_module/address_reg
add wave -position end  sim:/cpu/stack_module/address_reg_temp_pop
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
force -freeze sim:/cpu/in_port  X\"10\" 0  
run
force -freeze sim:/cpu/in_port  X\"1D\" 0
run
force -freeze sim:/cpu/in_port  X\"102\" 0
run
force -freeze sim:/cpu/in_port  X\"302\" 0
run
run
run
run
run
run
run
run
force -freeze sim:/cpu/in_port  X\"2D\" 0
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
run
run
run
run
run

#IN R1     #R1=10
#IN R2     #R2=1D
#IN R3     #R3=102
#IN R4     #R4=302
#Push R4   #sp=FFFFFFFE, M[FFFFFFFF]=300
#JMP R1 
#INC R1	  # this statement shouldn't be executed
# 
##check flag fowarding  
#.ORG 30
#AND R5,R1,R5   #R5=0 , Z = 1
#JZ  R2      #Jump taken, Z = 0
#SETC        # this statement shouldn't be executed, C-->1
#
##check on flag updated on jump
#.ORG 50
#JZ R1      #shouldn't be taken
#JC R3      #Jump Not taken
#
##check destination forwarding
#NOT R5     #R5=FFFF, Z= 0, C--> not change, N=1
#IN  R6     #R6=2D, flag no change
#JN  R6     #jump taken, N = 0
#INC R1     # this statement shouldn't be executed
#
#
##check on load use
#.ORG 700
#SETC      #C-->1
#POP R6     #R6=300, SP=FFFFFFFF
#INC R6	  #R6=401, this statement shouldn't be executed till call returns, C--> 0, N-->0,Z-->0
#NOP
#NOP