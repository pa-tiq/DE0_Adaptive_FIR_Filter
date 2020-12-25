LIBRARY work;
USE work.constants_and_types.ALL;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fir_filter_lms is
port (
	clk      : in  std_logic ;
	reset    : in  std_logic ;
	i_data   : in  IN_TYPE	 ;
	i_ref    : in  IN_TYPE	 ;
	o_coeff  : out ARRAY_COEFF ;
	o_data   : out OUT_TYPE  ;
	o_error  : out OUT_TYPE  );
end fir_filter_lms;

architecture fpga of fir_filter_lms is

	SUBTYPE S_IN_TYPE  IS signed(Win-1 downto 0)   ;
	SUBTYPE S_OUT_TYPE IS signed(Wmult-1 downto 0) ;
	
	TYPE ARRAY_IN   IS ARRAY (0 TO Lfilter-1) OF S_IN_TYPE  ;
	TYPE ARRAY_OUT  IS ARRAY (0 TO Lfilter-1) OF S_OUT_TYPE ;	

	SIGNAL  d, emu       :  S_IN_TYPE  ;
	SIGNAL  y, sxty      :  S_OUT_TYPE ;
	SIGNAL  e, sxtd 	 :  S_OUT_TYPE ;

	SIGNAL  f       	 :  ARRAY_IN  ;   
	SIGNAL  x       	 :  ARRAY_IN  ;    
	SIGNAL  p, xemu 	 :  ARRAY_OUT ;
	SIGNAL  add_st0 	 :  ARRAY_OUT ;

begin
	dsxt: PROCESS (d)  -- make d a Wmult bit number
	BEGIN
		sxtd(Win-1 DOWNTO 0) <= d;
		FOR k IN Wmult-1 DOWNTO Win LOOP
			sxtd(k) <= d(d'high);
		END LOOP;
	END PROCESS;

	--dsxt: PROCESS (clk, reset) -- scale y by 128 because x is fraction
	--BEGIN
	--	IF reset = '0' THEN      -- Asynchronous clear
	--	sxtd    <=  (others=>'0');
	--	ELSIF rising_edge(clk) THEN
	--		sxtd(Win-1 DOWNTO 0) <= d;
	--		FOR k IN Wmult-1 DOWNTO Win LOOP
	--			sxtd(k) <= d(d'high);
	--		END LOOP;
	--	END IF;
	--END PROCESS;

	Store: PROCESS (clk, reset)  -- Store these data or	coefficients in registers
	BEGIN                       
		IF reset = '0' THEN  -- Asynchronous clear
			d <= (others=>'0');
			x <= (others=>(others=>'0'));
			f <= (others=>(others=>'0'));
		ELSIF falling_edge(clk) THEN
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

	--Mult : process (reset,clk)
	--begin
	--	if(reset='0') then
	--		p <= (others=>(others=>'0'));
	--		xemu <= (others=>(others=>'0'));
	--	elsif(rising_edge(clk)) then
	--		for k in 0 to Lfilter-1 loop
	--			p(k) <= x(k) * f(k);
	--			xemu(k) <= emu * x(k);
	--		end loop;
	--	end if;
	--end process Mult;

	Sum2 : process (reset,clk)
		variable add_temp  : signed(Wmult-1 downto 0);
	begin
		add_temp := (others=>'0');
		if(reset='0') then
			y  <= (others=>'0');
			add_temp := (others=>'0');
		elsif(falling_edge(clk) or rising_edge(clk)) then			
			for k in p'range loop
				add_temp := p(k) + add_temp;
			end loop;							
		end if;
		y <= add_temp;	
	end process Sum2;

	--y <= p(0) + p(1) + p(2) + p(3) + p(4) + p(5) + p(6);  -- Compute ADF output
	e <= sxtd - sxty;
	emu <= e(Win DOWNTO 1);    -- from xemu makes mu=1/4
	o_error <= std_logic_vector(e);
	o_data <= std_logic_vector(sxty);

	p_output: PROCESS (clk, reset)
	BEGIN
		IF reset = '0' THEN      -- Asynchronous clear		
			--e <= (others => '0');	
			--emu <= (others => '0');	
			--o_error <= (others => '0');	
			--o_data <= (others => '0');	
			o_coeff    <=  (others=>(others=>'0'));
		ELSIF (falling_edge(clk) or rising_edge(clk)) THEN
			--e <= sxtd - sxty;
			--emu <= e(Win DOWNTO 1);    -- from xemu makes mu=1/4
			--o_error <= std_logic_vector(e);
			--o_data <= std_logic_vector(sxty);    -- Monitor some test signals
			FOR k IN 0 TO Lfilter-1 LOOP
				o_coeff(k) <= std_logic_vector(f(k));
			END LOOP;
		END IF;
	END PROCESS p_output;	

	ysxt: PROCESS (y) -- scale y by 128 because x is fraction
	BEGIN
		sxty(Win DOWNTO 0) <= y(Wmult-1 DOWNTO Win-1);
		FOR k IN Wmult-1 DOWNTO Win+1 LOOP
			sxty(k) <= y(y'high); --y'high = Wmult
		END LOOP;
	END PROCESS;

	--ysxt: PROCESS (clk, reset) -- scale y by 128 because x is fraction
	--BEGIN
	--	IF reset = '0' THEN      -- Asynchronous clear
	--		sxty    <=  (others=>'0');
	--	ELSIF rising_edge(clk) THEN
	--		sxty(Win DOWNTO 0) <= y(Wmult-1 DOWNTO Win-1);
	--		FOR k IN Wmult-1 DOWNTO Win+1 LOOP
	--			sxty(k) <= y(y'high); --y'high = Wmult
	--		END LOOP;
	--	END IF;
	--END PROCESS;


END fpga;