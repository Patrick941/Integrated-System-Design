open_hw_manager
connect_hw_server
open_hw_target
current_hw_device [get_hw_devices xc7z020_1]

set bitstream_file "bitstream/top.bit"

set_property PROGRAM.FILE $bitstream_file [current_hw_device]
program_hw_devices

close_hw_manager
exit