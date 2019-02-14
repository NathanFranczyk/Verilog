
# PlanAhead Launch Script for Pre-Synthesis Floorplanning, created by Project Navigator

create_project -name Ambilight -dir "/home/ise/Verilog/Ambilight/planAhead_run_2" -part xc6slx9tqg144-3
set_param project.pinAheadLayout yes
set srcset [get_property srcset [current_run -impl]]
set_property target_constrs_file "/home/ise/Verilog/mojo-base-project-master/src/mojo.ucf" [current_fileset -constrset]
set hdlfile [add_files [list {../mojo-base-project-master/src/mojo_top.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set_property top mojo_top $srcset
add_files [list {/home/ise/Verilog/mojo-base-project-master/src/mojo.ucf}] -fileset [get_property constrset [current_run]]
open_rtl_design -part xc6slx9tqg144-3
