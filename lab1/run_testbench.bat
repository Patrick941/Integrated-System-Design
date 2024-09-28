call vivado -mode batch -source tcl/testbench_run.tcl
del vivado.log
del vivado.jou
for /d %%d in (lab*) do rmdir /S /Q "%%d"
rmdir /S /Q .Xil