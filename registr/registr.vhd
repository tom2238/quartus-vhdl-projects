library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity registr is
	port
	(
		clk : in std_logic;
	    led	: out std_logic_vector(7 downto 0):= "11110000";
	    segment	: out std_logic_vector(7 downto 0)
	);
end registr;

architecture Behavioral of registr is
-- signals
signal cislo : std_logic_vector(15 downto 0);
signal reg : std_logic_vector(7 downto 0) := "00000001";
signal segment2 : std_logic_vector(7 downto 0);
begin
	process (clk)
		begin
			if (rising_edge(clk)) then
			cislo <= cislo + 1;
			end if;
		end process;
		
		process (cislo(15))
		begin
			if (rising_edge(cislo(15))) then
			reg <= reg(6 downto 0) & reg(7);
			end if;
		end process;
segment <= not (segment2);			
led <= reg;				
with reg select
	segment2 <=  "11111100" when "10000000",
			"01100000" when "01000000",
			"11011010" when "00100000",
			"11110010" when "00010000",
			"01100110" when "00001000",
			"10110110" when "00000100",
			"10111110" when "00000010",
			"11100000" when "00000001",
			"00000000" when others;
end Behavioral;		
	