  
vlib work

vlog paddle_control.v
vsim paddle_control

log {/*}

add wave {/*}

force {clk} 0
force {resetn} 0
force {go[1]} 0
force {go[0]} 0

run 10ns

force {clk} 1
force {resetn} 0
force {go[1]} 0
force {go[0]} 0

run 10ns

force {clk} 0
force {resetn} 1
force {go[1]} 0
force {go[0]} 0

run 10ns

force {clk} 1
force {resetn} 1
force {go[1]} 0
force {go[0]} 0

run 10ns

force {clk} 0
force {resetn} 1
force {go[1]} 0
force {go[0]} 0

run 10ns

force {clk} 1
force {resetn} 1
force {go[1]} 0
force {go[0]} 0

run 10ns

force {clk} 0
force {resetn} 1
force {go[1]} 1
force {go[0]} 0

run 10ns

force {clk} 1
force {resetn} 1
force {go[1]} 1
force {go[0]} 0

run 10ns

force {clk} 0
force {resetn} 1
force {go[1]} 1
force {go[0]} 0

run 10ns

force {clk} 1
force {resetn} 1
force {go[1]} 1
force {go[0]} 0

run 10ns

force {clk} 0
force {resetn} 1
force {go[1]} 1
force {go[0]} 0

run 10ns

force {clk} 1
force {resetn} 1
force {go[1]} 1
force {go[0]} 0

run 10ns

force {clk} 0
force {resetn} 1
force {go[1]} 0
force {go[0]} 0

run 10ns

force {clk} 1
force {resetn} 1
force {go[1]} 0
force {go[0]} 0

run 10ns

force {clk} 0
force {resetn} 1
force {go[1]} 0
force {go[0]} 0

run 10ns

force {clk} 1
force {resetn} 1
force {go[1]} 0
force {go[0]} 0

run 10ns

