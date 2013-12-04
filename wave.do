onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_hdmi_transmitter/tb_sys_clk
add wave -noupdate /tb_hdmi_transmitter/tb_sr_clk
add wave -noupdate /tb_hdmi_transmitter/tb_read_request
add wave -noupdate /tb_hdmi_transmitter/tb_address_line
add wave -noupdate -radix binary /tb_hdmi_transmitter/tb_TMDS_0p
add wave -noupdate -radix binary /tb_hdmi_transmitter/tb_pixelclk
add wave -noupdate /tb_hdmi_transmitter/tb_data_ready
add wave -noupdate /tb_hdmi_transmitter/tb_frame_done
add wave -noupdate -radix unsigned /tb_hdmi_transmitter/tb_data_line
add wave -noupdate -radix unsigned /tb_hdmi_transmitter/decoded_pixel
add wave -noupdate /tb_hdmi_transmitter/tb_pixel_copy
add wave -noupdate /tb_hdmi_transmitter/tb_TMDS_0
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1446885411 ps} 0}
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
WaveRestoreZoom {1446260239 ps} {1447143728 ps}
