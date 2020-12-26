onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic -radix unsigned /tb_fir_filter/u_fir_filter_lms/clk
add wave -noupdate -format Logic -radix unsigned /tb_fir_filter/u_fir_filter_lms/reset
add wave -noupdate -format AnalogAutomatic -radix decimal /tb_fir_filter/u_fir_filter_lms/i_data
add wave -noupdate -format Logic -radix decimal /tb_fir_filter/u_fir_filter_lms/i_data
add wave -noupdate -format AnalogAutomatic -radix decimal /tb_fir_filter/u_fir_filter_lms/i_ref
add wave -noupdate -format Logic -radix decimal /tb_fir_filter/u_fir_filter_lms/i_ref
add wave -noupdate -format AnalogAutomatic -radix decimal /tb_fir_filter/u_fir_filter_lms/o_coeff
add wave -noupdate -format Logic -radix decimal /tb_fir_filter/u_fir_filter_lms/o_coeff
add wave -noupdate -format AnalogAutomatic -radix decimal /tb_fir_filter/u_fir_filter_lms/o_data
add wave -noupdate -format Literal -radix decimal /tb_fir_filter/u_fir_filter_lms/o_data
add wave -noupdate -format AnalogAutomatic -radix decimal /tb_fir_filter/u_fir_filter_lms/o_error
add wave -noupdate -format Literal -radix decimal /tb_fir_filter/u_fir_filter_lms/o_error
add wave -noupdate -format Literal -radix decimal /tb_fir_filter/read_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1995 ns} 0}
configure wave -namecolwidth 150
configure wave -valuecolwidth 77
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
configure wave -timelineunits ns
update
WaveRestoreZoom {1036 ns} {8475 ns}
