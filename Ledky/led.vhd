library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity led is
	port
	(
		tlacitko_s : in std_logic;
		tlacitko_v : in std_logic;
	    led	: out std_logic
	);
end led;

architecture Behavioral of led is


begin
Process (tlacitko_s, tlacitko_v)
begin
if (tlacitko_s = '0') then
led <= '0';
end if;
if (tlacitko_v = '0') then
led <= '1';
end if;
end process;
end Behavioral; 
	