library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity casovac is
	port
	(
		clk 	: in std_logic;
	    reset	: in std_logic;
	    start	: in std_logic;
	    b_doma	: in std_logic;
	    b_host	: in std_logic;
	    reg_obh	: out std_logic_vector(7 downto 0);
	    segmenty	: out std_logic_vector(7 downto 0)
	);
end casovac;

architecture Behavioral of casovac is
-- signals
-- registr
signal registr : std_logic_vector(15 downto 0);
signal regs : std_logic_vector(7 downto 0) := "00000001";
-- segmenty
signal segmenty_neg : std_logic_vector(7 downto 0);
-- cas 20 min
signal cas0 : std_logic_vector(7 downto 0);
signal cas1 : std_logic_vector(7 downto 0);
signal cas2 : std_logic_vector(7 downto 0);
signal cas3 : std_logic_vector(7 downto 0);
-- body vystup
signal b_doma0 : std_logic_vector(7 downto 0);
signal b_doma1 : std_logic_vector(7 downto 0);
signal b_host0 : std_logic_vector(7 downto 0);
signal b_host1 : std_logic_vector(7 downto 0);
-- 1hz
signal count : integer :=1;
signal clk_hz : std_logic :='0';
-- cas
signal cas_m0 : std_logic_vector(3 downto 0) := "0010";
signal cas_m1 : std_logic_vector(3 downto 0) := "0000";
signal cas_s0 : std_logic_vector(3 downto 0) := "0000";
signal cas_s1 : std_logic_vector(3 downto 0) := "0000";
-- body
signal b_dom0 : std_logic_vector(3 downto 0) := "0000";
signal b_dom1 : std_logic_vector(3 downto 0) := "0000";
signal b_hst0 : std_logic_vector(3 downto 0) := "0000";
signal b_hst1 : std_logic_vector(3 downto 0) := "0000";
-- pauza
signal pause : std_logic := '1';

begin

-- registr segmentovek
process (registr(15))
	begin
	if (rising_edge(registr(15)))  then
	regs <= regs(6 downto 0) & regs(7);
	end if;
end process;
-- citac registru
process(clk)
begin
	if(rising_edge(clk)) then
		registr <= registr + 1;
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

-- casovac body
process(clk_hz, reset, start)
begin
-- casovac
if (reset = '0') then
	cas_m0 <= "0010";
	cas_m1 <= "0000";
	cas_s0 <= "0000";
	cas_s1 <= "0000";
	pause <= '1';	
else
	if(rising_edge(clk_hz)) and (pause = '0') then
		cas_s1 <= cas_s1 - 1;
		if (cas_s1 = "0000") then
			cas_s1 <= "1001";
			cas_s0 <= cas_s0 - 1;
			if (cas_s0 = "0000") then
				cas_s0 <= "0101";
				cas_m1 <= cas_m1 - 1;
				if (cas_m1 = "0000") then
					cas_m1 <= "1001";
					cas_m0 <= cas_m0 - 1;					
				end if;
			end if;
		end if;
		if (cas_s1 = "0000") and (cas_s0 = "0000") and (cas_m1 = "0000") and (cas_m0 = "0000") then 
			pause <= '1';
			cas_s1 <= "1010";
			cas_s0 <= "1010";
			cas_m1 <= "1010";
			cas_m0 <= "1010";
		end if;
	end if;
end if;	
if (start = '0') then
	pause <= not pause;
end if;	
end process;
						
-- body
process (reset, b_doma, b_host)
begin 
if (reset = '0') then
	b_dom0 <= "0000";
	b_dom1 <= "0000";
	b_hst0 <= "0000";
	b_hst1 <= "0000";
else
	-- domaci
	if (b_dom0 = "1001") and (b_dom1 = "1001") then
		-- pause <= '1';
	else
		if (b_doma = '0') and (pause = '0') then
			b_dom1 <= b_dom1 + 1;
			if (b_dom1 = "1001") then
				b_dom1 <= "0000";
				b_dom0 <= b_dom0 + 1;
			end if;
		end if;
	end if;

	-- hoste
	if (b_hst0 = "1001") and (b_hst1 = "1001") then
		-- pause <= '1';
	else
		if (b_host = '0') and (pause = '0') then
			b_hst1 <= b_hst1 + 1;
			if (b_hst1 = "1001") then
				b_hst1 <= "0000";
				b_hst0 <= b_hst0 + 1;
			end if;		
		end if;
	end if;
end if;
end process;

-- registr na piny
reg_obh <= regs;
-- negace segmentu
segmenty <= not (segmenty_neg);
-- vyber
with regs select
	segmenty_neg <=  cas0 when "10000000",
			cas1 when "01000000",
			cas2 when "00100000",
			cas3 when "00010000",
			b_doma0 when "00001000",
			b_doma1 when "00000100",
			b_host0 when "00000010",
			b_host1 when "00000001",
			"00000000" when others;

-- cas1 sec
with cas_s1 select
	cas3 <=  "11111100" when "0000", -- 0
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
			
-- cas2 sec
with cas_s0 select
	cas2 <=  "11111100" when "0000", -- 0
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

-- cas1 sec
with cas_m1 select
	cas1 <=  "11111100" when "0000", -- 0
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
			
-- cas2 sec
with cas_m0 select
	cas0 <=  "11111100" when "0000", -- 0
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


-- domac
with b_dom1 select
	b_doma1 <=  "11111100" when "0000", -- 0
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

-- domac
with b_dom0 select
	b_doma0 <=  "11111100" when "0000", -- 0
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
			
-- host
with b_hst1 select
	b_host1 <=  "11111100" when "0000", -- 0
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

-- host
with b_hst0 select
	b_host0 <=  "11111100" when "0000", -- 0
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
	