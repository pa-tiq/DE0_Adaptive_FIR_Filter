vcom -reportprogress 300 -work work C:/Users/patiq/Documents/Projects/DE0_Adaptive_FIR_Filter/tb_gohorse/tb_fir_filter.vhd
vcom -reportprogress 300 -work work C:/Users/patiq/Documents/Projects/DE0_Adaptive_FIR_Filter/fir_filter_lms_gohorse.vhd

vcom -work work ../fir_filter_lms_gohorse.vhd
vcom -work work -O0 ./tb_fir_filter.vhd

vsim work.tb_fir_filter -novopt -t ns
do wave_fir_filter.do