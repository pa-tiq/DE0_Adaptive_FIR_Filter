onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic -radix unsigned /tb_fir_filter/u_fir_filter_lms/clk
add wave -noupdate -format Logic -radix unsigned /tb_fir_filter/u_fir_filter_lms/reset
add wave -noupdate -format AnalogAutomatic -radix decimal /tb_fir_filter/u_fir_filter_lms/i_data
add wave -noupdate -format Logic -radix decimal /tb_fir_filter/u_fir_filter_lms/i_data
add wave -noupdate -format AnalogAutomatic -radix decimal /tb_fir_filter/u_fir_filter_lms/i_ref
add wave -noupdate -format Logic -radix decimal /tb_fir_filter/u_fir_filter_lms/i_ref
add wave -noupdate -format AnalogAutomatic -radix decimal /tb_fir_filter/u_fir_filter_lms/o_coeff0 
add wave -noupdate -format AnalogAutomatic -radix decimal /tb_fir_filter/u_fir_filter_lms/o_coeff1 
add wave -noupdate -format AnalogAutomatic -radix decimal /tb_fir_filter/u_fir_filter_lms/o_coeff2 
add wave -noupdate -format AnalogAutomatic -radix decimal /tb_fir_filter/u_fir_filter_lms/o_coeff3 
add wave -noupdate -format AnalogAutomatic -radix decimal /tb_fir_filter/u_fir_filter_lms/o_coeff4 
add wave -noupdate -format AnalogAutomatic -radix decimal /tb_fir_filter/u_fir_filter_lms/o_coeff5 
add wave -noupdate -format AnalogAutomatic -radix decimal /tb_fir_filter/u_fir_filter_lms/o_coeff6 
add wave -noupdate -format AnalogAutomatic -radix decimal /tb_fir_filter/u_fir_filter_lms/o_coeff7 
add wave -noupdate -format AnalogAutomatic -radix decimal /tb_fir_filter/u_fir_filter_lms/o_coeff8 
add wave -noupdate -format AnalogAutomatic -radix decimal /tb_fir_filter/u_fir_filter_lms/o_coeff9 
add wave -noupdate -format AnalogAutomatic -radix decimal /tb_fir_filter/u_fir_filter_lms/o_coeff10
add wave -noupdate -format AnalogAutomatic -radix decimal /tb_fir_filter/u_fir_filter_lms/o_coeff11
add wave -noupdate -format AnalogAutomatic -radix decimal /tb_fir_filter/u_fir_filter_lms/o_coeff12
add wave -noupdate -format AnalogAutomatic -radix decimal /tb_fir_filter/u_fir_filter_lms/o_coeff13
add wave -noupdate -format AnalogAutomatic -radix decimal /tb_fir_filter/u_fir_filter_lms/o_coeff14
add wave -noupdate -format AnalogAutomatic -radix decimal /tb_fir_filter/u_fir_filter_lms/o_coeff15
add wave -noupdate -format AnalogAutomatic -radix decimal /tb_fir_filter/u_fir_filter_lms/o_coeff16
add wave -noupdate -format AnalogAutomatic -radix decimal /tb_fir_filter/u_fir_filter_lms/o_coeff17
add wave -noupdate -format AnalogAutomatic -radix decimal /tb_fir_filter/u_fir_filter_lms/o_coeff18
add wave -noupdate -format AnalogAutomatic -radix decimal /tb_fir_filter/u_fir_filter_lms/o_coeff19
add wave -noupdate -format AnalogAutomatic -radix decimal /tb_fir_filter/u_fir_filter_lms/o_coeff20
add wave -noupdate -format AnalogAutomatic -radix decimal /tb_fir_filter/u_fir_filter_lms/o_coeff21
add wave -noupdate -format AnalogAutomatic -radix decimal /tb_fir_filter/u_fir_filter_lms/o_coeff22
add wave -noupdate -format AnalogAutomatic -radix decimal /tb_fir_filter/u_fir_filter_lms/o_coeff23
add wave -noupdate -format AnalogAutomatic -radix decimal /tb_fir_filter/u_fir_filter_lms/o_coeff24
add wave -noupdate -format AnalogAutomatic -radix decimal /tb_fir_filter/u_fir_filter_lms/o_coeff25
add wave -noupdate -format AnalogAutomatic -radix decimal /tb_fir_filter/u_fir_filter_lms/o_coeff26
add wave -noupdate -format AnalogAutomatic -radix decimal /tb_fir_filter/u_fir_filter_lms/o_coeff27
add wave -noupdate -format AnalogAutomatic -radix decimal /tb_fir_filter/u_fir_filter_lms/o_coeff28
add wave -noupdate -format AnalogAutomatic -radix decimal /tb_fir_filter/u_fir_filter_lms/o_coeff29
add wave -noupdate -format AnalogAutomatic -radix decimal /tb_fir_filter/u_fir_filter_lms/o_coeff30
add wave -noupdate -format AnalogAutomatic -radix decimal /tb_fir_filter/u_fir_filter_lms/o_coeff31
add wave -noupdate -format AnalogAutomatic -radix decimal /tb_fir_filter/u_fir_filter_lms/o_data
add wave -noupdate -format Literal -radix decimal /tb_fir_filter/u_fir_filter_lms/o_data
add wave -noupdate -format AnalogAutomatic -radix decimal /tb_fir_filter/u_fir_filter_lms/o_error
add wave -noupdate -format Literal -radix decimal /tb_fir_filter/u_fir_filter_lms/o_error
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
