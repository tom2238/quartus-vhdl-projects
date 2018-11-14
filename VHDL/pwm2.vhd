library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity projekt is
	port
	(
		clk 	: in std_logic;
		led0	: out std_logic;
		led1	: out std_logic;
		led2	: out std_logic;
		led3 	: out std_logic;
		prp0	: in std_logic;
		prp1	: in std_logic;
		prp2	: in std_logic;
		prp3	: in std_logic;
		prp4	: in std_logic;
		prp5	: in std_logic;
		prp6	: in std_logic;
		prp7	: in std_logic
	);
end projekt;

architecture Behavioral of projekt is
-- signals
signal cislo : std_logic_vector(25 downto 0);
signal reg : std_logic_vector(7 downto 0) := "00000001";

signal led : std_logic_vector(3 downto 0) := "0001";
signal prepin : std_logic_vector(7 downto 0);

begin


-- pwm
process (clk)
	begin
	if (rising_edge(clk)) then
		cislo <= cislo + 1;
	end if;
end process;

process (cislo(12))
	begin
	if (rising_edge(cislo(12)))  then
	reg <= reg + 1;
		if (prepin > reg) then
			led <= "0000";
		else
			led <= "1111";
		end if;
	end if;
end process;

led0 <= led(0); 
led1 <= led(1); 
led2 <= led(2); 
led3 <= led(3); 

prepin(0) <= prp0;
prepin(1) <= prp1;
prepin(2) <= prp2;
prepin(3) <= prp3;
prepin(4) <= prp4;
prepin(5) <= prp5;
prepin(6) <= prp6;
prepin(7) <= prp7;
end Behavioral;		
	