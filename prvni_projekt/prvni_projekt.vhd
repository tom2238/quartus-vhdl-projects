
library ieee;
use ieee.std_logic_1164.all;

entity prvni_projekt is
	port
	(
		A,B,C	: in std_logic;
		Y		: out std_logic
	);
end prvni_projekt;

architecture Behavioral of prvni_projekt is
begin
			Y <= (A and C) or (A and B);
			
	end Behavioral;		
	