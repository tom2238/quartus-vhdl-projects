library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity debounce is
	port
	(
		pricist	: in std_logic;
		reset	: in std_logic;
		led		: buffer std_logic;
		clk		: in std_logic
	);
end debounce;


ARCHITECTURE debounce OF debounce IS
signal	Q1 : std_logic;  
signal	Q2 : std_logic;  
signal	Q3 : std_logic;  
signal	Q_OUT : std_logic;  
BEGIN

process (clk, reset)
begin
if (rising_edge(clk)) then
	if (reset='0') then
		Q1 <= '1';
		Q2 <= '1';
		Q3 <= '1';
	else
		Q1 <= pricist;
		Q2 <= Q1;
		Q3 <= Q2;
	end if;
	Q_OUT <= Q1 and Q2 and (not Q3);
end if;
end process;

process (Q_OUT)
begin
 led <= Q_OUT;
end process;  

END debounce;
