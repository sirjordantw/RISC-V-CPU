restart -f
force -freeze sim:/cpu/clk 1 0, 0 {50 ns} -r 100
force cpu/rst_n 0
force cpu/io0_in 0
run
force cpu/rst_n 1
run 10000
