library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity stopky is
	port
	(
		clk		: in std_logic;
		segment	: out std_logic_vector(7 downto 0);
		led 	: out std_logic_vector(3 downto 0);
		pause_run	: in std_logic;
		pause_stop	: in std_logic;
		reset	: in std_logic := '0'
	);
end stopky;

architecture Behavioral of stopky is
-- signals
-- negace seg
signal segment2 : std_logic_vector(7 downto 0);
-- registr
signal regs : std_logic_vector(3 downto 0) := "0001"; 
signal registr : std_logic_vector(15 downto 0);
-- 1hz
signal count : integer :=1;
signal clk_sec : std_logic :='0';
-- sekundy cas
signal sec0 : std_logic_vector(3 downto 0);
signal sec1 : std_logic_vector(3 downto 0);
signal sec2 : std_logic_vector(3 downto 0);
signal sec3 : std_logic_vector(3 downto 0);
-- cisla na seg
signal secd0 : std_logic_vector(7 downto 0);
signal secd1 : std_logic_vector(7 downto 0);
signal secd2 : std_logic_vector(7 downto 0);
signal secd3 : std_logic_vector(7 downto 0);
-- pauza
signal pauza_0 : std_logic :='1';


begin

-- registr segmentovek
process (registr(15))
	begin
	if (rising_edge(registr(15)))  then
	regs <= regs(2 downto 0) & regs(3);
	end if;
end process;
-- citac segmentu
process (clk)
	begin
	if (rising_edge(clk))  then
		registr <= registr + 1;
	end if;
end process;
-- generace 1 hz hodin
process(clk)
begin
	if(rising_edge(clk)) then
	count <=count+1;
		if(count = 12000000) then
		clk_sec <= not clk_sec;
		count <=1;
	end if;
end if;
end process;

process(clk_sec, reset, pause_run, pause_stop)
begin
	-- reset
	if (reset = '0') then
		sec0 <= "0000";
		sec1 <= "0000";
		sec2 <= "0000";
		sec3 <= "0000";
		pauza_0 <= '1';
	-- clock
	else
	if (rising_edge(clk_sec)) and (pauza_0 = '0') then
		sec0 <= sec0 + 1;
		-- samotny cas
		if (sec0 = "1001") then
			sec1 <= sec1 + 1;
			sec0 <= "0000";
			if (sec1 = "1001")then
				sec1 <= "0000";
				sec2 <= sec2 + 1;
				if (sec2 = "1001") then
					sec2 <= "0000";
					sec3 <= sec3 + 1;
				end if;
			end if;
		end if;
		if (sec0 = "1001") and (sec1 = "1001") and (sec2 = "1001") and (sec3 = "1001")then
			pauza_0 <= '1';
			sec0 <= "1010";
			sec1 <= "1010";
			sec2 <= "1010";
			sec3 <= "1010";
		end if;	
	end if;
end if;
	-- pauza
	if (pause_run = '0') then
		pauza_0 <= '0';
	end if;
	-- pauza
	if (pause_stop = '0') then
		pauza_0 <= '1';
	end if;
end process;
-- registr na piny
led <= regs;
-- negace
segment <= not (segment2);

with regs select
	segment2 <=  secd0 when "1000",
			secd1 when "0100",
			secd2 when "0010",
			secd3 when "0001",
			"00000000" when others;
-- 4 rad
with sec0 select
	secd0 <=  "11111100" when "0000", -- 0
			"01100000" when "0001", -- 1
			"11011010" when "0010", -- 2
			"11110010" when "0011",  -- 3
			"01100110" when "0100", -- 4
			"10110110" when "0101", -- 5
			"10111110" when "0110", -- 6
			"11100000" when "0111", -- 7
			"11111110" when "1000", -- 8
			"11110110" when "1001", -- 9
			"00000010" when "1010", -- -
			"00000000" when others;
-- 3 rad
with sec1 select
	secd1 <=  "11111100" when "0000", -- 0
			"01100000" when "0001", -- 1
			"11011010" when "0010", -- 2
			"11110010" when "0011",  -- 3
			"01100110" when "0100", -- 4
			"10110110" when "0101", -- 5
			"10111110" when "0110", -- 6
			"11100000" when "0111", -- 7
			"11111110" when "1000", -- 8
			"11110110" when "1001", -- 9
			"00000010" when "1010", -- -
			"00000000" when others;
-- 2 rad
with sec2 select
	secd2 <=  "11111100" when "0000", -- 0
			"01100000" when "0001", -- 1
			"11011010" when "0010", -- 2
			"11110010" when "0011",  -- 3
			"01100110" when "0100", -- 4
			"10110110" when "0101", -- 5
			"10111110" when "0110", -- 6
			"11100000" when "0111", -- 7
			"11111110" when "1000", -- 8
			"11110110" when "1001", -- 9
			"00000010" when "1010", -- -
			"00000000" when others;
-- 1 rad
with sec3 select
	secd3 <=  "11111100" when "0000", -- 0
			"01100000" when "0001", -- 1
			"11011010" when "0010", -- 2
			"11110010" when "0011",  -- 3
			"01100110" when "0100", -- 4
			"10110110" when "0101", -- 5
			"10111110" when "0110", -- 6
			"11100000" when "0111", -- 7
			"11111110" when "1000", -- 8
			"11110110" when "1001", -- 9
			"00000010" when "1010", -- -
			"00000000" when others;
end Behavioral;		
	