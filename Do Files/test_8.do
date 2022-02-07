vsim work.cpu
add wave -position end  sim:/cpu/clk
add wave -position end  sim:/cpu/pc_addr
add wave -position end  sim:/cpu/inst_memo
add wave -position end  sim:/cpu/stage1_reg
add wave -position end  sim:/cpu/stage2_reg
add wave -position end  sim:/cpu/stage3_reg
add wave -position end  sim:/cpu/stage4_reg
add wave -position end  sim:/cpu/flag_out
add wave -position end  sim:/cpu/flag_en
add wave -position end  sim:/cpu/flag_in

force -freeze sim:/cpu/clk 0 0, 1 {50 ps} -r 100
force -freeze sim:/cpu/reg_file/rst 1 0
run
force -freeze sim:/cpu/reg_file/rst 0 0
force -freeze sim:/cpu/flag_en 1 0

force -freeze sim:/cpu/reg_file/reg1 X\"00FF\" 0
force -freeze sim:/cpu/reg_file/reg2 X\"00F1\" 0