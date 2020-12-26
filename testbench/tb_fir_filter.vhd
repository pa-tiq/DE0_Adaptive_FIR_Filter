library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

PACKAGE constants_and_types IS
	CONSTANT Win     : INTEGER := 8 ; -- Input bit width
	CONSTANT Wmult   : INTEGER := 16 ; -- Multiplier bit width 2*Win
	CONSTANT Lfilter : INTEGER := 4  ; -- Filter Length (2)
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

constant noisy_size : integer := 128;
type T_NOISY_SLV is array(0 to noisy_size-1)   of IN_TYPE ;
type T_NOISY_INPUT is array(0 to noisy_size-1) of integer range (-2**Win) to (2**Win-1);
type T_COEFF_INPUT is array(0 to LFilter-1)    of integer range (-2**Win) to (2**Win-1);

constant NOISY_ARRAY : T_NOISY_INPUT := (
	64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111
);
constant NOISYF_ARRAY : T_NOISY_INPUT := (
	10,60,9,-41,10,60,10,-39,11,60,10,-40,10,59,9,-41,10,60,9,-41,10,60,10,-39,11,60,10,-40,10,59,9,-41,10,60,9,-41,10,60,10,-39,11,60,10,-40,10,59,9,-41,10,60,9,-41,10,60,10,-39,11,60,10,-40,10,59,9,-41,10,60,9,-41,10,60,10,-39,11,60,10,-40,10,59,9,-41,10,60,9,-41,10,60,10,-39,11,60,10,-40,10,59,9,-41,10,60,9,-41,10,60,10,-39,11,60,10,-40,10,59,9,-41,10,60,9,-41,10,60,10,-39,11,60,10,-40,10,59,9,-41
);

component fir_filter_lms
port (
	clk      : in  std_logic   ;
	reset    : in  std_logic   ;
	i_data   : in  IN_TYPE	   ;
	i_ref    : in  IN_TYPE	   ;
	o_coeff  : out ARRAY_COEFF ;
	o_data   : out OUT_TYPE    ;
	o_error  : out OUT_TYPE    );
end component;

signal clk                     : std_logic:='0';
signal reset                   : std_logic;
signal i_data   : IN_TYPE;
signal i_ref    : IN_TYPE;
signal o_data          : OUT_TYPE;
signal o_coeff             : ARRAY_COEFF;
signal o_error                 : OUT_TYPE;
signal NOISY	: T_NOISY_SLV;
signal NOISYF	: T_NOISY_SLV;

begin

clk   <= not clk after 5 ns;
reset  <= '0', '1' after 132 ns;

u_fir_filter_lms : fir_filter_lms
port map(
	clk         => clk       	,
	reset       => reset      	,
	i_data      => i_data 		,
	i_ref       => i_ref 		,
	o_coeff     => o_coeff  ,
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
			for k in NOISYF'range loop
				NOISYF(k)  <=  std_logic_vector(to_signed(NOISYF_ARRAY(k),Win));
			end loop;			
			for j in NOISY'range loop
				NOISY(j)  <=  std_logic_vector(to_signed(NOISY_ARRAY(j),Win));
			end loop;
			first_time := '1';
		else
			
			-- NOISY ANALOG SIGNAL
			if(count < noisy_size) then
				i_data <= NOISY(count);
				i_ref <= NOISYF(count);					
			else
				i_data <= (others=>'0');
				i_ref <= (others=>'0');
			end if;
			-------------------------------------------------

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

