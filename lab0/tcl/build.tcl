# Define project variables
set board_part "xc7z020clg400-1"  ;# PYNQ-Z2 board part
set constraints_file "constraints/PYNQ-Z2v1.0.xdc"  ;# Replace with your actual constraints file
read_xdc $constraints_file 
set sources [list "rtl/lab0_top.sv"]  ;# Replace with your actual source files

# Set the target part
set_part $board_part

# Add sources to the project
foreach source $sources {
    read_verilog $source
}

# Set the top module
synth_design -top lab0_top  ;# Replace 'lab0_top' with the actual top module name

# Run implementation
opt_design
place_design
route_design

# Generate bitstream
write_bitstream -force "bitstream/lab0_top.bit"

file delete -force vivado.log
file delete -force vivado.jou

# Close the design
close_design


