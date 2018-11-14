library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity pos_text is
	port
	(
		clk 	: in std_logic;
	    	rad0 	: out std_logic;
		rad1 	: out std_logic;
		rad2	: out std_logic;
		rad3 	: out std_logic;
		rad4	: out std_logic;
		rad5	: out std_logic;
		rad6	: out std_logic;
		rad7	: out std_logic;
		slpn0 	: out std_logic;
		slpn1 	: out std_logic;
		slpn2	: out std_logic;
		slpn3 	: out std_logic;
		slpn4	: out std_logic;
		slpn5	: out std_logic;
		slpn6	: out std_logic;
		slpn7	: out std_logic
	);
end pos_text;

architecture Behavioral of pos_text is

-- arrays
-- pole pro text delky 160 sloupcu  
--		160 zabyra samotny text
--		poslednich 7 prvku jsou stejne jako prvky s indexem 1 az 7
-- 		index 0 se neopakuje 
--		celkem 167 - 0 to 166   
       
type text_arr is array(166 downto 0) of std_logic_vector(7 downto 0);

-- signals
-- delka registru
signal reg : std_logic_vector(7 downto 0) := "00000001";
-- rychlost registru
signal registr : std_logic_vector(15 downto 0);
-- negace LED diod
signal radky2 : std_logic_vector(7 downto 0);
-- Zapis textu do pole
signal text_array : text_arr := ("00111100", "00111111", "00000011", "00001100", "00000011", "00111111", "00000000", "00111100", "00111111", "00000011", "00001100", "00000011", "00111111", "00000000", "00111100", "00111111", "00000011", "00001100", "00000011", "00111111", "00000000", "00000011", "00000011", "00000011", "00000000", "00100001", "00111111", "00111111", "00001001", "00110000", "00111000", "00000000", "00011110", "00011110", "00100001", "00100001", "00011110", "00011110", "00000000", "00110011", "00100111", "00100101", "00101001", "00111001", "00110011", "00000000", "00111111", "00111111", "00100000", "00100000", "00011111", "00011111", "00000000", "00011110", "00011110", "00100001", "00100001", "00011110", "00011110", "00000000", "00111100", "00111110", "00000011", "00000011", "00111110", "00111100", "00000000", "00010010", "00111011", "00101001", "00100101", "00110111", "00010010", "00000000", "10000001", "11111111", "11111111", "00001000", "00011100", "00110111", "00000000", "00000110", "00101111", "00101001", "00101001", "00111110", "00011111", "00000000", "00010010", "00111011", "00101001", "00100101", "00110111", "00010010", "00000000", "00100000", "00111110", "01111111", "00100001", "00100011", "00100010", "00000000", "00100001", "00111111", "00111111", "00001001", "00110000", "00111000", "00000000", "00011110", "00111111", "00101001", "00101001", "00111011", "00011010", "00000000", "00011110", "00111111", "00100001", "10100001", "11111110", "11111111", "00000000", "00111111", "00111111", "00100000", "00100000", "00111111", "00011111", "00000000", "00100001", "00100001", "11111111", "11111111", "00000001", "00000000", "00000011", "00000011", "00000011", "00000000", "00011110", "00111111", "00100001", "00100001", "00110011", "00010010", "00000000", "00110011", "00100111", "00100101", "00101001", "00111001", "00110011", "00000000", "10000001", "11000011", "11111111", "11000011", "10000001", "00000000", "00111111", "00000011", "00001100", "00000011", "00111111", "00000000", "00111100");
-- pomocne signaly pole
signal slp0 : std_logic_vector(7 downto 0);
signal slp1 : std_logic_vector(7 downto 0);
signal slp2 : std_logic_vector(7 downto 0);
signal slp3 : std_logic_vector(7 downto 0);
signal slp4 : std_logic_vector(7 downto 0);
signal slp5 : std_logic_vector(7 downto 0);
signal slp6 : std_logic_vector(7 downto 0);
signal slp7 : std_logic_vector(7 downto 0);
-- zpozdeni
signal zpozd_cas : std_logic_vector(21 downto 0);
signal clk_zpozd : std_logic;
--
signal sloupce	: std_logic_vector(7 downto 0);
signal radky	: std_logic_vector(7 downto 0);

begin

-- registr
process (registr(15))
	begin
	if (rising_edge(registr(15)))  then
	reg <= reg(6 downto 0) & reg(7);
	end if;
end process;		

-- citac zpozdeni
process (clk)
	begin
	if (rising_edge(clk)) then
	zpozd_cas <= zpozd_cas + 1;
	end if;
end process;

-- posun
process (clk_zpozd)
	-- promene pro zobrazeni prvku pole
	variable sl_cas0 : integer range 0 to 160 := 0;
	variable sl_cas1 : integer range 1 to 161 := 1;
	variable sl_cas2 : integer range 2 to 162 := 2;
	variable sl_cas3 : integer range 3 to 163 := 3;
	variable sl_cas4 : integer range 4 to 164 := 4;
	variable sl_cas5 : integer range 5 to 165 := 5;
	variable sl_cas6 : integer range 6 to 166 := 6;
	variable sl_cas7 : integer range 7 to 167 := 7;
	begin
	if (rising_edge(clk_zpozd)) then
		-- reset pri preteceni velikosti pole
		if (sl_cas0 = 160) then
			sl_cas0 := 0;
		end if;
		if (sl_cas1 = 161) then 
			sl_cas1 := 1;
		end if;
		if (sl_cas2 = 162) then 
			sl_cas2 := 2;
		end if;
		if (sl_cas3 = 163) then 
			sl_cas3 := 3;
		end if;
		if (sl_cas4 = 164) then 
			sl_cas4 := 4;
		end if;
		if (sl_cas5 = 165) then 
			sl_cas5 := 5;
		end if;
		if (sl_cas6 = 166) then 
			sl_cas6 := 6;
		end if;
		if (sl_cas7 = 167) then 
			sl_cas7 := 7;
		end if;
		-- prepis pole na signal
		slp0 <= text_array(sl_cas0);
		slp1 <= text_array(sl_cas1);
		slp2 <= text_array(sl_cas2);
		slp3 <= text_array(sl_cas3);
		slp4 <= text_array(sl_cas4);
		slp5 <= text_array(sl_cas5);
		slp6 <= text_array(sl_cas6);
		slp7 <= text_array(sl_cas7);
		-- posunuti indexu pole o 1		
		sl_cas0 := sl_cas0 + 1;		
		sl_cas1 := sl_cas1 + 1;
		sl_cas2 := sl_cas2 + 1;
		sl_cas3 := sl_cas3 + 1;
		sl_cas4 := sl_cas4 + 1;
		sl_cas5 := sl_cas5 + 1;
		sl_cas6 := sl_cas6 + 1;
		sl_cas7 := sl_cas7 + 1;
	end if;
end process;

-- vytvoreni zpozdeneho krystalu
clk_zpozd <= zpozd_cas(21);
-- registr na sloupce
sloupce <= reg;
-- negace LED vystupu
radky <= not (radky2);
-- prepis signalu na vystup radku
with reg select
	radky2 <=  slp0 when "10000000",
			slp1 when "01000000",
			slp2 when "00100000",
			slp3 when "00010000",
			slp4 when "00001000",
			slp5 when "00000100",
			slp6 when "00000010",
			slp7 when "00000001",
			"00000000" when others;

rad0 <= radky(0);
rad1 <= radky(1);
rad2 <= radky(2);
rad3 <= radky(3);
rad4 <= radky(4);
rad5 <= radky(5);
rad6 <= radky(6);
rad7 <= radky(7);

slpn0 <= sloupce(0);
slpn1 <= sloupce(1);
slpn2 <= sloupce(2);
slpn3 <= sloupce(3);
slpn4 <= sloupce(4);
slpn5 <= sloupce(5);
slpn6 <= sloupce(6);
slpn7 <= sloupce(7);

end Behavioral;		
	