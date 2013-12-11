onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /tb_stageOne/tb_in
add wave -noupdate -radix unsigned /tb_stageOne/test_out
add wave -noupdate -radix unsigned /tb_stageOne/exp_out
add wave -noupdate /tb_stageOne/err_flag
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {30329 ps} 0}
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
WaveRestoreZoom {0 ps} {128 ns}
run 30 ns
