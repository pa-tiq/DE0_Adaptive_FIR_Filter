library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

PACKAGE constants_and_types IS
	CONSTANT Win     : INTEGER := 8 ; -- Input bit width
	CONSTANT Wmult   : INTEGER := 16 ; -- Multiplier bit width 2*Win
	CONSTANT Lfilter : INTEGER := 32  ; -- Filter Length (2)
	CONSTANT learning_rate : INTEGER := 4  ; -- 1 to 4
	SUBTYPE IN_TYPE IS STD_LOGIC_VECTOR(Win-1 DOWNTO 0);
	SUBTYPE OUT_TYPE IS STD_LOGIC_VECTOR(Wmult-1 DOWNTO 0);
	TYPE ARRAY_COEFF IS ARRAY (0 to Lfilter-1) OF IN_TYPE;
END constants_and_types;

LIBRARY work;
USE work.constants_and_types.ALL;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity tb_fir_filter is

end tb_fir_filter;

architecture behave of tb_fir_filter is

	constant p : integer := (2**(Win-1))-1; --precision

	--constant in_size   : integer := 64;
	constant in_size   : integer := 548;
	constant out_size  : integer := 1060;
	--constant out_size  : integer := 64;

	type T_IN_ARRAY    is array (0 to in_size-1)  of integer range -(p+1) to p;
	type T_OUT_ARRAY   is array (0 to out_size-1) of integer range -(p+1) to p;
	type T_COEFF_INPUT is array (0 to LFilter-1)  of integer range -(p+1) to p;

	TYPE T_ARRAY_COEFF_IN  IS ARRAY (0 TO in_size-1)  OF IN_TYPE;
	TYPE T_ARRAY_COEFF_OUT IS ARRAY (0 TO out_size-1) OF IN_TYPE;

constant IN_ARRAY: T_IN_ARRAY := (
	p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p
);
constant OUT_ARRAY: T_OUT_ARRAY := (
	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
);

-- tamanho 128 (do uwe meyer baese)
--constant NOISY_ARRAY : T_NOISY_INPUT := (
--	64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111
--);
--constant NOISYF_ARRAY : T_NOISY_INPUT := (
--	10,60,9,-41,10,60,10,-39,11,60,10,-40,10,59,9,-41,10,60,9,-41,10,60,10,-39,11,60,10,-40,10,59,9,-41,10,60,9,-41,10,60,10,-39,11,60,10,-40,10,59,9,-41,10,60,9,-41,10,60,10,-39,11,60,10,-40,10,59,9,-41,10,60,9,-41,10,60,10,-39,11,60,10,-40,10,59,9,-41,10,60,9,-41,10,60,10,-39,11,60,10,-40,10,59,9,-41,10,60,9,-41,10,60,10,-39,11,60,10,-40,10,59,9,-41,10,60,9,-41,10,60,10,-39,11,60,10,-40,10,59,9,-41
--);

component fir_filter_lms_gohorse
port (
	clk       : in  std_logic ;
	reset     : in  std_logic ;
	i_data    : in  IN_TYPE	 ;
	i_ref     : in  IN_TYPE	 ;
	o_coeff0  : out IN_TYPE   ;
	o_coeff1  : out IN_TYPE   ;
	o_coeff2  : out IN_TYPE   ;
	o_coeff3  : out IN_TYPE   ;	
	o_coeff4  : out IN_TYPE   ;
	o_coeff5  : out IN_TYPE   ;
	o_coeff6  : out IN_TYPE   ;
	o_coeff7  : out IN_TYPE   ;
	o_coeff8  : out IN_TYPE   ;
	o_coeff9  : out IN_TYPE   ;	
	o_coeff10 : out IN_TYPE   ;
	o_coeff11 : out IN_TYPE   ;
	o_coeff12 : out IN_TYPE   ;
	o_coeff13 : out IN_TYPE   ;
	o_coeff14 : out IN_TYPE   ;
	o_coeff15 : out IN_TYPE   ;	
	o_coeff16 : out IN_TYPE   ;
	o_coeff17 : out IN_TYPE   ;
	o_coeff18 : out IN_TYPE   ;
	o_coeff19 : out IN_TYPE   ;
	o_coeff20 : out IN_TYPE   ;
	o_coeff21 : out IN_TYPE   ;
	o_coeff22 : out IN_TYPE   ;	
	o_coeff23 : out IN_TYPE   ;
	o_coeff24 : out IN_TYPE   ;
	o_coeff25 : out IN_TYPE   ;
	o_coeff26 : out IN_TYPE   ;
	o_coeff27 : out IN_TYPE   ;
	o_coeff28 : out IN_TYPE   ;	
	o_coeff29 : out IN_TYPE   ;
	o_coeff30 : out IN_TYPE   ;
	o_coeff31 : out IN_TYPE   ;
	o_data    : out OUT_TYPE  ;
	o_error   : out OUT_TYPE  );
end component;

signal clk                     : std_logic:='0';
signal reset                   : std_logic;
signal i_data   : IN_TYPE;
signal i_ref    : IN_TYPE;
signal o_data   : OUT_TYPE;
signal o_coeff0  : IN_TYPE;
signal o_coeff1  : IN_TYPE;
signal o_coeff2  : IN_TYPE;
signal o_coeff3  : IN_TYPE;
signal o_coeff4  : IN_TYPE;
signal o_coeff5  : IN_TYPE;
signal o_coeff6  : IN_TYPE;
signal o_coeff7  : IN_TYPE;
signal o_coeff8  : IN_TYPE;
signal o_coeff9  : IN_TYPE;
signal o_coeff10 : IN_TYPE;
signal o_coeff11 : IN_TYPE;
signal o_coeff12 : IN_TYPE;
signal o_coeff13 : IN_TYPE;
signal o_coeff14 : IN_TYPE;
signal o_coeff15 : IN_TYPE;
signal o_coeff16 : IN_TYPE;
signal o_coeff17 : IN_TYPE;
signal o_coeff18 : IN_TYPE;
signal o_coeff19 : IN_TYPE;
signal o_coeff20 : IN_TYPE;
signal o_coeff21 : IN_TYPE;
signal o_coeff22 : IN_TYPE;
signal o_coeff23 : IN_TYPE;
signal o_coeff24 : IN_TYPE;
signal o_coeff25 : IN_TYPE;
signal o_coeff26 : IN_TYPE;
signal o_coeff27 : IN_TYPE;
signal o_coeff28 : IN_TYPE;
signal o_coeff29 : IN_TYPE;
signal o_coeff30 : IN_TYPE;
signal o_coeff31 : IN_TYPE;
signal o_error   : OUT_TYPE;
signal NOISY	: T_ARRAY_COEFF_IN;
signal NOISYF	: T_ARRAY_COEFF_OUT;

begin

clk   <= not clk after 5 ns;
reset  <= '0', '1' after 132 ns;

u_fir_filter_lms : fir_filter_lms_gohorse
port map(
	clk         => clk       	,
	reset       => reset      	,
	i_data      => i_data 		,
	i_ref       => i_ref 		,
	o_coeff0  => o_coeff0  ,
	o_coeff1  => o_coeff1  ,
	o_coeff2  => o_coeff2  ,
	o_coeff3  => o_coeff3  ,
	o_coeff4  => o_coeff4  ,
	o_coeff5  => o_coeff5  ,
	o_coeff6  => o_coeff6  ,
	o_coeff7  => o_coeff7  ,
	o_coeff8  => o_coeff8  ,
	o_coeff9  => o_coeff9  ,
	o_coeff10 => o_coeff10 ,
	o_coeff11 => o_coeff11 ,
	o_coeff12 => o_coeff12 ,
	o_coeff13 => o_coeff13 ,
	o_coeff14 => o_coeff14 ,
	o_coeff15 => o_coeff15 ,
	o_coeff16 => o_coeff16 ,
	o_coeff17 => o_coeff17 ,
	o_coeff18 => o_coeff18 ,
	o_coeff19 => o_coeff19 ,
	o_coeff20 => o_coeff20 ,
	o_coeff21 => o_coeff21 ,
	o_coeff22 => o_coeff22 ,
	o_coeff23 => o_coeff23 ,
	o_coeff24 => o_coeff24 ,
	o_coeff25 => o_coeff25 ,
	o_coeff26 => o_coeff26 ,
	o_coeff27 => o_coeff27 ,
	o_coeff28 => o_coeff28 ,
	o_coeff29 => o_coeff29 ,
	o_coeff30 => o_coeff30 ,
	o_coeff31 => o_coeff31 ,
	o_data     	=> o_data ,
	o_error     => o_error     );

p_input : process (reset,clk)
	variable count 		: integer := 0;
	variable first_time : std_logic := '0';
begin
	if(reset='0') then
		i_data      <= (others=>'0'); 
		i_ref       <= (others=>'0'); 
		first_time	:='0';
	elsif(falling_edge(clk)) then
		if(first_time='0') then		
			for j in NOISY'range loop
				NOISY(j)  <=  std_logic_vector(to_signed(IN_ARRAY(j),Win));
			end loop;
			for k in NOISYF'range loop
				NOISYF(k)  <=  std_logic_vector(to_signed(OUT_ARRAY(k),Win));
			end loop;	
			first_time := '1';
		else
			
			-- NOISY ANALOG SIGNAL
			if(count < in_size) then
				i_data <= NOISY(count);	
			else
				i_data <= (others=>'0');
			end if;

			if(count < out_size) then
				i_ref <= NOISYF(count);					
				
			else
				i_ref <= (others=>'0');
			end if;
			-----------------------------------

			-- COEFFICIENTS
			--if(count < Lfilter-1) then
			--	o_fir_coeff <= o_coeff(count);
			--else
			--	o_fir_coeff <= (others=>'0');
			--end if;
			---------------------------------------------------
			count := count+1;
		end if;
	end if;		
end process p_input;


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

