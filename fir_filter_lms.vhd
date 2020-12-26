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

	SUBTYPE S_IN_TYPE   IS signed(Win-1 downto 0)   ;	
	SUBTYPE S_MULT_TYPE IS signed(Wmult-1 downto 0) ;
	SUBTYPE S_ADD_TYPE  IS signed(Wadd-1 downto 0)  ;
	
	TYPE ARRAY_DATA IS ARRAY (0 TO Lfilter-1) OF S_IN_TYPE   ;
	TYPE ARRAY_MULT IS ARRAY (0 TO Lfilter-1) OF S_MULT_TYPE ;	
	TYPE ARRAY_ADD  IS ARRAY (0 TO Lfilter-1) OF S_ADD_TYPE  ;	

	SIGNAL  d, emu       :  S_IN_TYPE  ;
	SIGNAL  y, sxty      :  S_MULT_TYPE ;
	SIGNAL  e, sxtd 	 :  S_MULT_TYPE ;

	SIGNAL  x, f       	 :  ARRAY_DATA  ;    
	SIGNAL  p, xemu 	 :  ARRAY_MULT  ;
	SIGNAL  add_st0 	 :  ARRAY_ADD   ;


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
			d_temp <= (others=>'0');
			x <= (others=>(others=>'0'));
			f <= (others=>(others=>'0'));
		ELSIF (rising_edge(clk)) THEN
			d <= signed(i_ref);
			--d <= d_temp;
			x <= signed(i_data) & x(0 to Lfilter-2);
			FOR k IN f'range LOOP
				f(k)  <= f(k) + xemu(k)(Wmult-1 DOWNTO Win);
			END LOOP;
		END IF;
	END PROCESS Store;

	--MulGen1: FOR i IN 0 TO Lfilter-1 GENERATE
	--	p(i) <= f(i) * x(i);
	--END GENERATE;
	--MulGen2: FOR i IN 0 TO Lfilter-1 GENERATE
	--	xemu(i) <= emu * x(i);
	--END GENERATE;	

	Mult : process (reset,clk)
	begin
		if(reset='0') then
			p <= (others=>(others=>'0'));
			xemu <= (others=>(others=>'0'));
		elsif(rising_edge(clk)) then
			for k in p'range loop
				p(k) <= x(k) * f(k);
				xemu(k) <= emu * x(k);
			end loop;
		end if;
	end process Mult;

	Sum2 : process (reset,clk)
		variable add_temp  : S_OUT_TYPE;
	begin		
		if(reset='0') then
			y  <= (others=>'0');
			add_temp := (others=>'0');
		elsif(rising_edge(clk)) then
			add_temp := (others=>'0');			
			for k in p'range loop
				add_temp := p(k) + add_temp;
			end loop;	
			y <= add_temp;						
		end if;			
	end process Sum2;

	p_output: PROCESS (clk, reset)
	BEGIN
		IF reset = '0' THEN      -- Asynchronous clear		
			e <= (others => '0');	
			emu <= (others => '0');	
			o_error <= (others => '0');	
			o_data <= (others => '0');	
			o_coeff    <=  (others=>(others=>'0'));
		ELSIF (rising_edge(clk)) THEN
			e <= sxtd - sxty;			
			-- TAXA DE APRENDIZADO -------------------------------
			emu <= e(Win+learning_rate DOWNTO learning_rate+1);    
			------------------------------------------------------
			o_error <= std_logic_vector(e);
			o_data <= std_logic_vector(sxty);    -- Monitor some test signals
			FOR k IN o_coeff'range LOOP
				o_coeff(k) <= std_logic_vector(f(k));
			END LOOP;
		END IF;
	END PROCESS p_output;	


END fpga;