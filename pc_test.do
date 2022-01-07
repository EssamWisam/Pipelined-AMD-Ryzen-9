vsim work.pc
# vsim work.pc 
# Start time: 16:18:05 on Jan 07,2022
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading ieee.numeric_std(body)
# Loading work.pc(a_pc)
add wave -position insertpoint sim:/pc/*
force -freeze sim:/pc/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/pc/isLongInst 1 0
run
run
force -freeze sim:/pc/isLongInst 0 0
run
force -freeze sim:/pc/isLongInst 0 0
run
force -freeze sim:/pc/ex1 1 0
force -freeze sim:/pc/ex1_addr x\"1123\" 0
run
run
force -freeze sim:/pc/ex1 0 0
force -freeze sim:/pc/ex2 1 0
force -freeze sim:/pc/ex2_addr x\"1000\" 0
run
run
force -freeze sim:/pc/ex2 0 0
force -freeze sim:/pc/rst 1 0
run
force -freeze sim:/pc/rst 0 0
run
run
run
run
force -freeze sim:/pc/freeze 1 0
run
run
force -freeze sim:/pc/freeze 0 0
run
run
force -freeze sim:/pc/pc_src 01 0
force -freeze sim:/pc/Cond 1 0
force -freeze sim:/pc/data_32 x\"0101\" 0
run
force -freeze sim:/pc/Cond 0 0
run
force -freeze sim:/pc/extended_Rsrc x\"1110\" 0
force -freeze sim:/pc/Cond 1 0
run
force -freeze sim:/pc/Cond 0 0
run
force -freeze sim:/pc/Cond 1 0
force -freeze sim:/pc/pc_src 10 0
run
force -freeze sim:/pc/Cond 0 0
force -freeze sim:/pc/isLongInst 1 0
run
force -freeze sim:/pc/rst 1 0
run
#this independently tests the program counter.