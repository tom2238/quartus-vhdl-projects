library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity zamek is
	port
	(
		clk 	: in std_logic;
	    red		: out std_logic := '1';
	    blue	: out std_logic := '1';
	    yellow	: out std_logic := '0';
	    green	: out std_logic := '1';
	    but_blue : in std_logic;
	    keyboard : out std_logic_vector(3 downto 0);
	    -- cteni z rad kb
	    keyboardread0 : in std_logic;
		keyboardread1 : in std_logic;
		keyboardread2 : in std_logic;
		keyboardread3 : in std_logic
	);
end zamek;

architecture Behavioral of zamek is
-- arrays
type heslo_pole is array(3 downto 0) of std_logic_vector(3 downto 0);
type heslo_kontr is array(3 downto 0) of std_logic_vector(3 downto 0);
-- signals
signal registr : std_logic_vector(21 downto 0);
signal regs : std_logic_vector(3 downto 0) := "0001";
-- heslo
signal heslo : heslo_pole := ("0000", "0000", "0000", "0000");
signal heslo_kon : heslo_kontr;
signal hsl_ok : std_logic := '0';
signal but_blue_st : std_logic := '0';
-- vars
shared variable pole0 : integer range 0 to 4 := 0;
shared variable polek : integer range 0 to 4 := 0; 
-- heslo ok


begin

-- registr na sloupci
process (registr(21))
	begin
	if (rising_edge(registr(21)))  then
		regs <= regs(2 downto 0) & regs(3);
	end if;
end process;
-- citac klavesy
process (clk)
begin
	if (rising_edge(clk)) then
		registr <= registr + 1;
	end if;
end process;
-- klavesy
process (keyboardread0, keyboardread1, keyboardread2, keyboardread3, but_blue)
begin
	-- zmena heslo
      if (regs="1000") and (keyboardread0='1') and (pole0 < 4) and (hsl_ok = '1') then          
			heslo(pole0) <= "0110";
			pole0 := pole0 + 1;
			-- 1       
      elsif (regs="0100") and (keyboardread0='1') and (pole0 < 4) and (hsl_ok = '1')then         
			heslo(pole0) <= "0010" ;
			pole0 := pole0 + 1;
			-- 2        
      elsif (regs="0010") and (keyboardread0='1') and (pole0 < 4) and (hsl_ok = '1') then
			heslo(pole0) <= "0011" ; 
			pole0 := pole0 + 1;
			-- 3       
      elsif (regs="0001") and (keyboardread0='1') and (pole0 < 4) and (hsl_ok = '1') then 
			heslo(pole0) <= "1010";
			pole0 := pole0 + 1;  
			-- A    
	-- Rada 1
      elsif (regs="1000") and (keyboardread1='1') and (pole0 < 4) and (hsl_ok = '1') then         
			heslo(pole0) <= "0100" ;
			pole0 := pole0 + 1; 
			-- 4       
      elsif (regs="0100") and (keyboardread1='1') and (pole0 < 4) and (hsl_ok = '1') then         
			heslo(pole0) <= "0101" ;
			pole0 := pole0 + 1;
			-- 5        
      elsif (regs="0010") and (keyboardread1='1') and (pole0 < 4) and (hsl_ok = '1') then
			heslo(pole0) <= "0110" ; 
			pole0 := pole0 + 1;
			-- 6       
      elsif (regs="0001") and (keyboardread1='1') and (pole0 < 4) and (hsl_ok = '1') then 
			heslo(pole0) <= "1011"; 
			pole0 := pole0 + 1;  
			-- B    
	-- Rada 2
      elsif (regs="1000") and (keyboardread2='1') and (pole0 < 4) and (hsl_ok = '1') then         
			heslo(pole0) <= "0111" ; 
			pole0 := pole0 + 1;
			-- 7       
      elsif (regs="0100") and (keyboardread2='1') and (pole0 < 4) and (hsl_ok = '1') then         
			heslo(pole0) <= "1000" ;
			pole0 := pole0 + 1;
			-- 8        
      elsif (regs="0010") and (keyboardread2='1') and (pole0 < 4) and (hsl_ok = '1') then
			heslo(pole0) <= "1001" ; 
			pole0 := pole0 + 1;
			-- 9       
      elsif (regs="0001") and (keyboardread2='1') and (pole0 < 4) and (hsl_ok = '1') then 
			heslo(pole0) <= "1100"; 
			pole0 := pole0 + 1;
			-- C    
	-- Rada 3
      elsif (regs="1000") and (keyboardread3='1') and (pole0 < 4) and (hsl_ok = '1') then         
			heslo(pole0) <= "1110" ;
			pole0 := pole0 + 1;
			-- E       
      elsif (regs="0100") and (keyboardread3='1') and (pole0 < 4) and (hsl_ok = '1') then         
			heslo(pole0) <= "0000" ;
			pole0 := pole0 + 1;
			-- 0        
      elsif (regs="0010") and (keyboardread3='1') and (pole0 < 4) and (hsl_ok = '1') then
			heslo(pole0) <= "1111" ; 
			pole0 := pole0 + 1;
			-- F       
      elsif (regs="0001") and (keyboardread3='1') and (pole0 < 4) and (hsl_ok = '1') then 
			heslo(pole0) <= "1101";  
			pole0 := pole0 + 1;
			-- D    
	  end if;
      
      -- zmena dokoncena
      if (pole0=4) then
		blue <= '0';
		-- wait for 1000 ns;
		polek := 0;
		pole0 := 0;
		hsl_ok <= '0';
		yellow <= transport '0' after 500ms;
		blue <= transport '1' after 500ms;
		green <= transport '1' after 500ms;
		red <= transport '1' after 500ms;
	  end if;
	  
	  -- kontorla hesla
	  if (regs="1000") and (keyboardread0='1') and (polek < 4) and (but_blue_st = '1')then          
			heslo_kon(polek) <= "0110";
			polek := polek + 1;
			-- 1       
      elsif (regs="0100") and (keyboardread0='1') and (polek < 4) and (but_blue_st = '1') then         
			heslo_kon(polek) <= "0010" ;
			polek := polek + 1;
			-- 2        
      elsif (regs="0010") and (keyboardread0='1') and (polek < 4) and (but_blue_st = '1') then
			heslo_kon(polek) <= "0011" ; 
			polek := polek + 1;
			-- 3       
      elsif (regs="0001") and (keyboardread0='1') and (polek < 4) and (but_blue_st = '1') then 
			heslo_kon(polek) <= "1010";
			polek := polek + 1;  
			-- A    
	-- Rada 1
      elsif (regs="1000") and (keyboardread1='1') and (polek < 4) and (but_blue_st = '1') then         
			heslo_kon(polek) <= "0100" ;
			polek := polek + 1; 
			-- 4       
      elsif (regs="0100") and (keyboardread1='1') and (polek < 4) and (but_blue_st = '1') then         
			heslo_kon(polek) <= "0101" ;
			polek := polek + 1;
			-- 5        
      elsif (regs="0010") and (keyboardread1='1') and (polek < 4) and (but_blue_st = '1') then
			heslo_kon(polek) <= "0110" ; 
			polek := polek + 1;
			-- 6       
      elsif (regs="0001") and (keyboardread1='1') and (polek < 4) and (but_blue_st = '1') then 
			heslo_kon(polek) <= "1011"; 
			polek := polek + 1;  
			-- B    
	-- Rada 2
      elsif (regs="1000") and (keyboardread2='1') and (polek < 4) and (but_blue_st = '1') then         
			heslo_kon(polek) <= "0111" ; 
			polek := polek + 1;
			-- 7       
      elsif (regs="0100") and (keyboardread2='1') and (polek < 4) and (but_blue_st = '1') then         
			heslo_kon(polek) <= "1000" ;
			polek := polek + 1;
			-- 8        
      elsif (regs="0010") and (keyboardread2='1') and (polek < 4) and (but_blue_st = '1') then
			heslo_kon(polek) <= "1001" ; 
			polek := polek + 1;
			-- 9       
      elsif (regs="0001") and (keyboardread2='1') and (polek < 4) and (but_blue_st = '1') then 
			heslo_kon(polek) <= "1100"; 
			polek := polek + 1;
			-- C    
	-- Rada 3
      elsif (regs="1000") and (keyboardread3='1') and (polek < 4) and (but_blue_st = '1') then         
			heslo_kon(polek) <= "1110" ;
			polek := polek + 1;
			-- E       
      elsif (regs="0100") and (keyboardread3='1') and (polek < 4) and (but_blue_st = '1') then         
			heslo_kon(polek) <= "0000" ;
			polek := polek + 1;
			-- 0        
      elsif (regs="0010") and (keyboardread3='1') and (polek < 4) and (but_blue_st = '1') then
			heslo_kon(polek) <= "1111" ; 
			polek := polek + 1;
			-- F       
      elsif (regs="0001") and (keyboardread3='1') and (polek < 4) and (but_blue_st = '1') then 
			heslo_kon(polek) <= "1101";  
			polek := polek + 1;
			-- D    
      end if;
      
      -- vstup
	  if (but_blue = '1') then
		but_blue_st <= not (but_blue_st);
		blue <= not (but_blue_st);
		yellow <= but_blue_st;
	  end if;
	  
	  -- hesla ok
	if (polek=4) then
		if (heslo_kon(0)=heslo(0)) and (heslo_kon(1)=heslo(1)) and (heslo_kon(2)=heslo(2)) and (heslo_kon(3)=heslo(3)) then
			hsl_ok <= '1';
			green <= '0';
			red <= '1';
			blue <= '1';
			yellow <= '1';
		else 
			hsl_ok <= '0';
			red <= '0';
			blue <= '0';
			green <= '1';
			-- wait for 1000 ms;
			yellow <= transport '0' after 500ms;
			red <= transport '1' after 500ms;
			blue <= transport '1' after 500ms;
		end if;
	end if;
end process;

keyboard <= regs;

end Behavioral;			