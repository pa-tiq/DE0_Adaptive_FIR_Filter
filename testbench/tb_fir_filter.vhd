library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

PACKAGE constants_and_types IS
	CONSTANT Win     : INTEGER := 10    ; -- Input bit width
	CONSTANT Wmult   : INTEGER := 2*Win ; -- Multiplier bit width 2*Win
	CONSTANT Lfilter : INTEGER := 512   ; -- Filter Length (2)
	CONSTANT learning_rate : INTEGER :=0; -- 1 to 4
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
	constant pt : integer := p-500;
	constant pf : integer := p-320;

	constant in_size   : integer := 2000;
	constant out_size  : integer := 2512;

	type T_IN_ARRAY    is array (0 to in_size-1)  of integer range -(p+1) to p;
	type T_OUT_ARRAY   is array (0 to out_size-1) of integer range -(p+1) to p;
	type T_COEFF_INPUT is array (0 to LFilter-1)  of integer range -(p+1) to p;

	TYPE T_ARRAY_COEFF_IN  IS ARRAY (0 TO in_size-1)  OF IN_TYPE;
	TYPE T_ARRAY_COEFF_OUT IS ARRAY (0 TO out_size-1) OF IN_TYPE;

-- in=548, out=1060, degrau
--constant IN_ARRAY: T_IN_ARRAY := (
--	p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p
--);
--constant OUT_ARRAY: T_OUT_ARRAY := (
--	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
--);

-- in=1000, out=1512, dez pulsos retangulares
--constant IN_ARRAY: T_IN_ARRAY := (
--	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt
--);
--constant OUT_ARRAY: T_OUT_ARRAY := (
--	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
--);

-- in=2000, out=2512, pulsos retangulares
constant IN_ARRAY: T_IN_ARRAY := (
	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt,pt
);
constant OUT_ARRAY: T_OUT_ARRAY := (
	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,pf,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
);

-- tamanho 128 (do uwe meyer baese)
--constant NOISY_ARRAY : T_NOISY_INPUT := (
--	64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111,64,111,-64,-111
--);
--constant NOISYF_ARRAY : T_NOISY_INPUT := (
--	10,60,9,-41,10,60,10,-39,11,60,10,-40,10,59,9,-41,10,60,9,-41,10,60,10,-39,11,60,10,-40,10,59,9,-41,10,60,9,-41,10,60,10,-39,11,60,10,-40,10,59,9,-41,10,60,9,-41,10,60,10,-39,11,60,10,-40,10,59,9,-41,10,60,9,-41,10,60,10,-39,11,60,10,-40,10,59,9,-41,10,60,9,-41,10,60,10,-39,11,60,10,-40,10,59,9,-41,10,60,9,-41,10,60,10,-39,11,60,10,-40,10,59,9,-41,10,60,9,-41,10,60,10,-39,11,60,10,-40,10,59,9,-41
--);

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

signal clk      : std_logic:='0';
signal reset    : std_logic;
signal i_data   : IN_TYPE;
signal i_ref    : IN_TYPE;
signal o_data   : OUT_TYPE;
signal o_coeff  : ARRAY_COEFF;
signal o_error  : OUT_TYPE;
signal NOISY	: T_ARRAY_COEFF_IN;
signal NOISYF	: T_ARRAY_COEFF_OUT;
signal read_out : integer := 0;

begin

clk   <= not clk after 5 ns;
reset  <= '0', '1' after 132 ns;

u_fir_filter_lms : fir_filter_lms
port map(
	clk         => clk       	,
	reset       => reset      	,
	i_data      => i_data 		,
	i_ref       => i_ref 		,
	o_coeff     => o_coeff      ,
	o_data     	=> o_data       ,
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
			if(count < NOISY'high) then
				i_data <= NOISY(count);	
			else
				i_data <= (others=>'0');
			end if;

			if(count < NOISYF'high) then
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
	read_out <= count;	
end process p_input;


p_dump  : process(reset,read_out)
file test_vector      : text open write_mode is "output_file.txt";
variable row          : line;
begin
  
	if(reset='0') then
	------------------------------------
	--elsif(rising_edge(read_out)) then
	elsif(read_out=3000) then
		for h in o_coeff'range loop
			write(row,to_integer(signed(o_coeff(h))), left, 10);			
			writeline(test_vector,row);
		end loop;
	end if;
end process p_dump;

end behave;

