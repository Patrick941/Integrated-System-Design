# Define the project and testbench
set project_name "lab1_temp"
set testbench_name "testbenches/FSM_tb.sv"

# Check if the project exists, if not create it
if {![file exists $project_name]} {
    create_project $project_name -force
}

# Launch the simulation
launch_simulation -name $testbench_name

# Run the simulation
run all

# Print the log to the terminal
puts [get_simulation_log]

# Close the project
close_project
# Close the simulation
quit

# Quit the simulation
quit