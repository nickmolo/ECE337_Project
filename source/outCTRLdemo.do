onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_output_controller/tb_n_rst
add wave -noupdate /tb_output_controller/tb_clk
add wave -noupdate /tb_output_controller/tb_pixelclk
add wave -noupdate /tb_output_controller/tb_rowcount
add wave -noupdate /tb_output_controller/tb_colcount
add wave -noupdate /tb_output_controller/tb_out_sel
add wave -noupdate /tb_output_controller/tb_hsync
add wave -noupdate /tb_output_controller/tb_vsync
add wave -noupdate /tb_output_controller/tb_sr_sel
add wave -noupdate /tb_output_controller/tb_2load
add wave -noupdate /tb_output_controller/tb_1load
add wave -noupdate /tb_output_controller/err_flag
add wave -noupdate /tb_output_controller/err_flag2
add wave -noupdate /tb_output_controller/err_flag3
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {2576579 ps}
run 40 ms
