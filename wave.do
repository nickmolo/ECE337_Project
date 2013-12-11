onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_timertop/tb_clk
add wave -noupdate /tb_timertop/tb_sr_clk
add wave -noupdate /tb_timertop/tb_n_rst
add wave -noupdate /tb_timertop/tb_enable
add wave -noupdate /tb_timertop/tb_addr_enable
add wave -noupdate /tb_timertop/tb_flag_addr
add wave -noupdate /tb_timertop/tb_pixel_test
add wave -noupdate /tb_timertop/tb_pixel_clk
add wave -noupdate /tb_timertop/tb_flag_pulse
add wave -noupdate -radix unsigned /tb_timertop/tb_counter_out_row
add wave -noupdate -radix unsigned /tb_timertop/tb_counter_out_col
add wave -noupdate -radix unsigned /tb_timertop/tb_counter_out_addr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {16367610600 ps} 0} {{Cursor 2} {22378566405 ps} 0} {{Cursor 3} {22335031334 ps} 0} {{Cursor 4} {16071694652 ps} 0} {{Cursor 5} {16071760064 ps} 0} {{Cursor 6} {16071734737 ps} 0} {{Cursor 7} {16071799956 ps} 0}
quietly wave cursor active 0
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
WaveRestoreZoom {0 ps} {84003520512 ps}
