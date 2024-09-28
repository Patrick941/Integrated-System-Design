call vivado -mode batch -source tcl/program_fpga.tcl -log temp/vivado.log -journal temp/vivado.jou
del temp/vivado.log
del temp/vivado.jou