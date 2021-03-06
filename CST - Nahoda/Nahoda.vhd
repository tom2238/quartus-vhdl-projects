
-- Xorshift pseudo-random number generator
-- http://en.wikipedia.org/wiki/Xorshift

-- uint32_t xor128(void) {
--     static uint32_t x = 123456789;
--     static uint32_t y = 362436069;
--     static uint32_t z = 521288629;
--     static uint32_t w = 88675123;
--     uint32_t t;
-- 
--     t = x ^ (x << 11); x = y; y = z; z = w;
--     w = w ^ (w >> 19) ^ (t ^ (t >> 8));
--     return w;
-- }

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity Nahoda is
    port (
        clk: in std_logic;
        led	: out std_logic_vector(7 downto 0);
        segment	: out std_logic_vector(7 downto 0)
    );
end Nahoda;

architecture Behavioral of Nahoda is
    signal STATE : unsigned(31 downto 0) := to_unsigned(1, 32);
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
	-- 1hz
	signal count : integer :=1;
	signal clk_hz : std_logic :='0';
	signal OUTPUT : std_logic_vector(31 downto 0);
    -- negace cisel segmentu
	signal segment2 : std_logic_vector(7 downto 0);
	
begin
    OUTPUT <= std_logic_vector(STATE);
    
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
	-- generace 1 hz hodin
	process(clk)
	begin
		if(rising_edge(clk)) then
		count <=count+1;
			if(count = 1200000) then
			clk_hz <= not clk_hz;
			count <=1;
			end if;
		end if;
	end process; 
	
    Update : process(clk_hz) is
        variable tmp : unsigned(7 downto 0);
    begin
        if(rising_edge(clk_hz)) then
            tmp := (STATE(31 downto 24) xor (STATE(31 downto 24) sll 11));
            STATE <= STATE(23 downto 0) &
                ((STATE(7 downto 0) xor (STATE(7 downto 0) srl 19)) xor (tmp xor (tmp srl 8)));
        end if; 
    end process;
	-- negace segmenu
	segment <= not (segment2);
	-- signals to pins			
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
	
	with OUTPUT(31 downto 28) select
	cislo0 <=  "11111100" when "0000", -- 0
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
			
	with OUTPUT(27 downto 24) select
	cislo1 <=  "11111100" when "0000", -- 0
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
			
	with OUTPUT(23 downto 20) select
	cislo2 <=  "11111100" when "0000", -- 0
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
	
	with OUTPUT(19 downto 16) select
	cislo3 <=  "11111100" when "0000", -- 0
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
	
	with OUTPUT(15 downto 12) select
	cislo4 <=  "11111100" when "0000", -- 0
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
			
	with OUTPUT(11 downto 8) select
	cislo5 <=  "11111100" when "0000", -- 0
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
			
	with OUTPUT(7 downto 4) select
	cislo6 <=  "11111100" when "0000", -- 0
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
			
	with OUTPUT(3 downto 0) select
	cislo7 <=  "11111100" when "0000", -- 0
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
													
end Behavioral;
