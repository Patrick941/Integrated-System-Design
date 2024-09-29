set board_part "xc7z020clg400-1"  
set constraints_file "constraints/PYNQ-Z2v1.0.xdc" 
read_xdc $constraints_file 
set sources [list "rtl/top.sv" "rtl/FSM.sv" "rtl/debouncer.sv" "rtl/counter.sv"]

set_part $board_part

foreach source $sources {
    read_verilog $source
}

synth_design -top top 

opt_design
place_design
route_design

write_bitstream -force "bitstream/top.bit"

close_design
