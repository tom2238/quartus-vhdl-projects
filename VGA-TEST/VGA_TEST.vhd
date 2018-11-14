library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity VGA_TEST is
    Port ( 	clk : in  STD_LOGIC;
			Hsync : out  STD_LOGIC;
			Vsync : out  STD_LOGIC;
			Rout : out  STD_LOGIC;
			Gout : out STD_LOGIC;
			Bout : out STD_LOGIC);
end VGA_TEST;

architecture Behavioral of VGA_TEST is

signal x : STD_LOGIC_VECTOR (10 downto 0);
signal y : STD_LOGIC_VECTOR (10 downto 0);
signal vgaclk:std_logic:='0';
signal R : STD_LOGIC;
signal G : STD_LOGIC; 
signal B : STD_LOGIC; 


    component pll1 is
        port (
		inclk0		: IN STD_LOGIC  := '0';
		c0		: OUT STD_LOGIC 
        );
    end component pll1;

begin

c1: pll1 port map (clk, vgaclk);

process(vgaclk)
begin
	if(vgaclk'event and vgaclk = '1') then
		x <= x+1;
		if x = 1038 then
			x <= (others => '0');
			y <= y+1;
			if y = 665 then
				y <= (others => '0');
			end if;
		end if;
	end if;
end process;

process(vgaclk)
begin
	if(vgaclk'event and vgaclk = '1') then
		
		if (x <= 815 and y <= 5) and (x >= 0 and y >= 0) then
			r <= '0';
			g <= '0';
			b <= '0';
		elsif (x <= 5 and y <= 605) and (x >= 0 and y >= 0) then
			r <= '0';
			g <= '0';
			b <= '0';	
		elsif (x <= 812 and y <= 600) and (x >= 807 and y >= 0) then
			r <= '0';
			g <= '0';
			b <= '0';	
		elsif (x <= 812 and y <= 600) and (x >= 0 and y >= 595) then
			r <= '0';
			g <= '0';
			b <= '0';		
		elsif y < 300 then
			if y > x then
				r <= '0';
				g <= '0';
				b <= '1';
			elsif y = x then
				r <= '0';
				g <= '0';
				b <= '0';   
			else
				r <= '1';
				g <= '1';
			   b <= '1';
			end if;
		elsif y = 300 and x >= 300 then 
			r <= '0';
			g <= '0';
			b <= '0';
		else
			if (598-y) > x then
				r <= '0';
				g <= '0';
				b <= '1';
			elsif ((598-y) = x) or ((599-y) = x) then
				r <= '0';
				g <= '0';
				b <= '0';
			else
				r <= '1';
				g <= '0';
				b <= '0';
			end if;
		end if;
	end if;
end process;

Hsync <= '0' when x > 855 and x < 975 else '1';
Vsync <= '0' when y 	> 636 and y	 < 642 else '1';

Rout <= R when x < 815 else '0';
Gout <= G when x < 815 else '0';
Bout <= B when x < 815 else '0';

end Behavioral;