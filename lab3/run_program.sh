#!/bin/bash

vivado -mode batch -source tcl/program_fpga.tcl -log temp/vivado.log -journal temp/vivado.jou
rm temp/vivado.log temp/vivado.jou