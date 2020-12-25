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
	o_coeff  : out ARRAY_COEFF(0 to Lfilter-1);
	o_data   : out OUT_TYPE    ;
	o_error  : out OUT_TYPE    ;
	read_out : out integer     );
end fir_filter_lms;

architecture fpga of fir_filter_lms is

	SUBTYPE DATA_TYPE IS signed(Win-1 downto 0);
	SUBTYPE MULT_TYPE IS signed(Wmult-1 downto 0);
	SUBTYPE ADD_TYPE IS signed(Wadd-1 downto 0);
	
	TYPE ARRAY_DATA IS ARRAY (0 TO Lfilter-1) OF DATA_TYPE;
	TYPE ARRAY_MULT IS ARRAY (0 TO Lfilter-1) OF MULT_TYPE;	
	TYPE ARRAY_ADD  IS ARRAY (0 TO (Lfilter/2)-1) OF ADD_TYPE;	

	SIGNAL  emu          :  DATA_TYPE;
	SIGNAL  y, sxty      :  MULT_TYPE;
	SIGNAL  e, sxtd 	 :  MULT_TYPE;

	SIGNAL  f       	 :  ARRAY_DATA;   
	SIGNAL  x       	 :  ARRAY_DATA;    
	SIGNAL  d       	 :  ARRAY_DATA;     
	SIGNAL  p, xemu 	 :  ARRAY_MULT;
	SIGNAL  add1 	     :  ARRAY_ADD;
	SIGNAL  add2 	     :  signed(Wadd downto 0);

begin

dsxt: PROCESS (d)  -- make d a Wmult bit number
BEGIN
	sxtd(Win-1 DOWNTO 0) <= d(Lfilter-1);
	FOR k IN Wmult-1 DOWNTO Win LOOP
		sxtd(k) <= d(Lfilter-1)(Win-1);
	END LOOP;
END PROCESS;

Store: PROCESS (clk, reset)  -- Store these data or
BEGIN                        -- coefficients in registers
	IF reset = '0' THEN  -- Asynchronous clear
		d <= (others=>(others=>'0'));
		x <= (others=>(others=>'0'));
		f <= (others=>(others=>'0'));
	ELSIF rising_edge(clk) THEN
		x <= signed(i_data)&x(0 to x'length-2);
		d <= signed(i_ref)&d(0 to d'length-2);
		FOR k IN 0 TO Lfilter-1 LOOP
			f(k)  <= f(k) + xemu(k)(Wmult-1 DOWNTO Win);
		END LOOP;
		--f(0) <= f(0) + xemu(0)(Wmult-1 DOWNTO Win); -- implicit
		--f(1) <= f(1) + xemu(1)(Wmult-1 DOWNTO Win); -- divide by 2
	END IF;
END PROCESS Store;

Mul: PROCESS (clk, reset)
BEGIN 
	IF reset = '0' THEN      -- Asynchronous clear
		p    <=  (others=>(others=>'0'));
		xemu <=  (others=>(others=>'0'));
		e    <=  (OTHERS => '0');
	ELSIF rising_edge(clk) THEN
		FOR i IN 0 TO Lfilter-1 LOOP
			p(i) <= f(i) * x(i);
			xemu(i) <= emu * x(i);
		END LOOP;
	END IF;
END PROCESS Mul;


Sum1: PROCESS (clk, reset)
BEGIN
	IF reset = '0' THEN      -- Asynchronous clear
		add1 <= (others=>(others=>'0'));
	ELSIF rising_edge(clk) THEN
		FOR k IN 0 TO (LFilter/2)-1  LOOP
			add1(k) <= resize(p(2*k),Wadd)  + resize(p(2*k+1),Wadd);			
		END LOOP;
	END IF;
END PROCESS Sum1;


Sum2: PROCESS (clk, reset)
	variable add_temp : signed(Wadd downto 0);
BEGIN
	add_temp := (others=>'0');                       
	IF reset = '0' THEN      -- Asynchronous clear
		y <= (others=>'0');
	ELSIF rising_edge(clk) THEN
		FOR i IN 0 TO (Lfilter/2)-1  LOOP
			add_temp := resize(add1(i),Wadd+1) + add_temp;				
		END LOOP;
		y <= add_temp(Wadd downto (Wadd-(y'length-1)));
		e <= sxtd - sxty;  -- e*mu divide by 2 and 2
	END IF;
END PROCESS Sum2;

emu <= e(Win DOWNTO 1);    -- from xemu makes mu=1/4

ysxt: PROCESS (y) -- scale y by 128 because x is fraction
BEGIN
	sxty(Win DOWNTO 0) <= y(Wmult-1 DOWNTO Win-1);
	FOR k IN Wmult-1 DOWNTO Win+1 LOOP
		sxty(k) <= y(y'high);
	END LOOP;
END PROCESS;

p_output : process (reset,clk)
	variable counter : integer := 0;
begin		
if(reset='0') then
	o_data  <= (others=>'0');
	o_error  <= (others=>'0');
	o_coeff  <= (others=>(others=>'0'));
	counter := 0;
elsif(rising_edge(clk)) then
	o_data <= std_logic_vector(sxty);
	o_error <= std_logic_vector(e);
	FOR i IN 0 TO Lfilter-1 LOOP
		o_coeff(i) <= std_logic_vector(f(i));
	END LOOP;
	if(counter<1060) then
		counter := counter+1;
	end if;
	read_out <= counter;			
end if;		
end process p_output;

END fpga;