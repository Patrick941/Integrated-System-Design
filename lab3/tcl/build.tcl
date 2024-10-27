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

start_gui
open_bd_design lab.srcs/sources_1/bd/base_filter/base_filter.bd

startgroup
set_property -dict [list \
    CONFIG.CoefficientSource {COE_File} \
    CONFIG.Coefficient_File {/home/patrick/Documents/Year5Semester1/IntegratedSystemDesign/labs/lab3/outputs/filter_coefficients.coe} \
    CONFIG.Coefficient_Fractional_Bits {0} \
    CONFIG.Coefficient_Sets {1} \
    CONFIG.Coefficient_Sign {Signed} \
    CONFIG.Coefficient_Structure {Inferred} \
    CONFIG.Coefficient_Width {16} \
    CONFIG.Data_Width {32} \
    CONFIG.Output_Width {32} \
    CONFIG.Quantization {Integer_Coefficients} \
] [get_bd_cells fir_compiler_0]
endgroup

write_bd_layout -format pdf -orientation landscape $working_dir/outputs/block_diagram.pdf -force
stop_gui

source [file join $project_dir build_bitstream.tcl]

close_project
quit