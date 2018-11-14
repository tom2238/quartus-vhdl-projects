library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity HexNumero is
    Port ( 	
		clk : in  STD_LOGIC;
		prepin : in STD_LOGIC_VECTOR(3 downto 0);
		sloupce : out STD_LOGIC_VECTOR(7 downto 0);	
		radky : out STD_LOGIC_VECTOR(7 downto 0)		
		);
end HexNumero;

architecture Behavioral of HexNumero is

-- registr kruhovy
signal posunreg : std_logic_vector(7 downto 0) := "00000001"; 
signal citacreg : std_logic_vector(15 downto 0);
-- radky LED
signal rad0 : std_logic_vector(7 downto 0);
signal rad1 : std_logic_vector(7 downto 0);
signal rad2 : std_logic_vector(7 downto 0);
signal rad3 : std_logic_vector(7 downto 0);
signal rad4 : std_logic_vector(7 downto 0);
signal rad5 : std_logic_vector(7 downto 0);
signal rad6 : std_logic_vector(7 downto 0);
signal rad7 : std_logic_vector(7 downto 0);
-- negace radku
signal radky2 :  std_logic_vector(7 downto 0);
begin
-- registr 8x8 LED
process (citacreg(15))
	begin
	if (rising_edge(citacreg(15)))  then
		posunreg <= posunreg(6 downto 0) & posunreg(7);
	end if;
end process;

-- citac posuvneho registru
process (clk)
	begin
	if (rising_edge(clk)) then
		citacreg <= citacreg + 1;
	end if;
end process;

process (prepin(0), prepin(1), prepin(2), prepin(3))
	begin
	-- code
	if (prepin="0000") then
		rad0 <= "00111100";
		rad1 <= "01000010";
		rad2 <= "01000010";
		rad3 <= "01000010";
		rad4 <= "01000010";
		rad5 <= "01000010";
		rad6 <= "01000010";
		rad7 <= "00111100";
	elsif (prepin="0001") then
		rad0 <= "00011000";
		rad1 <= "00111000";
		rad2 <= "01011000";
		rad3 <= "10011000";
		rad4 <= "00011000";
		rad5 <= "00011000";
		rad6 <= "00011000";
		rad7 <= "11111111";
	elsif (prepin="0010") then
		rad0 <= "00111100";
		rad1 <= "01100110";
		rad2 <= "11000011";
		rad3 <= "00000110";
		rad4 <= "00001100";
		rad5 <= "00110000";
		rad6 <= "01100000";
		rad7 <= "11111111";	
	elsif (prepin="0011") then
		rad0 <= "00111100";
		rad1 <= "01100110";
		rad2 <= "00000011";
		rad3 <= "00001110";
		rad4 <= "00001110";
		rad5 <= "00000011";
		rad6 <= "01100110";
		rad7 <= "00111100";	
	elsif (prepin="0100") then
		rad0 <= "00011000";
		rad1 <= "00110000";
		rad2 <= "01100000";
		rad3 <= "11000000";
		rad4 <= "11111111";
		rad5 <= "00011000";
		rad6 <= "00011000";
		rad7 <= "00011000";
	elsif (prepin="0101") then
		rad0 <= "11111111";
		rad1 <= "10000000";
		rad2 <= "10000000";
		rad3 <= "11111100";
		rad4 <= "00000110";
		rad5 <= "11000011";
		rad6 <= "01100110";
		rad7 <= "00111100";	
	elsif (prepin="0110") then
		rad0 <= "00111100";
		rad1 <= "01000010";
		rad2 <= "01000000";
		rad3 <= "01000000";
		rad4 <= "00111100";
		rad5 <= "01000010";
		rad6 <= "01000010";
		rad7 <= "00111100";
	elsif (prepin="0111") then
		rad0 <= "11111111";
		rad1 <= "00000010";
		rad2 <= "00000100";
		rad3 <= "00001000";
		rad4 <= "00010000";
		rad5 <= "00010000";
		rad6 <= "00010000";
		rad7 <= "00010000";	
	elsif (prepin="1000") then
		rad0 <= "00111100";
		rad1 <= "01000010";
		rad2 <= "01000010";
		rad3 <= "00111100";
		rad4 <= "01000010";
		rad5 <= "01000010";
		rad6 <= "01000010";
		rad7 <= "00111100";	
	elsif (prepin="1001") then
		rad0 <= "00111100";
		rad1 <= "01000010";
		rad2 <= "01000010";
		rad3 <= "00111100";
		rad4 <= "00000010";
		rad5 <= "00000010";
		rad6 <= "01000010";
		rad7 <= "00111100";	
	elsif (prepin="1010") then
		rad0 <= "00011000";
		rad1 <= "00011000";
		rad2 <= "00100100";
		rad3 <= "00100100";
		rad4 <= "01111110";
		rad5 <= "01000010";
		rad6 <= "10000001";
		rad7 <= "10000001";	
	elsif (prepin="1011") then
		rad0 <= "01111000";
		rad1 <= "01000100";
		rad2 <= "01000100";
		rad3 <= "01111100";
		rad4 <= "01000010";
		rad5 <= "01000010";
		rad6 <= "01000010";
		rad7 <= "01111110";	
	elsif (prepin="1100") then
		rad0 <= "00111100";
		rad1 <= "01000010";
		rad2 <= "01000000";
		rad3 <= "01000000";
		rad4 <= "01000000";
		rad5 <= "01000000";
		rad6 <= "01000010";
		rad7 <= "00111100";	
	elsif (prepin="1101") then
		rad0 <= "01111000";
		rad1 <= "01000100";
		rad2 <= "01000010";
		rad3 <= "01000010";
		rad4 <= "01000010";
		rad5 <= "01000010";
		rad6 <= "01000100";
		rad7 <= "01111000";		
	elsif (prepin="1110") then
		rad0 <= "01111110";
		rad1 <= "01000000";
		rad2 <= "01000000";
		rad3 <= "01111000";
		rad4 <= "01000000";
		rad5 <= "01000000";
		rad6 <= "01000000";
		rad7 <= "01111110";	
	elsif (prepin="1111") then
		rad0 <= "01111110";
		rad1 <= "01000000";
		rad2 <= "01000000";
		rad3 <= "01111000";
		rad4 <= "01000000";
		rad5 <= "01000000";
		rad6 <= "01000000";
		rad7 <= "01000000";																	
	end if;
end process;			
			
-- registr na piny
sloupce <= posunreg;
radky <= not (radky2);
-- multiplexer
with posunreg select
	radky2 <=  rad0 when "10000000",
			rad1 when "01000000",
			rad2 when "00100000",
			rad3 when "00010000",
			rad4 when "00001000",
			rad5 when "00000100",
			rad6 when "00000010",
			rad7 when "00000001",
			"00000000" when others;
			
end Behavioral;