library ieee;
use ieee.std_logic_1164.all;

entity klopnyobvodRST is
	port
	(
		R,S,T : in std_logic;
		Q,Qneg : out std_logic
		
		
		
	);
end klopnyobvodRST;

architecture Behavioral of klopnyobvodRST is
begin		
process (T,R)
begin
if (T'event and T='0') then
Q <= S;
elsif (R'event and R='0')then 
Qneg <= not (S);
end if;
end process;


		
end Behavioral;	