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
force -freeze sim:/cpu/in_port  X\"30\" 0  
run
force -freeze sim:/cpu/in_port  X\"50\" 0
run
force -freeze sim:/cpu/in_port  X\"100\" 0
run
force -freeze sim:/cpu/in_port  X\"300\" 0
run
run
run
run
run
run
run
run
force -freeze sim:/cpu/in_port  X\"700\" 0
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