entity shift_register is
   port(
      CLK      : in  std_logic;
      RST      : in  std_logic;
      DATA_IN  : in  std_logic;
      BIT_OUT  : out std_logic;
      BYTE_OUT : out std_logic_vector(7 downto 0)
   );
end shift_register;


architecture bhv of shift_register is

----------------------------------------------------------------
-- signal definitions
----------------------------------------------------------------

--shift register signals
type sr12x8 is array (0 to 11) of std_logic_vector(7 downto 0);
signal bit_shift_reg : std_logic_vector(7 downto 0);
signal byte_shift_reg : sr12x8;

begin

----------------------------------------------------------------
-- shift register
----------------------------------------------------------------

--shift register
process(RST,CLK)
begin
   if(rising_edge(CLK)) then
     
      --intitialize shift registers to zero on reset
      if(RST='1') then
         bit_shift_reg <= (others=>'0');
         byte_shift_reg <= (others=>(others=>'0'));
      else
         
         --bit shift register
         bit_shift_reg(7 downto 1) <= bit_shift_reg(6 downto 0);
         bit_shift_reg(0) <= DATA_IN;        
         
         --byte shift register
         byte_shift_reg(1 to 11) <= byte_shift_reg(0 to 10);
         byte_shift_reg(0) <= bit_shift_reg;
         
      end if;
   end if;
end process;

----------------------------------------------------------------
-- outputs
----------------------------------------------------------------

--module output registers
process(RST,CLK)
begin
   if(rising_edge(CLK)) then
      if(RST='1') then
         BIT_OUT <= '0';
         BYTE_OUT <= (others=>'0');
      else
         BIT_OUT <= bit_shift_reg(7);
         BYTE_OUT <= byte_shift_reg(11);
      end if;
   end if;
end process;



end bhv;