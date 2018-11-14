library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity Logo is
	port
	(
		clk		: in std_logic;
		sloupce : out std_logic_vector(7 downto 0);
		radky : out std_logic_vector(7 downto 0)
	);
end Logo;

architecture Behavioral of Logo is
-- arrays
-- type ledmemx is array(13 downto 0) of std_logic_vector(7 downto 0);
-- signal ledmem : ledmemx := ("11111111", "11111111", "11111111", "11111111", "11111111", "11111111", "11111111", "11111111", "11111111", "11111111", "11111111", "11111111", "11111111", "11111111");
-- shared variable index : integer range 0 to 14 := 1;
-- registr
signal regdisp : std_logic_vector(7 downto 0) := "00000001"; 
signal registr : std_logic_vector(15 downto 0);
-- radky neg
signal radky2 : std_logic_vector(7 downto 0);
-- obraz
signal rd0 : std_logic_vector(7 downto 0) := "00000000";
signal rd1 : std_logic_vector(7 downto 0) := "00000000";
signal rd2 : std_logic_vector(7 downto 0) := "00100100";
signal rd3 : std_logic_vector(7 downto 0) := "01101100";
signal rd4 : std_logic_vector(7 downto 0) := "10110111";
signal rd5 : std_logic_vector(7 downto 0) := "00100100";
signal rd6 : std_logic_vector(7 downto 0) := "00000000";
signal rd7 : std_logic_vector(7 downto 0) := "00000000";
-- pwm
signal cas : std_logic_vector(1 downto 0);
-- max rozliseni pwm urovni max 256
signal velikost : std_logic_vector(7 downto 0) := "00000001";
signal pomer 	: std_logic_vector(7 downto 0) := "01110011";
signal fan 	: std_logic :='0';
--led
signal ledky : std_logic_vector(13 downto 0) := "11111111111000";
-- 1hz
signal count : integer :=1;
signal clk_sec : std_logic :='0';
begin
-- registr segmentovek
process (registr(15))
	begin
	if (rising_edge(registr(15)))  then
		regdisp <= regdisp(6 downto 0) & regdisp(7);	
	end if;
end process;

-- generace pwm ramce
process (cas(1))
	begin
		if (rising_edge(cas(1)))  then
		velikost <= velikost + 1;
			if (pomer > velikost) then
				fan <= '1';
			else
				fan <= '0';
			end if;
		end if;
end process;

-- registr ledek
process (clk_sec)
	begin
	if (rising_edge(clk_sec))  then
		ledky <= ledky(12 downto 0) & ledky(13);	
	end if;
end process;
process (clk) 
	begin
		if (rising_edge(clk))  then 
    count <=count+1;  
    registr <= registr + 1;  
    cas <= cas + 1;
		  if(count = 2000000) then
		    clk_sec <= not clk_sec;
		    count <=1;
	    end if;
			if (ledky(0)='0') then
				rd4(7) <= '1';
			else
				rd4(7) <= fan;
			end if;
			if (ledky(1)='0') then
				rd3(6) <= '1';
			else
				rd3(6) <= fan;
			end if;
			if (ledky(2)='0') then
				rd2(5) <= '1';
			else
				rd2(5) <= fan;	
			end if;
			if (ledky(3)='0') then
				rd3(5) <= '1';
			else
				rd3(5) <= fan;
			end if;
			if (ledky(4)='0') then
				rd4(5) <= '1';
			else
				rd4(5) <= fan;
			end if;
			if (ledky(5)='0') then
				rd5(5) <= '1';
			else
				rd5(5) <= fan;
			end if;
			if (ledky(6)='0') then
				rd4(4) <= '1';
			else
				rd4(4) <= fan;
			end if;
			if (ledky(7)='0') then
				rd3(3) <= '1';
			else
				rd3(3) <= fan;
			end if;	
			if (ledky(8)='0') then
				rd2(2) <= '1';
			else
				rd2(2) <= fan;
			end if;	
			if (ledky(9)='0') then
				rd3(2) <= '1';
			else
				rd3(2) <= fan;
			end if;	
			if (ledky(10)='0') then
				rd4(2) <= '1';
			else
				rd4(2) <= fan;
			end if;	
			if (ledky(11)='0') then
				rd5(2) <= '1';
			else
				rd5(2) <= fan;
			end if;	
			if (ledky(12)='0') then
				rd4(1) <= '1';
			else
				rd4(1) <= fan;
			end if;	
			if (ledky(13)='0') then
				rd4(0) <= '1';
			else
				rd4(0) <= fan;
			end if;	
			
		end if; 
end process; 	
-- registr na piny
sloupce <= regdisp;
radky <= not (radky2);

with regdisp select
	radky2 <=  rd0 when "10000000",
			rd1 when "01000000",
			rd2 when "00100000",
			rd3 when "00010000",
			rd4 when "00001000",
			rd5 when "00000100",
			rd6 when "00000010",
			rd7 when "00000001",
			"00000000" when others;

end Behavioral;		