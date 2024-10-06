call vivado -mode batch -source tcl/testbench_run.tcl
del vivado.log
del vivado.jou
move lab_temp.sim\sim_1\behav\xsim\HVM.log .
for /d %%d in (lab*) do rmdir /S /Q "%%d"
for %%f in (lab*) do del "%%f"
rmdir /S /Q .Xil