library ieee;
use ieee.std_logic_1164.all;

entity KlopnyobvodD is
	port
	(
		D,T : in std_logic;
		Q,Qneg : out std_logic
		
		
		
	);
end KlopnyobvodD;

architecture Behavioral of KlopnyobvodD is
begin		
process (T)
begin
if (T'event and T='0') then
Q <= D;
Qneg <= not (D);

end if;
end process;


		
end Behavioral;	