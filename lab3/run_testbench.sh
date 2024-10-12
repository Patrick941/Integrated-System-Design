#!/bin/bash

vivado -mode batch -source tcl/testbench_run.tcl
rm -f vivado.log vivado.jou
mv lab_temp.sim/sim_1/behav/xsim/HVM.log .
rm -rf lab* .Xil
