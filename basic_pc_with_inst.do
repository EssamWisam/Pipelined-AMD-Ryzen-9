vsim work.pc
# vsim work.pc 
# Start time: 17:52:43 on Jan 07,2022
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading ieee.numeric_std(body)
# Loading work.pc(a_pc)
# Loading work.inst_memory(a_inst_memory)
add wave -position insertpoint sim:/pc/*
force -freeze sim:/pc/clk 1 0, 0 {50 ps} -r 100
run
run
run
run
force -freeze sim:/pc/isLongInst 1 0
run
run
run
run
run
