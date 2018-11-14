
library ieee;
use ieee.std_logic_1164.all;

entity dekoder2 is
	port
	(
		A,B,C,D,X,Y,Z			    : in std_logic;
		S0,S1,S2,S3,S4,S5,S6,D0,D1,D2,D3,D4,D5,D6,D7    : out std_logic
	);
end dekoder2;

architecture Behavioral of dekoder2 is
begin
			S0 <= not((B and D) or (C) or ((not B) and (not D)) or (A));
			S1 <= not((C and D) or (not B) or ((not C) and (not D)));
			S2 <= not((D) or (B) or (not C));
			S3 <= not(((not B) and (not D)) or ((not B) and (C)) OR (B and (not C) and (D)) or (C and (not D)) or (A and (not C)));
			S4 <= not(((not B) and (not D)) or ((C) and (not D))); 
			S5 <= not(((not C) and (not D)) or ((B) and (not C)) or ((B) and (not D)) or ((A) and (not C)));
			S6 <= not(((C) and (not D)) or ((not B) and (C)) or ((B) and (not D)) or ((B) and (not C)) or ((A) and (not D)) or ((A) and (not C)));  
			D0 <= not(X) and not(Y) and not(Z);
			D1 <= not(X) and not(Y) and Z;
			D2 <= not(X) and Y and not(Z);
			D3 <= not(X) and Y and Z;
			D4 <= X and not(Y) and not(Z);
			D5 <= X and not(Y) and Z;
			D6 <= X and Y and not(Z);
			D7 <= X and Y and Z;
			
	
	end Behavioral;	