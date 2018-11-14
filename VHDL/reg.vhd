
library IEEE;
use IEEE.STD_LOGIC_1164.ALL, IEEE.NUMERIC_STD.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
 
entity Shift is
  port (
    clk: in std_logic;
    	    led0	: out std_logic;
	led1	: out std_logic;
	led2	: out std_logic;
	led3	: out std_logic;
	led4	: out std_logic;
	led5	: out std_logic;
	led6	: out std_logic;
	led7	: out std_logic
  );
end Shift;
 
architecture behavioral of Shift is
  signal cislo: std_logic_vector(15 downto 0);
	signal temp: std_logic_vector(7 downto 0) := "00000001";
begin
process (cislo(15))
		begin
			if (rising_edge(cislo(15))) then
			temp <= temp(6 downto 0) & temp(7);
			end if;
		end process;
 
led0 <= temp(0);	
led1 <= temp(1);
led2 <= temp(2);	
led3 <= temp(3);
led4 <= temp(4);
led5 <= temp(5);	
led6 <= temp(6);
led7 <= temp(7);	
end behavioral;
	
		
	