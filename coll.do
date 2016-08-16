   
vlib work

vlog ball_control.v
vsim ball_control

log {/*}

add wave {/*}

force {clk} 0
force {reset} 0
force {PADDLE_HIT} 0

run 10ns

force {clk} 1
force {reset} 0
force {PADDLE_HIT} 0

run 10ns

force {clk} 0
force {reset} 0
force {PADDLE_HIT} 0

run 10ns

force {clk} 1
force {reset} 0
force {PADDLE_HIT} 0

run 10ns

force {clk} 0
force {reset} 0
force {PADDLE_HIT} 0

run 10ns

force {clk} 1
force {reset} 0
force {PADDLE_HIT} 0

run 10ns

force {clk} 0
force {reset} 1
force {PADDLE_HIT} 0
force {x} 9'd240
force {y} 8'd120

run 10ns

force {clk} 1
force {reset} 1
force {PADDLE_HIT} 0
force {x} 9'd240
force {y} 8'd120

run 10ns

force {clk} 0
force {reset} 1
force {PADDLE_HIT} 0
force {x} 9'd240
force {y} 8'd120

run 10ns

force {clk} 1
force {reset} 1
force {PADDLE_HIT} 0
force {x} 9'd240
force {y} 8'd120

run 10ns

force {clk} 0
force {reset} 1
force {PADDLE_HIT} 0
force {x} 9'd120
force {y} 8'd61

run 10ns

force {clk} 1
force {reset} 1
force {PADDLE_HIT} 0
force {x} 9'd120
force {y} 8'd61

run 10ns

force {clk} 0
force {reset} 1
force {PADDLE_HIT} 0
force {x} 9'd120
force {y} 8'd61

run 10ns

force {clk} 1
force {reset} 1
force {PADDLE_HIT} 0
force {x} 9'd120
force {y} 8'd61

run 10ns

force {clk} 0
force {reset} 1
force {PADDLE_HIT} 0
force {x} 9'd120
force {y} 8'd61

run 10ns

force {clk} 1
force {reset} 1
force {PADDLE_HIT} 0
force {x} 9'd120
force {y} 8'd61

run 10ns

force {clk} 0
force {reset} 1
force {PADDLE_HIT} 0
force {x} 9'd120
force {y} 8'd61

run 10ns

force {clk} 1
force {reset} 1
force {PADDLE_HIT} 0
force {x} 9'd120
force {y} 8'd61

run 10ns

force {clk} 0
force {reset} 1
force {PADDLE_HIT} 0
force {x} 9'd120
force {y} 8'd61

run 10ns

force {clk} 1
force {reset} 1
force {PADDLE_HIT} 0
force {x} 9'd120
force {y} 8'd61

run 10ns

force {clk} 0
force {reset} 1
force {PADDLE_HIT} 0
force {x} 9'd120
force {y} 8'd61

run 10ns

force {clk} 1
force {reset} 1
force {PADDLE_HIT} 0
force {x} 9'd120
force {y} 8'd61

run 10ns

force {clk} 0
force {reset} 1
force {PADDLE_HIT} 0
force {x} 9'd120
force {y} 8'd61

run 10ns

force {clk} 1
force {reset} 1
force {PADDLE_HIT} 0
force {x} 9'd120
force {y} 8'd61

run 10ns