##-------------------------------------------------------------------------
## Clock and I/O Pin Constraints
##-------------------------------------------------------------------------
set_property -dict { PACKAGE_PIN H16   IOSTANDARD LVCMOS33 } [get_ports { sys_clk }];
create_clock -add -name sys_clk_pin -period 8.00 -waveform {0 4} [get_ports { sys_clk }];

set_property -dict { PACKAGE_PIN Y18   IOSTANDARD LVCMOS33 } [get_ports { top_random_out }];


##-------------------------------------------------------------------------
## Ring Oscillator / Combinational Loop Overrides
##-------------------------------------------------------------------------

# Downgrade the "Combinational Loop" error to a warning so Bitstream can generate
set_property SEVERITY {Warning} [get_drc_checks LUTLP-1]

# Downgrade "No clock connected to sequential cell" warning
set_property SEVERITY {Warning} [get_drc_checks NSTD-1]

# Allow combinatorial loops for all units in the TRNG
set_property ALLOW_COMBINATORIAL_LOOPS TRUE [get_nets TRNG_inst*/ACR30_0/current]
set_property ALLOW_COMBINATORIAL_LOOPS TRUE [get_nets TRNG_inst*/ACR30_1/current]
set_property ALLOW_COMBINATORIAL_LOOPS TRUE [get_nets TRNG_inst*/ACR30_2/current]
set_property ALLOW_COMBINATORIAL_LOOPS TRUE [get_nets TRNG_inst*/ACR30_3/current]
set_property ALLOW_COMBINATORIAL_LOOPS TRUE [get_nets TRNG_inst*/ACR30_4/current]
set_property ALLOW_COMBINATORIAL_LOOPS TRUE [get_nets TRNG_inst*/ACR30_5/current]
set_property ALLOW_COMBINATORIAL_LOOPS TRUE [get_nets TRNG_inst*/ACR30_6/current]
set_property ALLOW_COMBINATORIAL_LOOPS TRUE [get_nets TRNG_inst*/ACR30_7/current]
set_property ALLOW_COMBINATORIAL_LOOPS TRUE [get_nets TRNG_inst*/ACR30_middle/current]

# Do not optimize TRNG circuits
set_property DONT_TOUCH true [get_cells TRNG_inst*/ACR30_*]
set_property DONT_TOUCH true [get_nets TRNG_inst*/ACR30_*/current]