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
            vsync : out STD_LOGIC
            );
end VGA_Display;
-- Entity end

-- Architecture start
architecture Behavioral of VGA_Display is
---------------
--DATA Protokolu Hodnoty na http://vhdl.cz/vhdl/vga/ Napsat hodnotu krystalu (12 MHz)
--http://tinyvga.com/vga-timing/
--http://www.ece.ualberta.ca/~elliott/ee552/studentAppNotes/2002_w/interfacing/CRT/CRT_App_Note.html
constant v_disp : integer := 480;		-- rozliseni V
constant h_disp : integer := 650;		-- rozliseni H
constant v_pulse : integer := 2;		--sync  V
constant h_pulse : integer := 96;		--sync	H
constant v_fp : integer := 11;			--front V
constant h_fp : integer := 16;			--front H
constant v_bp : integer := 32;			--back  V
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

begin

-- generace 1 hz hodin
process(clk)
begin
	if(rising_edge(clk)) then
	count <=count+1;
		if(count = 120000000) then
		color_out <= color_out + 1;
		count <=1;
	end if;
end if;
end process;

-- VGA Driver
process (clk)
begin
	if(rising_edge(clk)) then
    
    h_counter <= h_counter + 1;
    
    if (h_counter < 420 and v_counter < 340) and (h_counter > 220 and v_counter > 140) then
        r <= color_out(0);
        g <= color_out(1);
        b <= color_out(2); 
    elsif (h_counter < 320 and v_counter < 240) and (h_counter > 32 and v_counter > 24) then
        r <= color_out(2);
        g <= color_out(0);
        b <= color_out(1);
    elsif (h_counter < 608 and v_counter < 456) and (h_counter > 320 and v_counter > 240) then
        r <= color_out(1);
        g <= color_out(2);
        b <= color_out(0);  
    elsif (h_counter < 10 and v_counter < 400) and (h_counter > 2 and v_counter > 2) then
        r <= color_out(1);
        g <= color_out(2);
        b <= color_out(2);             
    elsif h_counter < h_disp then
        r <= '0';
        g <= '0';
        b <= '0';       
    else 
        r <= '0';
        g <= '0';
        b <= '0';
    end if;
    
    if (h_counter >= h_disp + h_fp and h_counter < h_disp + h_fp + h_pulse) then
        hs <= '1';
    else 
        hs <= '0';
    end if;
    
    if (h_counter = h_disp + h_fp + h_pulse + h_bp) then
        h_counter <= 0;
        v_counter <= v_counter + 1;
    end if;
    
    if (v_counter >= v_disp + v_fp and v_counter < v_disp + v_fp + v_pulse) then
        vs <= '1';
    else 
        vs <= '0';
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

end Behavioral;