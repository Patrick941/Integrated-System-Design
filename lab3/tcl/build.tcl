set project_name "lab"
if {[llength $argv] != 1} {
    puts "Usage: project_setup.tcl <project_directory>"
    exit 1
}
set working_dir [pwd]
set project_dir [lindex $argv 0]

create_project $project_name $project_dir -part xc7z020clg400-1 -force
cd $project_dir

source [file join $project_dir build_ip.tcl]
source [file join $project_dir base.tcl]

open_bd_design lab.srcs/sources_1/bd/base_filter/base_filter.bd
write_bd_layout -format pdf -orientation portrait $working_dir/block_diagram.pdf

close_project
quit