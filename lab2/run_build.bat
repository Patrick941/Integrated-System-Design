call vivado -mode batch -source tcl/build.tcl -log temp/vivado.log -journal temp/vivado.jou
del temp/vivado.log
del temp/vivado.jou
del clockInfo.txt
rmdir /S /Q .Xil