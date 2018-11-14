library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;


entity zamek is
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
		-- control
		reset		: in std_logic;
		enter		: in std_logic;
		ok			: in std_logic;
		set_col		: in std_logic;
		-- leds
		ledky    	: out std_logic_vector(3 downto 0);
		-- cislo na seg
	    segment	: out std_logic_vector(7 downto 0)
	);
end zamek;

architecture Behavioral of zamek is
-- arrays
type memx is array(3 downto 0) of std_logic_vector(7 downto 0);
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
signal cislo3 : std_logic_vector(7 downto 0);
signal cislo4 : std_logic_vector(7 downto 0);
signal cislo5 : std_logic_vector(7 downto 0);
signal cislo6 : std_logic_vector(7 downto 0);
signal cislo7 : std_logic_vector(7 downto 0);
-- password save -- default 0000
signal pass0 : std_logic_vector(7 downto 0) :="11111100"; 
signal pass1 : std_logic_vector(7 downto 0) :="11111100";
signal pass2 : std_logic_vector(7 downto 0) :="11111100";
signal pass3 : std_logic_vector(7 downto 0) :="11111100";
-- 
signal full	  : std_logic :='0';
-- 10hz
signal hz : std_logic :='0';
signal count : integer :=1;
-- 1200hz
signal hz_k : std_logic :='0';
signal count_k : integer :=1;
-- rezim
shared variable mode : integer := 0;
-- mode 0 - stav IDLE
-- mode 1 - stav ENTR
-- mode 2 - stav CHNG
-- mode 3 - stav ACTV
-- mode 4 - stav EROR
-- mode 5 - stav DETC
-- mode 6 - stav REWR
-- ledka svit
shared variable led_barva : integer range 0 to 3 := 0;
-- 0 zluta
-- 1 zelena
-- 2 cervena
-- 3 modra
-- docasne uloziste default ----
signal mem : memx := ("00000010", "00000010", "00000010", "00000010");
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
	-- cely obsah
    process (hz)
	 variable index : integer := 0;
      begin
      if (rising_edge(hz)) then
	-- to enter
		if (enter = '0') and (mode = 0)then
			mode := 1;
		end if;
	-- input pass ok
		if (ok = '0') and (mode = 1)then
			mode := 5;
		end if;
	-- change password
		if (enter = '0') and (mode = 3) then
			mode := 2;
		end if;
	-- change pass ok
		if (ok = '0') and (mode = 2)then
			if (full = '0') then
				mem(0) <= "00001010";
				mem(1) <= "10110110";
				mem(2) <= "00011110";
				mem(3) <= "00000010";
				mode := 4; -- error
			elsif (full = '1') then
				mode := 6;
			else
				-- nothing
			end if;
		end if;
	-- compare password	
		if (mode = 5) then
			if (cislo4 = pass0)	and (cislo5 = pass1) and (cislo6 = pass2) and (cislo7 = pass3) then
			 -- active
			 mode := 3;
			 mem(0) <= "00001010";
			 mem(1) <= "10110110";
			 mem(2) <= "00011110";
			 mem(3) <= "00000010";
			else
			 -- error
			 mode := 4;
			 mem(0) <= "00001010";
			 mem(1) <= "10110110";
			 mem(2) <= "00011110";
			 mem(3) <= "00000010";
			end if;
		end if;
	-- idle
		if (mode = 0) then
			cislo0 <= "00001100";
			cislo1 <= "01111010";
			cislo2 <= "00011100";
			cislo3 <= "10011110";
			cislo4 <= "00000010";
			cislo5 <= "00000010";
			cislo6 <= "00000010";
			cislo7 <= "00000010";
		end if;
	-- active
		if (mode = 3) then
			cislo0 <= "11101110";
			cislo1 <= "10011100";
			cislo2 <= "00011110";
			cislo3 <= "00111000";
			cislo4 <= "00000010";
			cislo5 <= "00000010";
			cislo6 <= "00000010";
			cislo7 <= "00000010";
			if (reset = '0') then
				mode := 0;
			end if;
			if (set_col = '0') and (keyseg = "0111") then
				led_barva := led_barva + 1;
			end if;
		end if;
	-- input error
		if (mode = 4) then
			cislo0 <= "10011110";
			cislo1 <= "00001010";
			cislo2 <= "00111010";
			cislo3 <= "00001010";
			cislo4 <= "00000010";
			cislo5 <= "00000010";
			cislo6 <= "00000010";
			cislo7 <= "00000010";
			if (reset = '0') then
				mode := 0;
			end if;
		end if;
		-- write password
		if (mode = 6) then
			if (reset = '0') then
				full <= '1';
				mode := 0;
			end if;
			if (full = '1') then
			pass0 <= cislo4;
			pass1 <= cislo5;
			pass2 <= cislo6;
			pass3 <= cislo7;
			mem(0) <= "00001010";
			mem(1) <= "10110110";
			mem(2) <= "00011110";
			mem(3) <= "00000010";
			cislo0 <= "10110110";
			cislo1 <= "01111100";
			cislo2 <= "10011100";
			cislo3 <= "10011100";
			full <= '0';
			else 
			cislo4 <= "00000010";
			cislo5 <= "00000010";
			cislo6 <= "00000010";
			cislo7 <= "00000010";
			end if;
		end if;
	-- enter
	if (mode = 1) then
		if (reset = '0') then
		full <= '0';
		index := 0;
		mem(0) <= "00000010";
		mem(1) <= "00000010";
		mem(2) <= "00000010";
		mem(3) <= "00000010";
		end if;
	  -- klavesnice
      -- Sloup 0          
      if (keyseg = "0111") then  
			if (keyboardread0='0') and (full = '0')then
					mem(index) <= "01100000" ;
					index := index + 1;
					if (index = 4) then
						full <= '1';
						index := 0;
					end if;			
				-- 1  
			elsif (keyboardread1='0') and (full = '0')then							
					mem(index) <= "01100110" ;
					index := index + 1;
				 if (index = 4) then
						full <= '1';
						index := 0;
					end if;			
				-- 4  
			elsif (keyboardread2='0') and (full = '0')then				
					mem(index) <= "11100000" ;
					index := index + 1;
				 if (index = 4) then
						full <= '1';
						index := 0;
					end if;			
				-- 7 
			elsif (keyboardread3='0') and (full = '0')then							
					mem(index) <= "10011110" ;	
					index := index + 1;
				if (index = 4) then
						full <= '1';
						index := 0;
					end if;			
				-- E 
			end if;
	  end if;
	 
	  -- Sloup 1		
	  if (keyseg = "1011") then
			if (keyboardread0='0') and (full = '0')then
				mem(index) <= "11011010";
				index := index + 1;
				if (index = 4) then
						full <= '1';
						index := 0;
					end if;
				-- 2  
			elsif (keyboardread1='0') and (full = '0')then
				mem(index) <= "10110110" ;
				index := index + 1;
				if (index = 4) then
						full <= '1';
						index := 0;
					end if;
				-- 5  
			elsif (keyboardread2='0') and (full = '0')then
				mem(index) <= "11111110" ;
				index := index + 1;
				if (index = 4) then
						full <= '1';
						index := 0;
					end if;
				-- 8 
			elsif (keyboardread3='0') and (full = '0')then
				mem(index) <= "11111100"; 
				index := index + 1;
				if (index = 4) then
						full <= '1';
						index := 0;
					end if;
				-- 0 
			end if;
	  -- sloup 2
		end if;
		
	  if (keyseg = "1101") then
			if (keyboardread0='0') and (full = '0')then
				mem(index) <= "11110010";
				index := index + 1;
				if (index = 4) then
						full <= '1';
						index := 0;
					end if;
				-- 3  
			elsif (keyboardread1='0') and (full = '0')then
				mem(index) <= "10111110" ;
				index := index + 1;
				if (index = 4) then
						full <= '1';
						index := 0;
					end if;
				-- 6  
			elsif (keyboardread2='0') and (full = '0')then
				mem(index) <= "11110110" ;
				index := index + 1;
				if (index = 4) then
						full <= '1';
						index := 0;
					end if;
				-- 9 
			elsif (keyboardread3='0') and (full = '0')then
				mem(index) <= "10001110"; 
				index := index + 1;
				if (index = 4) then
						full <= '1';
						index := 0;
					end if;
				-- F 
			end if;
	  -- sloup 3		
	  end if;
	  if (keyseg = "1110") then
			if (keyboardread0='0') and (full = '0')then
				mem(index) <= "11101110";
				index := index + 1;
				if (index = 4) then
						full <= '1';
						index := 0;
					end if;
				-- A  
			elsif (keyboardread1='0') and (full = '0')then
				mem(index) <= "00111110" ;
				index := index + 1;
				if (index = 4) then
						full <= '1';
						index := 0;
					end if;
				-- B  
			elsif (keyboardread2='0') and (full = '0')then
				mem(index) <= "10011100" ;
				index := index + 1;
				if (index = 4) then
						full <= '1';
						index := 0;
					end if;
				-- C 
			elsif (keyboardread3='0') and (full = '0')then
				mem(index) <= "01111010"; 
				index := index + 1;
				if (index = 4) then
						full <= '1';
						index := 0;
					end if;
				-- D 
			end if;			
      end if;
     -- cisla
    cislo4 <= mem(0);
	cislo5 <= mem(1);
	cislo6 <= mem(2);
	cislo7 <= mem(3);
	-- rezim enter
	cislo0 <= "10011110";
	cislo1 <= "00101010";
	cislo2 <= "00011110";
	cislo3 <= "00001010";
	end if;
	-- change mode
	if (mode = 2) then
		if (reset = '0') then
		full <= '0';
		index := 0;
		mem(0) <= "00000010";
		mem(1) <= "00000010";
		mem(2) <= "00000010";
		mem(3) <= "00000010";
		end if;
	  -- klavesnice
      -- Sloup 0          
      if (keyseg = "0111") then  
			if (keyboardread0='0') and (full = '0')then
					mem(index) <= "01100000" ;
					index := index + 1;
					if (index = 4) then
						full <= '1';
						index := 0;
					end if;			
				-- 1  
			elsif (keyboardread1='0') and (full = '0')then							
					mem(index) <= "01100110" ;
					index := index + 1;
				 if (index = 4) then
						full <= '1';
						index := 0;
					end if;			
				-- 4  
			elsif (keyboardread2='0') and (full = '0')then				
					mem(index) <= "11100000" ;
					index := index + 1;
				 if (index = 4) then
						full <= '1';
						index := 0;
					end if;			
				-- 7 
			elsif (keyboardread3='0') and (full = '0')then							
					mem(index) <= "10011110" ;	
					index := index + 1;
				if (index = 4) then
						full <= '1';
						index := 0;
					end if;			
				-- E 
			end if;
	  end if;
	 
	  -- Sloup 1		
	  if (keyseg = "1011") then
			if (keyboardread0='0') and (full = '0')then
				mem(index) <= "11011010";
				index := index + 1;
				if (index = 4) then
						full <= '1';
						index := 0;
					end if;
				-- 2  
			elsif (keyboardread1='0') and (full = '0')then
				mem(index) <= "10110110" ;
				index := index + 1;
				if (index = 4) then
						full <= '1';
						index := 0;
					end if;
				-- 5  
			elsif (keyboardread2='0') and (full = '0')then
				mem(index) <= "11111110" ;
				index := index + 1;
				if (index = 4) then
						full <= '1';
						index := 0;
					end if;
				-- 8 
			elsif (keyboardread3='0') and (full = '0')then
				mem(index) <= "11111100"; 
				index := index + 1;
				if (index = 4) then
						full <= '1';
						index := 0;
					end if;
				-- 0 
			end if;
	  -- sloup 2
		end if;
		
	  if (keyseg = "1101") then
			if (keyboardread0='0') and (full = '0')then
				mem(index) <= "11110010";
				index := index + 1;
				if (index = 4) then
						full <= '1';
						index := 0;
					end if;
				-- 3  
			elsif (keyboardread1='0') and (full = '0')then
				mem(index) <= "10111110" ;
				index := index + 1;
				if (index = 4) then
						full <= '1';
						index := 0;
					end if;
				-- 6  
			elsif (keyboardread2='0') and (full = '0')then
				mem(index) <= "11110110" ;
				index := index + 1;
				if (index = 4) then
						full <= '1';
						index := 0;
					end if;
				-- 9 
			elsif (keyboardread3='0') and (full = '0')then
				mem(index) <= "10001110"; 
				index := index + 1;
				if (index = 4) then
						full <= '1';
						index := 0;
					end if;
				-- F 
			end if;
	  -- sloup 3		
	  end if;
	  if (keyseg = "1110") then
			if (keyboardread0='0') and (full = '0')then
				mem(index) <= "11101110";
				index := index + 1;
				if (index = 4) then
						full <= '1';
						index := 0;
					end if;
				-- A  
			elsif (keyboardread1='0') and (full = '0')then
				mem(index) <= "00111110" ;
				index := index + 1;
				if (index = 4) then
						full <= '1';
						index := 0;
					end if;
				-- B  
			elsif (keyboardread2='0') and (full = '0')then
				mem(index) <= "10011100" ;
				index := index + 1;
				if (index = 4) then
						full <= '1';
						index := 0;
					end if;
				-- C 
			elsif (keyboardread3='0') and (full = '0')then
				mem(index) <= "01111010"; 
				index := index + 1;
				if (index = 4) then
						full <= '1';
						index := 0;
					end if;
				-- D 
			end if;			
      end if;
     -- cisla
    cislo4 <= mem(0);
	cislo5 <= mem(1);
	cislo6 <= mem(2);
	cislo7 <= mem(3);
	-- rezim change
	cislo0 <= "10011100";
	cislo1 <= "00101110";
	cislo2 <= "00101010";
	cislo3 <= "11110110";
	end if;
end if;	
		
end process; 


-- negace segmenu
segment <= not (segment2);
-- signals to pins			
keyboard <= keyseg;
led <= reg;
-- 	led barva	
	with led_barva select
		ledky <=  "1000" when 0,
				"0100" when 1,
				"0010" when 2,
				"0001" when 3,
				"0000" when others;
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
	