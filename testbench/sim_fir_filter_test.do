vcom -reportprogress 300 -work work C:/Users/patiq/Documents/Projects/DE0_Adaptive_FIR_Filter/fir_filter_lms.vhd
vcom -reportprogress 300 -work work C:/Users/patiq/Documents/Projects/DE0_Adaptive_FIR_Filter/fir_filter_lms_test.vhd
vcom -reportprogress 300 -work work C:/Users/patiq/Documents/Projects/DE0_Adaptive_FIR_Filter/testbench/tb_fir_filter_test.vhd

vcom  -work work ../fir_filter_lms.vhd
vcom  -work work ../fir_filter_lms_test.vhd
vcom -work work -O0 ./tb_fir_filter_test.vhd

vsim work.tb_fir_filter_test -novopt -t ns
do wave_fir_filter_test.do
