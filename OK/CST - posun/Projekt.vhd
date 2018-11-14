library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

-- Internet sources
-- http://anakkomput3rr.blogspot.cz/2010/12/tugas-fpga.html
-- http://susta.cz/fel/sps/kurz/SimulaceVQuartusV13.pdf
-- http://www.ics.uci.edu/~jmoorkan/vhdlref/
-- http://www.unicell.cz/index.php?option=com_content&view=article&id=53:popis-jazyka-vhdl&catid=34:ketegorie-quartus
-- http://www.urel.feec.vutbr.cz/~kolouch/pld/2_cviceni/kapitola03_04.html
-- http://www.prochazka.profitux.cz/index.php?a=knihovnicka/vhdl

-- warnings
-- https://www.altera.com/support/support-resources/knowledge-base/solutions/spr356312.html
-- http://quartushelp.altera.com/13.0/mergedProjects/msgs/msgs/wvrfx_vhdl_should_be_on_the_processes_sensitivity_list.htm
-- https://www.altera.com/support/support-resources/knowledge-base/solutions/rd11012012_411.html

entity Projekt is
	port
(
		-- crystal
		clk : in std_logic;
		-- umisteni led
	    led	: out std_logic_vector(7 downto 0);
	    -- sloupce na kb
	    keyboard : out std_logic_vector(3 downto 0);
	    -- cteni z rad kb
	    keyboardread0 : in std_logic;
		keyboardread1 : in std_logic;
		keyboardread2 : in std_logic;
		keyboardread3 : in std_logic;
		-- cislo na seg
	    segment	: out std_logic_vector(7 downto 0)
	);
end Projekt;

architecture Behavioral of Projekt is
-- arrays
type memx is array(7 downto 0) of std_logic_vector(7 downto 0);
-- signals
-- registr pohyb 1
signal keyseg : std_logic_vector(3 downto 0) := "1110";
-- negace cisel segmentu
signal segment2 : std_logic_vector(7 downto 0);
-- registr pohybu umisteni na seg
signal reg : std_logic_vector(7 downto 0) := "00000001";
-- frekvence pohybu tlacitek
signal regosm : std_logic_vector(15 downto 0);
-- obsah jednotlivych segmentu
signal cislo0 : std_logic_vector(7 downto 0);
signal cislo1 : std_logic_vector(7 downto 0);
signal cislo2 : std_logic_vector(7 downto 0);
signal cislo3 : std_logic_vector(7 downto 0) ;
signal cislo4 : std_logic_vector(7 downto 0) ;
signal cislo5 : std_logic_vector(7 downto 0);
signal cislo6 : std_logic_vector(7 downto 0) ;
signal cislo7 : std_logic_vector(7 downto 0);


-- 10hz
signal hz : std_logic :='0';
signal count : integer :=1;
-- 500hz
signal hz_k : std_logic :='0';
signal count_k : integer :=1;

signal mem : memx := ("00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000");
begin

		-- registry
		-- registr beh nuly na sloupcich
		process (hz_k)
		begin
			if (rising_edge(hz_k)) then
				keyseg <= keyseg(2 downto 0) & keyseg(3);
			end if;
		end process;
		-- registr osmi segmentovek
		process (regosm(15))
		begin
			if (rising_edge(regosm(15))) then
				reg <= reg(6 downto 0) & reg(7);
			end if;
		end process;
		-- citac segmentovek
		process (clk)
		begin
			if (rising_edge(clk)) then
				regosm <= regosm + 1;
			end if;
		end process;
		-- generace 50 hz hodin zakmit
		process(clk)
		begin
			if(rising_edge(clk)) then
				count <=count+1;
				if(count = 240000) then
					hz <= not hz;
					count <=1;
				end if;
			end if;
		end process;
		-- generace 1250 hz hodin klaves
		process(clk)
		begin
			if(rising_edge(clk)) then
				count_k <=count_k+1;
				if(count_k = 9600) then
					hz_k <= not hz_k;
					count_k <=1;
				end if;
			end if;
		end process;
 		-- co za tlacitko 
		-- zatim testovani
    process (keyboardread0, keyboardread1, keyboardread2, keyboardread3, hz)
	 variable index : integer range 0 to 8 := 1;
      begin
      if (rising_edge(hz)) then
      -- Sloup 0          
      if (keyseg = "0111") then  
			if (keyboardread0='0') then
				mem(index) <= "01100000" ;

		cislo7 <=  mem(index) ;
		cislo6 <=  mem(index+1) ;
		cislo5 <=  mem(index+2) ;
		cislo4 <=  mem(index+3) ;
		cislo3 <=  mem(index+4) ;
		cislo2 <=  mem(index+5) ;
		cislo1 <=  mem(index+6) ;
		cislo0 <=  mem(index+7) ;
		index := index + 1;
				-- 1  
			elsif (keyboardread1='0') then
				mem(index) <= "01100110" ;
				
				cislo7 <=  mem(index) ;
		cislo6 <=  mem(index+1) ;
		cislo5 <=  mem(index+2) ;
		cislo4 <=  mem(index+3) ;
		cislo3 <=  mem(index+4) ;
		cislo2 <=  mem(index+5) ;
		cislo1 <=  mem(index+6) ;
		cislo0 <=  mem(index+7) ;
		index := index + 1;
				-- 4  
			elsif (keyboardread2='0') then
				mem(index) <= "11100000" ;
				
				cislo7 <=  mem(index) ;
		cislo6 <=  mem(index+1) ;
		cislo5 <=  mem(index+2) ;
		cislo4 <=  mem(index+3) ;
		cislo3 <=  mem(index+4) ;
		cislo2 <=  mem(index+5) ;
		cislo1 <=  mem(index+6) ;
		cislo0 <=  mem(index+7) ;
		index := index + 1;
				-- 7 
			elsif (keyboardread3='0') then
				mem(index) <= "10011110" ;
			
				cislo7 <=  mem(index) ;
		cislo6 <=  mem(index+1) ;
		cislo5 <=  mem(index+2) ;
		cislo4 <=  mem(index+3) ;
		cislo3 <=  mem(index+4) ;
		cislo2 <=  mem(index+5) ;
		cislo1 <=  mem(index+6) ;
		cislo0 <=  mem(index+7) ;
		index := index + 1;
				-- E 
			end if;
	  end if;
	 
	  -- Sloup 1		
	  if (keyseg = "1011") then
			if (keyboardread0='0') then
				mem(index) <= "11011010";
				cislo7 <=  mem(index) ;
		cislo6 <=  mem(index+1) ;
		cislo5 <=  mem(index+2) ;
		cislo4 <=  mem(index+3) ;
		cislo3 <=  mem(index+4) ;
		cislo2 <=  mem(index+5) ;
		cislo1 <=  mem(index+6) ;
		cislo0 <=  mem(index+7) ;
		index := index + 1;
				-- 2  
			elsif (keyboardread1='0') then
				mem(index) <= "10110110" ;
				cislo7 <=  mem(index) ;
		cislo6 <=  mem(index+1) ;
		cislo5 <=  mem(index+2) ;
		cislo4 <=  mem(index+3) ;
		cislo3 <=  mem(index+4) ;
		cislo2 <=  mem(index+5) ;
		cislo1 <=  mem(index+6) ;
		cislo0 <=  mem(index+7) ;
		index := index + 1;
				-- 5  
			elsif (keyboardread2='0') then
				mem(index) <= "11111110" ;
				cislo7 <=  mem(index) ;
		cislo6 <=  mem(index+1) ;
		cislo5 <=  mem(index+2) ;
		cislo4 <=  mem(index+3) ;
		cislo3 <=  mem(index+4) ;
		cislo2 <=  mem(index+5) ;
		cislo1 <=  mem(index+6) ;
		cislo0 <=  mem(index+7) ;
		index := index + 1;
				-- 8 
			elsif (keyboardread3='0') then
				mem(index) <= "11111100"; 
				cislo7 <=  mem(index) ;
		cislo6 <=  mem(index+1) ;
		cislo5 <=  mem(index+2) ;
		cislo4 <=  mem(index+3) ;
		cislo3 <=  mem(index+4) ;
		cislo2 <=  mem(index+5) ;
		cislo1 <=  mem(index+6) ;
		cislo0 <=  mem(index+7) ;
		index := index + 1;
				-- 0 
			end if;
	  -- sloup 2
		end if;
		
	  if (keyseg = "1101") then
			if (keyboardread0='0') then
				mem(index) <= "11110010";
				cislo7 <=  mem(index) ;
		cislo6 <=  mem(index+1) ;
		cislo5 <=  mem(index+2) ;
		cislo4 <=  mem(index+3) ;
		cislo3 <=  mem(index+4) ;
		cislo2 <=  mem(index+5) ;
		cislo1 <=  mem(index+6) ;
		cislo0 <=  mem(index+7) ;
		index := index + 1;
				-- 3  
			elsif (keyboardread1='0') then
				mem(index) <= "10111110" ;
				cislo7 <=  mem(index) ;
		cislo6 <=  mem(index+1) ;
		cislo5 <=  mem(index+2) ;
		cislo4 <=  mem(index+3) ;
		cislo3 <=  mem(index+4) ;
		cislo2 <=  mem(index+5) ;
		cislo1 <=  mem(index+6) ;
		cislo0 <=  mem(index+7) ;
		index := index + 1;
				-- 6  
			elsif (keyboardread2='0') then
				mem(index) <= "11110110" ;
				cislo7 <=  mem(index) ;
		cislo6 <=  mem(index+1) ;
		cislo5 <=  mem(index+2) ;
		cislo4 <=  mem(index+3) ;
		cislo3 <=  mem(index+4) ;
		cislo2 <=  mem(index+5) ;
		cislo1 <=  mem(index+6) ;
		cislo0 <=  mem(index+7) ;
		index := index + 1;
				-- 9 
			elsif (keyboardread3='0') then
				mem(index) <= "10001110"; 
				cislo7 <=  mem(index) ;
		cislo6 <=  mem(index+1) ;
		cislo5 <=  mem(index+2) ;
		cislo4 <=  mem(index+3) ;
		cislo3 <=  mem(index+4) ;
		cislo2 <=  mem(index+5) ;
		cislo1 <=  mem(index+6) ;
		cislo0 <=  mem(index+7) ;
		index := index + 1;
				-- F 
			end if;
	  -- sloup 3		
	  end if;
	  if (keyseg = "1110") then
			if (keyboardread0='0') then
				mem(index) <= "11101110";
				cislo7 <=  mem(index) ;
		cislo6 <=  mem(index+1) ;
		cislo5 <=  mem(index+2) ;
		cislo4 <=  mem(index+3) ;
		cislo3 <=  mem(index+4) ;
		cislo2 <=  mem(index+5) ;
		cislo1 <=  mem(index+6) ;
		cislo0 <=  mem(index+7) ;
		index := index + 1;
				-- A  
			elsif (keyboardread1='0') then
				mem(index) <= "00111110" ;
				cislo7 <=  mem(index) ;
		cislo6 <=  mem(index+1) ;
		cislo5 <=  mem(index+2) ;
		cislo4 <=  mem(index+3) ;
		cislo3 <=  mem(index+4) ;
		cislo2 <=  mem(index+5) ;
		cislo1 <=  mem(index+6) ;
		cislo0 <=  mem(index+7) ;
		index := index + 1;
				-- B  
			elsif (keyboardread2='0') then
				mem(index) <= "10011100" ;
				cislo7 <=  mem(index) ;
		cislo6 <=  mem(index+1) ;
		cislo5 <=  mem(index+2) ;
		cislo4 <=  mem(index+3) ;
		cislo3 <=  mem(index+4) ;
		cislo2 <=  mem(index+5) ;
		cislo1 <=  mem(index+6) ;
		cislo0 <=  mem(index+7) ;
		index := index + 1;
				-- C 
			elsif (keyboardread3='0') then
				mem(index) <= "01111010"; 
				cislo7 <=  mem(index) ;
		cislo6 <=  mem(index+1) ;
		cislo5 <=  mem(index+2) ;
		cislo4 <=  mem(index+3) ;
		cislo3 <=  mem(index+4) ;
		cislo2 <=  mem(index+5) ;
		cislo1 <=  mem(index+6) ;
		cislo0 <=  mem(index+7) ;
		index := index + 1;
				-- D 
			end if;			
      end if;
		
	end if;	
		
    end process; 
  
-- negace segmenu
segment <= not (segment2);
-- signals to pins			
keyboard <= keyseg;
led <= reg;
-- cisla na segmentech			
	with reg select
		segment2 <=  cislo0 when "10000000",
				cislo1 when "01000000",
				cislo2 when "00100000",
				cislo3 when "00010000",
				cislo4 when "00001000",
				cislo5 when "00000100",
				cislo6 when "00000010",
				cislo7 when "00000001",
				"00000000" when others;
end Behavioral; 
	