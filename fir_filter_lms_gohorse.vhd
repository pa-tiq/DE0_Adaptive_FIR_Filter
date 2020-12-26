LIBRARY work;
USE work.constants_and_types.ALL;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fir_filter_lms_gohorse is
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
end fir_filter_lms_gohorse;

architecture fpga of fir_filter_lms_gohorse is

	SUBTYPE S_IN_TYPE  IS signed(Win-1 downto 0)   ;
	SUBTYPE S_OUT_TYPE IS signed(Wmult-1 downto 0) ;
	
	TYPE ARRAY_IN   IS ARRAY (0 TO Lfilter-1) OF S_IN_TYPE  ;
	TYPE ARRAY_OUT  IS ARRAY (0 TO Lfilter-1) OF S_OUT_TYPE ;	

	SIGNAL  d, emu       :  S_IN_TYPE  ;
	SIGNAL  y, sxty      :  S_OUT_TYPE ;
	SIGNAL  e, sxtd 	 :  S_OUT_TYPE ;

	SIGNAL  f,x       	 :  ARRAY_IN  ;   
	SIGNAL  p, xemu 	 :  ARRAY_OUT ;

begin
	dsxt: PROCESS (d)  -- make d a Wmult bit number
	BEGIN
		sxtd(Win-1 DOWNTO 0) <= d;
		FOR k IN Wmult-1 DOWNTO Win LOOP
			sxtd(k) <= d(d'high);
		END LOOP;
	END PROCESS;

	Store: PROCESS (clk, reset)  -- Store these data or	coefficients in registers
	BEGIN                       
		IF reset = '0' THEN  -- Asynchronous clear
			d <= (others=>'0');
			x <= (others=>(others=>'0'));
			f <= (others=>(others=>'0'));
		ELSIF (rising_edge(clk)) THEN
			d <= signed(i_ref);
			x <= signed(i_data) & x(0 to Lfilter-2);
			FOR k IN f'range LOOP
				f(k)  <= f(k) + xemu(k)(Wmult-1 DOWNTO Win);
			END LOOP;
		END IF;
	END PROCESS Store;

	MulGen1: FOR i IN p'range GENERATE
		p(i) <= f(i) * x(i);
	END GENERATE;
	MulGen2: FOR i IN xemu'range GENERATE
		xemu(i) <= emu * x(i);
	END GENERATE;	

	y <= p(0)+p(1)+p(2)+p(3)+p(4)+p(5)+p(6)+p(7)+p(8)+p(9)+p(10)+p(11)+p(12)+p(13)+p(14)+p(15)+p(16)+p(17)+p(18)+p(19)+p(20)+p(21)+p(22)+p(23)+p(24)+p(25)+p(26)+p(27)+p(28)+p(29)+p(30)+p(31);
	e <= sxtd - sxty;

	-- TAXA DE APRENDIZADO -------------------------------
	emu <= e(Win+learning_rate DOWNTO learning_rate+1);    
	------------------------------------------------------

	ysxt: PROCESS (y) -- scale y by 128 because x is fraction
	BEGIN
		sxty(Win DOWNTO 0) <= y(Wmult-1 DOWNTO Win-1);
		FOR k IN Wmult-1 DOWNTO Win+1 LOOP
			sxty(k) <= y(y'high); --y'high = Wmult
		END LOOP;
	END PROCESS;

	o_data <= std_logic_vector(sxty);    -- Monitor some test signals
	o_error <= std_logic_vector(e);

	o_coeff0  <= std_logic_vector(f(0));
	o_coeff1  <= std_logic_vector(f(1));
	o_coeff2  <= std_logic_vector(f(2));
	o_coeff3  <= std_logic_vector(f(3));
	o_coeff4  <= std_logic_vector(f(4));
	o_coeff5  <= std_logic_vector(f(5));
	o_coeff6  <= std_logic_vector(f(6));
	o_coeff7  <= std_logic_vector(f(7));
	o_coeff8  <= std_logic_vector(f(8));
	o_coeff9  <= std_logic_vector(f(9));
	o_coeff10 <= std_logic_vector(f(10));
	o_coeff11 <= std_logic_vector(f(11));
	o_coeff12 <= std_logic_vector(f(12));
	o_coeff13 <= std_logic_vector(f(13));
	o_coeff14 <= std_logic_vector(f(14));
	o_coeff15 <= std_logic_vector(f(15));
	o_coeff16 <= std_logic_vector(f(16));
	o_coeff17 <= std_logic_vector(f(17));
	o_coeff18 <= std_logic_vector(f(18));
	o_coeff19 <= std_logic_vector(f(19));
	o_coeff20 <= std_logic_vector(f(20));
	o_coeff21 <= std_logic_vector(f(21));
	o_coeff22 <= std_logic_vector(f(22));
	o_coeff23 <= std_logic_vector(f(23));
	o_coeff24 <= std_logic_vector(f(24));
	o_coeff25 <= std_logic_vector(f(25));
	o_coeff26 <= std_logic_vector(f(26));
	o_coeff27 <= std_logic_vector(f(27));
	o_coeff28 <= std_logic_vector(f(28));
	o_coeff29 <= std_logic_vector(f(29));
	o_coeff30 <= std_logic_vector(f(30));
	o_coeff31 <= std_logic_vector(f(31)); 

END fpga;