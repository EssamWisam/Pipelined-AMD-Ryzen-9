vsim work.cpu
add wave -position end  sim:/cpu/clk
add wave -position end  sim:/cpu/pc_addr
add wave -position end  sim:/cpu/inst_memo
add wave -position end  sim:/cpu/reg_file/reg0
add wave -position end  sim:/cpu/reg_file/reg1
add wave -position end  sim:/cpu/reg_file/reg2
add wave -position end  sim:/cpu/reg_file/reg3
add wave -position end  sim:/cpu/reg_file/reg4
add wave -position end  sim:/cpu/reg_file/reg5
add wave -position end  sim:/cpu/reg_file/reg6
add wave -position end  sim:/cpu/reg_file/reg7
add wave -position end  sim:/cpu/flag_out
add wave -position end  sim:/cpu/flag_in
add wave -position end  sim:/cpu/data_memory/addr
add wave -position end  sim:/cpu/data_memory/data_in_32
add wave -position insertpoint sim:/cpu/stack_module/*

force -freeze sim:/cpu/reg_file/rst 1 0
force -freeze sim:/cpu/clk 0 0, 1 {50 ps} -r 100
force -freeze sim:/cpu/reg_file/rst 1 0
run
force -freeze sim:/cpu/reg_file/rst 0 0

force -freeze sim:/cpu/reg_file/reg1 X\"00FF\" 0
force -freeze sim:/cpu/reg_file/reg2 X\"00F1\" 0