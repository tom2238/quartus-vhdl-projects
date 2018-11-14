library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
 
entity Nahoda is 
port (
	clk: in std_logic;
	segment	: out std_logic_vector(7 downto 0);
	led: out std_logic_vector(3 downto 0)
);
end Nahoda;
 
architecture Behavioral of Nahoda is 
-- data RND
signal d0: std_logic_vector(10 downto 1) := (others=>'1');
signal d1: std_logic_vector(10 downto 1) := (others=>'1');
signal d2: std_logic_vector(10 downto 1) := (others=>'1');
signal d3: std_logic_vector(10 downto 1) := (others=>'1');
-- cisla RND
signal cislo0: std_logic_vector(3 downto 0);
signal cislo1: std_logic_vector(3 downto 0);
signal cislo2: std_logic_vector(3 downto 0);
signal cislo3: std_logic_vector(3 downto 0);
-- signal neg
signal segment2 : std_logic_vector(7 downto 0);
-- 1hz
signal count : integer :=1;
signal clk_hz : std_logic :='0';
-- registr
signal regs : std_logic_vector(3 downto 0) := "0001"; 
signal registr : std_logic_vector(15 downto 0);
-- cisla na seg
signal secd0 : std_logic_vector(7 downto 0);
signal secd1 : std_logic_vector(7 downto 0);
signal secd2 : std_logic_vector(7 downto 0);
signal secd3 : std_logic_vector(7 downto 0);
begin
	-- 1.GEN						
	process(clk_hz) is
	begin
		if rising_edge(clk_hz) then
			d0(1) <= d0(10);
			d0(2) <= d0(1);
			d0(3) <= d0(2) xor d0(10);
			d0(4) <= d0(3) xor d0(10);
			d0(5) <= d0(4) xor d0(8);
			d0(6) <= d0(5);
			d0(7) <= d0(6);
			d0(8) <= d0(7);
			d0(9) <= d0(8);
			d0(10) <= d0(9);
		end if;
	end process;
	-- 2. GEN
	process(clk_hz) is
	begin
		if rising_edge(clk_hz) then
			d1(1) <= d1(10);
			d1(2) <= d1(1);
			d1(3) <= d1(2) xor d1(9);
			d1(4) <= d1(3);
			d1(5) <= d1(4);
			d1(6) <= d1(5);
			d1(7) <= d1(6);
			d1(8) <= d1(7);
			d1(9) <= d1(8) xor d1(10);
			d1(10) <= d1(9) xor d1(7);
		end if;
	end process;
	-- 3. GEN
	process(clk_hz) is
	begin
		if rising_edge(clk_hz) then
			d2(1) <= d2(10);
			d2(2) <= d2(1) xor d2(8);
			d2(3) <= d2(2);
			d2(4) <= d2(3) xor d2(9);
			d2(5) <= d2(4);
			d2(6) <= d2(5);
			d2(7) <= d2(6);
			d2(8) <= d2(7) xor d2(10);
			d2(9) <= d2(8);
			d2(10) <= d2(9);
		end if;
	end process;
	-- 4. GEN
	process(clk_hz) is
	begin
		if rising_edge(clk_hz) then
			d3(1) <= d3(10) xor d3(4);
			d3(2) <= d3(1);
			d3(3) <= d3(2);
			d3(4) <= d3(3) xor d3(5);
			d3(5) <= d3(4);
			d3(6) <= d3(5);
			d3(7) <= d3(6) xor d3(6);
			d3(8) <= d3(7);
			d3(9) <= d3(8);
			d3(10) <= d3(9);
		end if;
	end process; 
	-- generace 1 hz hodin
process(clk)
begin
	if(rising_edge(clk)) then
	count <=count+1;
		if(count = 12000000) then
		clk_hz <= not clk_hz;
		count <=1;
	end if;
end if;
end process;

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

	cislo0(3)<=d0(9);
	cislo0(2)<=d0(8);
	cislo0(1)<=d0(7);
	cislo0(0)<=d0(6);

	cislo1(3)<=d1(10);
	cislo1(2)<=d1(6);
	cislo1(1)<=d1(7);
	cislo1(0)<=d1(4);
	
	cislo2(3)<=d2(8);
	cislo2(2)<=d2(10);
	cislo2(1)<=d2(3);
	cislo2(0)<=d2(6);
	
	cislo3(3)<=d3(5);
	cislo3(2)<=d3(9);
	cislo3(1)<=d3(4);
	cislo3(0)<=d3(8);
-- registr na piny
led <= regs;
-- negace	
segment <= not (segment2);

with cislo0 select
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
			"11101110" when "1010", -- A
			"00111110" when "1011", -- B
			"10011100" when "1100", -- C
			"01111010" when "1101", -- D
			"10011110" when "1110", -- E
			"10001110" when "1111", -- F
			"00000000" when others;

with cislo1 select
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
			"11101110" when "1010", -- A
			"00111110" when "1011", -- B
			"10011100" when "1100", -- C
			"01111010" when "1101", -- D
			"10011110" when "1110", -- E
			"10001110" when "1111", -- F
			"00000000" when others;

with cislo2 select
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
			"11101110" when "1010", -- A
			"00111110" when "1011", -- B
			"10011100" when "1100", -- C
			"01111010" when "1101", -- D
			"10011110" when "1110", -- E
			"10001110" when "1111", -- F
			"00000000" when others;		
with cislo3 select
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
			"11101110" when "1010", -- A
			"00111110" when "1011", -- B
			"10011100" when "1100", -- C
			"01111010" when "1101", -- D
			"10011110" when "1110", -- E
			"10001110" when "1111", -- F
			"00000000" when others;			
				
with regs select
	segment2 <=  secd0 when "1000",
			secd1 when "0100",
			secd2 when "0010",
			secd3 when "0001",
			"00000000" when others;
							
end Behavioral;