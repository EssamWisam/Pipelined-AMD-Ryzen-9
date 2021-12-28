vsim work.cpu
add wave -position end  sim:/cpu/clk
add wave -position end  sim:/cpu/inst_memo

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

force -freeze sim:/cpu/reg_file/reg1 X\"1\" 0
force -freeze sim:/cpu/reg_file/reg2 X\"2\" 0
force -freeze sim:/cpu/inst_memo 00000000000000000000010110010000 0
run
force -freeze sim:/cpu/inst_memo 00000000000000000100011000010001 0
run
force -freeze sim:/cpu/inst_memo 00000000000000000100011010010011 0
run
force -freeze sim:/cpu/inst_memo 00000000000011110010001101010100 0
run
force -freeze sim:/cpu/inst_memo 00000000000000000010101110010010 0
run
force -freeze sim:/cpu/inst_memo 00000000000000000000010110001100 0
run
run
run
run
run