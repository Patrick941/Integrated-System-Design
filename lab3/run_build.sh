#!/bin/bash
project_dir=~/Downloads/pynq_files_build/boards/Pynq-Z2/base
working_dir=`pwd`

vivado -mode batch -source tcl/build.tcl -tclargs $project_dir


pushd $working_dir
rm -f *.log *.jou
rm -rf .Xil
popd

pushd $project_dir
# rm -rf lab*
popd