   
vlib work

vlog new_draw.v
vsim new_draw

log {/*}

add wave {/*}

force {clk} 0
force {reset} 0

run 10ns

force {clk} 1
force {reset} 0

run 10ns

force {clk} 0
force {reset} 1

run 10ns

force {clk} 1
force {reset} 1

run 10ns

force {clk} 0
force {reset} 1

run 10ns

force {clk} 1
force {reset} 1

run 10ns

force {clk} 0
force {reset} 1

run 10ns

force {clk} 1
force {reset} 1

run 10ns

force {clk} 0
force {reset} 1

run 10ns

force {clk} 1
force {reset} 1

run 10ns

force {clk} 0
force {reset} 1

run 10ns

force {clk} 1
force {reset} 1

run 10ns

force {clk} 0
force {reset} 1

run 10ns

force {clk} 1
force {reset} 1

run 10ns

force {clk} 0
force {reset} 1

run 10ns

force {clk} 1
force {reset} 1

run 10ns