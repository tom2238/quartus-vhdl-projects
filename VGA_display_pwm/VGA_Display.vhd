library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
--use IEEE.NUMERIC_STD.ALL;

-- Entity start
entity VGA_Display is
    Port ( 
            clk : in std_logic;
            red : out STD_LOGIC;
            green : out STD_LOGIC;
            blue : out STD_LOGIC;
            hsync : out STD_LOGIC;
            vsync : out STD_LOGIC;
            red_b	: in std_logic;
			green_b	: in std_logic;
			blue_b	: in std_logic;
			reset	: in std_logic
            );
end VGA_Display;
-- Entity end

-- Architecture start
architecture Behavioral of VGA_Display is
---------------
--DATA Protokolu Hodnoty na http://vhdl.cz/vhdl/vga/ Napsat hodnotu krystalu (12 MHz)
constant v_disp : integer := 480;		-- rozliseni V
constant h_disp : integer := 640;		-- rozliseni H
constant v_pulse : integer := 2;		--sync  V
constant h_pulse : integer := 96;		--sync	H
constant v_fp : integer := 10;			--front V
constant h_fp : integer := 16;			--front H
constant v_bp : integer := 33;			--back  V
constant h_bp : integer := 48;			--back  H

signal r : STD_LOGIC := '0';
signal g : STD_LOGIC := '0';
signal b : STD_LOGIC := '0';
signal hs : std_logic := '1';
signal vs : std_logic := '1';

signal h_counter : integer range 0 to h_pulse + h_bp + h_disp + h_fp := 0;
signal v_counter : integer range 0 to v_pulse + v_bp + v_disp + v_fp := 0;

signal count : integer :=1;
signal color_out : std_logic_vector(2 downto 0);
-- signals
signal cervena : std_logic_vector(12 downto 0);
signal modra : std_logic_vector(12 downto 0);
signal zelena : std_logic_vector(12 downto 0);
-- reg
signal reg0 : std_logic_vector(7 downto 0) := "00000001";
signal reg1 : std_logic_vector(7 downto 0) := "00000001";
signal reg2 : std_logic_vector(7 downto 0) := "00000001";
signal prepin0 : std_logic_vector(7 downto 0);
signal prepin1 : std_logic_vector(7 downto 0);
signal prepin2 : std_logic_vector(7 downto 0);
-- stat
signal stat0 : std_logic :='0';
signal stat1 : std_logic :='0';
signal stat2 : std_logic :='0';
-- stat citac
signal stat0c : std_logic :='1';
signal stat1c : std_logic :='1';
signal stat2c : std_logic :='1';
-- 24hz
signal  hz : std_logic :='0';
signal count1 : integer :=1;
-- 10hz
signal  rst_hz : std_logic :='0';
signal rst	 : integer :=1;
--
signal save : std_logic :='1';
signal prepin0_sav : std_logic_vector(7 downto 0);
signal prepin1_sav : std_logic_vector(7 downto 0);
signal prepin2_sav : std_logic_vector(7 downto 0);

begin
-- citac cervena
process (clk)
	begin
	if (rising_edge(clk)) and (stat0c='1') then
		cervena <= cervena + 1;
	end if;
end process;
-- citac modra
process (clk)
	begin
	if (rising_edge(clk)) and (stat1c='1')then
		modra <= modra + 1;
	end if;
end process;
-- citac zelena
process (clk)
	begin
	if (rising_edge(clk)) and (stat2c='1')then
		zelena <= zelena + 1;
	end if;
end process;
-- generace 24 hz hodin
process(clk)
begin
	if(rising_edge(clk)) then
	count1 <=count1+1;
		if(count1 = 500000) then
		hz <= not hz;
		count1 <=1;
	end if;
end if;
end process;
-- generace 8 hz hodin
process(clk)
begin
	if(rising_edge(clk)) then
	rst <=rst+1;
		if(rst = 960000) then
		rst_hz <= not rst_hz;
		rst <=1;
	end if;
end if;
end process;
-- VGA Driver
process (clk)
begin
	if(rising_edge(clk)) then
    
    h_counter <= h_counter + 1;
    
    if (h_counter < h_disp) then
        r <= color_out(0);
        g <= color_out(1);
        b <= color_out(2);        
    else 
        r <= '0';
        g <= '0';
        b <= '0';
    end if;
    
    if (h_counter >= h_disp + h_fp and h_counter < h_disp + h_fp + h_pulse) then
        hs <= '0';
    else 
        hs <= '1';
    end if;
    
    if (h_counter = h_disp + h_fp + h_pulse + h_bp) then
        h_counter <= 0;
        v_counter <= v_counter + 1;
    end if;
    
    if (v_counter >= v_disp + v_fp and v_counter < v_disp + v_fp + v_pulse) then
        vs <= '0';
    else 
        vs <= '1';
    end if;
    
    if (v_counter = v_disp + v_fp + v_pulse + v_bp) then
        v_counter <= 0;
    end if;

    -- Signals
    
    red <= r;
    green <= g;
    blue <= b;
    hsync <= hs;
    vsync <= vs;
	end if;
end process;

-- pwm
-- delka cyklu
process (red_b, green_b, blue_b, reset, hz)
begin
	
if (rising_edge(hz)) then
	if (reset = '0') and (rst_hz = '0') then
		if (save = '0') then
			prepin0 <= prepin0_sav;
			prepin1 <= prepin1_sav;
			prepin2 <= prepin2_sav;
			stat0c <= '0';
			stat1c <= '0';
			stat2c <= '0';
			save <= '1';
		else	
			if (prepin0 = "00000000") and (prepin1 = "00000000") and (prepin2 = "00000000")then
				--
			else			
				prepin0_sav <= prepin0;
				prepin1_sav <= prepin1;
				prepin2_sav <= prepin2;
				prepin0 <= "00000000";
				prepin1 <= "00000000";
				prepin2 <= "00000000";
			end if;
			stat0c <= '0';
			stat1c <= '0';
			stat2c <= '0';
			save <= '0';
		end if;
	else		
		if (red_b = '0') then
			if (stat0 = '0') then
				if (prepin0 = "11111111") then
					stat0 <= '1';
				else
					prepin0 <= prepin0 + 1;
				end if;	
			end if;		
			if (stat0 = '1') then	
				if (prepin0 = "00000000") then
					stat0 <= '0';
				else
					prepin0 <= prepin0 - 1;
				end if;
			end if;
			stat0c <= '1';
		end if;
		if (blue_b = '0') then
			if (stat1 = '0') then
				if (prepin1 = "11111111") then
					stat1 <= '1';
				else
					prepin1 <= prepin1 + 1;
				end if;	
			end if;		
			if (stat1 = '1') then
				if (prepin1 = "00000000") then
					stat1 <= '0';
				else
					prepin1 <= prepin1 - 1;
				end if;
			end if;
			stat1c <= '1';
		end if;
		if (green_b = '0') then
			if (stat2 = '0') then
				if (prepin2 = "11111111") then
					stat2 <= '1';
				else
					prepin2 <= prepin2 + 1;
				end if;	
			end if;		
			if (stat2 = '1') then	
				if (prepin2 = "00000000") then
					stat2 <= '0';
				else
					prepin2 <= prepin2 - 1;
				end if;
			end if;
			stat2c <= '1';
		end if;
	end if;	
end if;
end process;

-- cervena led
process (cervena(12), reset)
	begin
	if (reset = '0') then
		color_out(0) <= '0';
		reg0 <= "00000001";
	elsif (rising_edge(cervena(12)))  then
	reg0 <= reg0 + 1;
		if (prepin0 > reg0) then
			color_out(0) <= '1';
		else
			color_out(0) <= '0';
		end if;
	end if;
end process;

-- modra led
process (modra(12), reset)
	begin
	if (reset = '0') then
		color_out(2) <= '0';
		reg1 <= "00000001";
	elsif (rising_edge(modra(12)))  then
	reg1 <= reg1 + 1;
		if (prepin1 > reg1) then
			color_out(2) <= '1';
		else
			color_out(2) <= '0';
		end if;
	end if;
end process;

-- zelena led
process (zelena(12), reset)
	begin
	if (reset = '0') then
		color_out(1) <= '0';
		reg2 <= "00000001";
	elsif (rising_edge(zelena(12)))  then
	reg2 <= reg2 + 1;
		if (prepin2 > reg2) then
			color_out(1) <= '1';
		else
			color_out(1) <= '0';
		end if;
	end if;
end process;

end Behavioral;