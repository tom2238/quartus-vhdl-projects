library ieee;
use ieee.std_logic_1164.all;

entity scitacka is
	port
	(
		A0,A1,A2,A3,A4,A5,A6,A7,B0,B1,B2,B3,B4,B5,B6,B7			    : in std_logic;
		Cout,Y0,Y1,Y2,Y3,Y4,Y5,Y6,Y7    : out std_logic
	);
end scitacka;

architecture Behavioral of scitacka is
signal Cin0,Cin1,Cin2,Cin3,Cin4,Cin5,Cin6,Cin7:std_logic;
signal Cout0,Cout1,Cout2,Cout3,Cout4,Cout5,Cout6,Cout7:std_logic;

begin
		Cout0 <= Not((A0 and B0 and Cin0) or ((not A0) and	B0 and (not Cin0)) or ((not A0) and (not B0) and Cin0));
		Y0 <= Not((A0 and B0) or (A0 and Cin0) or (B0 and Cin0));
		
		Cout1 <= Not((A1 and B1 and Cin1) or ((not A1) and	B1 and (not Cin1)) or ((not A1) and (not B1) and Cin1));
		Y1 <= Not((A1 and B1) or (A1 and Cin1) or (B1 and Cin1));
		
		Cout2 <= Not((A2 and B2 and Cin2) or ((not A2) and	B2 and (not Cin2)) or ((not A2) and (not B2) and Cin2));
		Y2 <= Not((A2 and B2) or (A2 and Cin2) or (B2 and Cin2));
		
		Cout3 <= Not((A3 and B3 and Cin3) or ((not A3) and	B3 and (not Cin3)) or ((not A3) and (not B3) and Cin3));
		Y3 <= Not((A3 and B3) or (A3 and Cin3) or (B3 and Cin3));
		
		Cout4 <= Not((A4 and B4 and Cin4) or ((not A4) and	B4 and (not Cin4)) or ((not A4) and (not B4) and Cin4));
		Y4 <= Not((A4 and B4) or (A4 and Cin4) or (B4 and Cin4));
		
		Cout5 <= Not((A5 and B5 and Cin5) or ((not A5) and	B5 and (not Cin5)) or ((not A5) and (not B5) and Cin5));
		Y5 <= Not((A5 and B5) or (A5 and Cin5) or (B5 and Cin5));
		
		Cout6 <= Not((A6 and B6 and Cin6) or ((not A6) and	B6 and (not Cin6)) or ((not A6) and (not B6) and Cin6));
		Y6 <= Not((A6 and B6) or (A6 and Cin6) or (B6 and Cin6));
		
		Cout7 <= Not((A7 and B7 and Cin7) or ((not A7) and	B7 and (not Cin7)) or ((not A7) and (not B7) and Cin7));
		Y7 <= Not((A7 and B7) or (A7 and Cin7) or (B7 and Cin7));	
	
	end Behavioral;	