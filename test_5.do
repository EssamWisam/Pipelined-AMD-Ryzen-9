vsim work.cpu
add wave -position insertpoint  \
sim:/cpu/clk


add wave -position end  sim:/cpu/inst_memo
add wave -position end  sim:/cpu/in_port
add wave -position end  sim:/cpu/out_port
add wave -position end  sim:/cpu/alu_result


add wave -position end  sim:/cpu/reg_file/reg0
add wave -position end  sim:/cpu/reg_file/reg1
add wave -position end  sim:/cpu/reg_file/reg2
add wave -position end  sim:/cpu/reg_file/reg3
add wave -position end  sim:/cpu/reg_file/reg4
add wave -position end  sim:/cpu/reg_file/reg5
add wave -position end  sim:/cpu/reg_file/reg6
add wave -position end  sim:/cpu/reg_file/reg7


force -freeze sim:/cpu/clk 0 0, 1 {50 ps} -r 100
run
force -freeze sim:/cpu/reg_file/reg1 X\"4\" 0
force -freeze sim:/cpu/reg_file/reg2 X\"7\" 0
force -freeze sim:/cpu/reg_file/reg6 X\"10\" 0
force -freeze sim:/cpu/in_port X\"3\" 0
force -freeze sim:/cpu/inst_memo 00000000000000000000000110001110 0
run
force -freeze sim:/cpu/inst_memo 00000000000000000100011000010001 0
run
force -freeze sim:/cpu/inst_memo 00000000000000001100011010010001 0
run
force -freeze sim:/cpu/inst_memo 00000000000000000010110110010001 0
run
force -freeze sim:/cpu/inst_memo 00000000000000000000110000001101 0
run
run
run
run
run
run

