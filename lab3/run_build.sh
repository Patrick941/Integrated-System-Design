#!/bin/bash
project_dir=~/Downloads/pynq_files_build/boards/Pynq-Z2/base
working_dir=`pwd`

vivado -mode batch -source tcl/build.tcl -tclargs $project_dir

pushd $working_dir
rm -f *.log *.jou
rm -rf .Xil
popd

pushd $project_dir
mv *.bit $working_dir/bitstream/top.bit
mv *.hwh $working_dir/bitstream/top.hwh
# rm -rf lab*
popd