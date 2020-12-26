LIBRARY work;
USE work.constants_and_types.ALL;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fir_filter_lms is
port (
	clk      : in  std_logic   ;
	reset    : in  std_logic   ;
	i_data   : in  IN_TYPE	   ;
	i_ref    : in  IN_TYPE	   ;
	o_coeff  : out ARRAY_COEFF ;
	o_data   : out OUT_TYPE    ;
	o_error  : out OUT_TYPE    );
end fir_filter_lms;

architecture fpga of fir_filter_lms is

	SUBTYPE S_IN_TYPE  IS signed(Win-1 downto 0)   ;
	SUBTYPE S_OUT_TYPE IS signed(Wmult-1 downto 0) ;
	
	TYPE ARRAY_DATA    IS ARRAY (0 TO Lfilter-1) OF S_IN_TYPE  ;
	TYPE ARRAY_PRODUCT IS ARRAY (0 TO Lfilter-1) OF S_OUT_TYPE ;	

	SIGNAL  d, emu       :  S_IN_TYPE  ;
	SIGNAL  y, sxty      :  S_OUT_TYPE ;
	SIGNAL  e, sxtd 	 :  S_OUT_TYPE ;

	SIGNAL  x, f       	 :  ARRAY_DATA    ;    
	SIGNAL  p, xemu 	 :  ARRAY_PRODUCT ;

begin
	dsxt: PROCESS (d)  -- make d a Wmult bit number
	BEGIN
		sxtd(Win-1 DOWNTO 0) <= d;
		FOR k IN Wmult-1 DOWNTO Win LOOP
			sxtd(k) <= d(d'high); --d'high = Win
		END LOOP;
	END PROCESS dsxt;

	Store: PROCESS (clk, reset)  -- Store these data or	coefficients in registers
	BEGIN                       
		IF reset = '0' THEN  -- Asynchronous clear
			d <= (others=>'0');
			x <= (others=>(others=>'0'));
			f <= (others=>(others=>'0'));
		ELSIF rising_edge(clk) THEN
			d <= signed(i_ref);
			x <= signed(i_data) & x(0 to Lfilter-2);
			FOR k IN 0 TO Lfilter-1 LOOP
				f(k)  <= f(k) + xemu(k)(Wmult-1 DOWNTO Win);
			END LOOP;
		END IF;
	END PROCESS Store;

	MulGen1: FOR i IN 0 TO Lfilter-1 GENERATE
		p(i) <= f(i) * x(i);
	END GENERATE;

	MulGen2: FOR i IN 0 TO Lfilter-1 GENERATE
		xemu(i) <= emu * x(i);
	END GENERATE;

	Sum: PROCESS (clk, reset)    -- Store these data or
		variable y_temp : S_OUT_TYPE;						 -- coefficients in registers
	BEGIN 
		y_temp := (others=>'0');                       
		IF reset = '0' THEN      -- Asynchronous clear
			y    <=  (OTHERS => '0');
		ELSIF rising_edge(clk) THEN
			FOR i IN 0 TO Lfilter-1 LOOP
				y_temp := y_temp + p(i);				
			END LOOP;
			y <= y_temp;
		END IF;
	END PROCESS Sum;	

	ysxt: PROCESS (y) -- scale y by 128 because x is fraction
	BEGIN
		sxty(Win DOWNTO 0) <= y(Wmult-1 DOWNTO Win-1);
		FOR k IN Wmult-1 DOWNTO Win+1 LOOP
			sxty(k) <= y(y'high); --y'high = Wmult
		END LOOP;
	END PROCESS ysxt;

	e       <= sxtd - sxty            ;
	emu     <= e(Win DOWNTO 1)        ; -- from xemu makes mu=1/4
	o_data  <= std_logic_vector(sxty) ; 
	o_error <= std_logic_vector(e)    ;	

	coeff: PROCESS (clk, reset)
	BEGIN
		IF reset = '0' THEN      -- Asynchronous clear
			o_coeff    <=  (others=>(others=>'0'));
		ELSIF rising_edge(clk) THEN
			FOR k IN 0 TO Lfilter-1 LOOP
				o_coeff(k) <= std_logic_vector(f(k));
			END LOOP;
		END IF;
	END PROCESS coeff;

END fpga;