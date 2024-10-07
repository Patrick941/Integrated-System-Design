#!/bin/bash

vivado -mode batch -source tcl/build.tcl -log temp/vivado.log -journal temp/vivado.jou

rm -rf temp/vivado.jou clockInfo.txt temp/vivado.log .Xil