library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity scitac is
	port
	(
		segment	: out std_logic_vector(7 downto 0);
		cislo 	: out std_logic_vector(3 downto 0);
		pricist	: in std_logic;
		reset	: in std_logic;
		clk		: in std_logic
	);
end scitac;

architecture Behavioral of scitac is
-- signals
signal segment2 : std_logic_vector(7 downto 0); 
signal hz : std_logic :='0';
-- 10hz
signal count : integer :=1;
-- bcd
signal misto0 : std_logic_vector(7 downto 0);
signal misto1 : std_logic_vector(7 downto 0);
signal misto2 : std_logic_vector(7 downto 0);
signal misto3 : std_logic_vector(7 downto 0);
-- binary
signal misto_b0 : std_logic_vector(3 downto 0);
signal misto_b1 : std_logic_vector(3 downto 0);
signal misto_b2 : std_logic_vector(3 downto 0);
signal misto_b3 : std_logic_vector(3 downto 0);
-- registr
signal registry : std_logic_vector(3 downto 0) :="0001"; 
signal registr : std_logic_vector(15 downto 0);
begin

-- registr segmentovek
process (registr(15))
	begin
	if (rising_edge(registr(15)))  then
		registry <= registry(2 downto 0) & registry(3);
	end if;
end process;
-- citac segmentu
process (clk)
	begin
	if (rising_edge(clk))  then
		registr <= registr + 1;
	end if;
end process;
-- generace 8 hz hodin
process(clk)
begin
	if(rising_edge(clk)) then
	count <=count+1;
		if(count = 1500000) then
		hz <= not hz;
		count <=1;
	end if;
end if;
end process;
-- zpozdeni
process(pricist, reset, hz)
begin
if (rising_edge(hz)) then
	if (reset = '0') then
		misto_b0 <= "0000";
		misto_b1 <= "0000";
		misto_b2 <= "0000";
		misto_b3 <= "0000";
	end if;	
	if (pricist = '0') then
		if (misto_b0 = "1001") then
			if (misto_b1 = "1001") then
				if (misto_b2 = "1001") then
					if (misto_b3 = "1001") then
						-- nic
					else
						misto_b3 <= misto_b3 + 1;
					end if;
				else
					misto_b2 <= misto_b2 + 1;
				end if;
			else
				misto_b1 <= misto_b1 + 1;
			end if;
		else
			misto_b0 <= misto_b0 + 1;
		end if;
	end if;
end if;	
end process;
-- negace
segment <= not (segment2);
-- registr na piny
cislo <= registry;
-- bcd dec
with misto_b0 select
	misto0 <=  "11111100" when "0000",
			"01100000" when "0001",
			"11011010" when "0010",
			"11110010" when "0011",
			"01100110" when "0100",
			"10110110" when "0101",
			"10111110" when "0110",
			"11100000" when "0111",
			"11111110" when "1000",
			"11110110" when "1001",
			"00000010" when others;

with misto_b1 select
	misto1 <=  "11111100" when "0000",
			"01100000" when "0001",
			"11011010" when "0010",
			"11110010" when "0011",
			"01100110" when "0100",
			"10110110" when "0101",
			"10111110" when "0110",
			"11100000" when "0111",
			"11111110" when "1000",
			"11110110" when "1001",
			"00000010" when others;

with misto_b2 select
	misto2 <=  "11111100" when "0000",
			"01100000" when "0001",
			"11011010" when "0010",
			"11110010" when "0011",
			"01100110" when "0100",
			"10110110" when "0101",
			"10111110" when "0110",
			"11100000" when "0111",
			"11111110" when "1000",
			"11110110" when "1001",
			"00000010" when others;

with misto_b3 select
	misto3 <=  "11111100" when "0000",
			"01100000" when "0001",
			"11011010" when "0010",
			"11110010" when "0011",
			"01100110" when "0100",
			"10110110" when "0101",
			"10111110" when "0110",
			"11100000" when "0111",
			"11111110" when "1000",
			"11110110" when "1001",
			"00000010" when others;

with registry select
	segment2 <=  misto3 when "1000",
			misto2 when "0100",
			misto1 when "0010",
			misto0 when "0001",
			"00000000" when others;			
end Behavioral;	