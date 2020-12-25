library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

PACKAGE constants_and_types IS
	CONSTANT Win     : INTEGER := 8  ; -- Input bit width
	CONSTANT Wmult   : INTEGER := 16 ; -- Multiplier bit width 2*Win
	CONSTANT Linput  : INTEGER := 5  ; -- Input length
	CONSTANT Lref    : INTEGER := 3  ; -- Reference length
	CONSTANT Lfilter : INTEGER := 2  ; -- Filter Length
	SUBTYPE IN_TYPE IS STD_LOGIC_VECTOR(Win-1 DOWNTO 0);
	SUBTYPE OUT_TYPE IS STD_LOGIC_VECTOR(Wmult-1 DOWNTO 0);
	TYPE ARRAY_COEFF IS ARRAY (NATURAL RANGE <>) OF IN_TYPE;
END constants_and_types;

LIBRARY work;
USE work.constants_and_types.ALL;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity tb_fir_filter_test is

end tb_fir_filter_test;

architecture behave of tb_fir_filter_test is

component fir_filter_lms_test
port (
	clk                   	: in  std_logic;
	reset                  	: in  std_logic;
	o_data_buffer           : out OUT_TYPE;
	o_fir_coeff1         	: out IN_TYPE;
	o_fir_coeff2         	: out IN_TYPE;
	o_inputref           		: out IN_TYPE;
	o_inputdata           		: out IN_TYPE;
	o_error           		: out OUT_TYPE);
end component;

signal clk                     : std_logic:='0';
signal reset                   : std_logic;
signal read_out                : integer;
signal o_data_buffer           : OUT_TYPE;
signal o_fir_coeff1            : IN_TYPE;
signal o_fir_coeff2            : IN_TYPE;
signal o_inputref              : IN_TYPE;
signal o_inputdata             : IN_TYPE;
signal o_error                 : OUT_TYPE;

begin

clk   <= not clk after 5 ns;
reset  <= '0', '1' after 132 ns;

u_fir_filter_lms_test : fir_filter_lms_test
port map(
	clk              	 => clk              ,
	reset                => reset            ,
	o_data_buffer        => o_data_buffer    ,	
	o_fir_coeff1         => o_fir_coeff1     ,	
	o_fir_coeff2         => o_fir_coeff2     ,	
	o_inputref           => o_inputref       ,	
	o_inputdata          => o_inputdata      ,	
	o_error         	 => o_error          );	

--p_dump  : process(reset,read_out)
--file test_vector      : text open write_mode is "output_file.txt";
--variable row          : line;
--begin
--  
--	if(reset='0') then
--	------------------------------------
--	--elsif(rising_edge(read_out)) then
--	elsif(read_out<1060) then
--		write(row,to_integer(signed(o_data_buffer)), left, 10);			
--		writeline(test_vector,row);
--	end if;
--end process p_dump;

end behave;

