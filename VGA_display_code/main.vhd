library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Entity start
entity main is
    Port ( 
            clk : in std_logic;
            red : out STD_LOGIC_VECTOR (4 downto 0);
            green : out STD_LOGIC_VECTOR (5 downto 0);
            blue : out STD_LOGIC_VECTOR (4 downto 0);
            hsync : out STD_LOGIC;
            vsync : out STD_LOGIC;
            -- pmod
            hsync_pmod : out STD_LOGIC;
            vsync_pmod : out STD_LOGIC
            );
end main;
-- Entity end

-- Architecture start
architecture Behavioral of main is
---------------

constant v_disp : integer := 480;
constant h_disp : integer := 640;
constant v_pulse : integer := 2;
constant h_pulse : integer := 96;
constant v_fp : integer := 10;
constant h_fp : integer := 16;
constant v_bp : integer := 33;
constant h_bp : integer := 48;

signal vga_clk : std_logic := '0';

signal r : STD_LOGIC_VECTOR (4 downto 0) := "00000";
signal g : STD_LOGIC_VECTOR (5 downto 0) := "000000";
signal b : STD_LOGIC_VECTOR (4 downto 0) := "00000";
signal hs : std_logic := '1';
signal vs : std_logic := '1';

signal h_counter : integer range 0 to h_pulse + h_bp + h_disp + h_fp := 0;
signal v_counter : integer range 0 to v_pulse + v_bp + v_disp + v_fp := 0;

---------------
begin

-- Clock generator
clk_component_inst : entity work.clk_component
port map
 (-- Clock in ports
  clk_in1           => clk,
  -- Clock out ports
  clk_vga           => vga_clk,
  -- Status and control signals
  reset             => '0',
  locked            => open
 );

vga_controller: process (vga_clk)
begin
if(rising_edge(vga_clk)) then
    
    h_counter <= h_counter + 1;
    
    if h_counter < 214 then -- h_disp
        r <= "11111";
        g <= "000000";
        b <= "00000";
    elsif h_counter < 417 then
        r <= "00000";
        g <= "111111";
        b <= "00000";
    elsif h_counter < h_disp then
        r <= "00000";
        g <= "000000";
        b <= "11111";
    else 
        r <= "00000";
        g <= "000000";
        b <= "00000";
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
    hsync_pmod <= hs;
    vsync <= vs;
    vsync_pmod <= vs;
    
         
end if;
end process vga_controller;

end Behavioral;
-- Architecture end