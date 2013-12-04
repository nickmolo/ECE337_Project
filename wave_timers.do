onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_timertop/tb_clk
add wave -noupdate /tb_timertop/tb_pixel_test
add wave -noupdate /tb_timertop/tb_pixel_clk
add wave -noupdate /tb_timertop/tb_sr_clk
add wave -noupdate -radix unsigned /tb_timertop/tb_counter_out_row
add wave -noupdate -radix unsigned /tb_timertop/tb_counter_out_col
add wave -noupdate -radix unsigned /tb_timertop/tb_counter_out_addr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {942861510 ps} 0}
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
WaveRestoreZoom {942777020 ps} {942937260 ps}
run 20 ms