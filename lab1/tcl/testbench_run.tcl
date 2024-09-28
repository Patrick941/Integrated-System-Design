# Define the project and testbench
set project_name "lab1_temp"
set testbench_name "testbenches/FSM_tb.sv"

# Check if the project exists, if not create it
if {![file exists $project_name]} {
    create_project $project_name -part xc7z020clg400-1
}
set directories [list "rtl"]
foreach dir $directories {
    set sv_files [glob -nocomplain -directory $dir *.sv *.v]
    foreach file $sv_files {
        add_files $file
    }
}

set sources $sv_files
add_files -fileset sources_1 [join $sources " "]

update_compile_order -fileset sources_1

puts "Fileset contents:========================================================"
foreach file [get_files -of_objects [get_filesets sources_1]] {
    puts $file
}

add_files -fileset sim_1 $testbench_name
set_property top "FSM_tb" [get_fileset sim_1]


launch_simulation

set curr_wave [current_wave_config]
if { [string length $curr_wave] == 0 } {
  if { [llength [get_objects]] > 0} {
    add_wave /
    set_property needs_save false [current_wave_config]
  } else {
     send_msg_id Add_Wave-1 WARNING "No top level signals found. Simulator will start without a wave window. If you want to open a wave window go to 'File->New Waveform Configuration' or type 'create_wave_config' in the TCL console."
  }
}

run 1000ns
quit

# Close the project
close_project
quit