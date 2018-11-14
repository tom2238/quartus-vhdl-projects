library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity MatrixDisp is
	port
	(
		clk		: in std_logic;
		sloupce : out std_logic_vector(7 downto 0);
		radky : out std_logic_vector(7 downto 0);
		tlac	: in std_logic
	);
end MatrixDisp;

architecture Behavioral of MatrixDisp is

-- registr
signal regs : std_logic_vector(7 downto 0) := "00000001"; 
signal registr : std_logic_vector(15 downto 0);
-- data reg
signal dregs : std_logic_vector(7 downto 0) := "00000001"; 
signal data : std_logic_vector(12 downto 0);
-- posun tlac
signal rndreg : std_logic_vector(5 downto 0) := "000001"; 
signal d0: std_logic_vector(16 downto 1) := (others=>'1'); 
-- radky neg
signal radky2 : std_logic_vector(7 downto 0);
-- data out
signal rd0 : std_logic_vector(7 downto 0);
signal rd1 : std_logic_vector(7 downto 0);
signal rd2 : std_logic_vector(7 downto 0);
signal rd3 : std_logic_vector(7 downto 0);
signal rd4 : std_logic_vector(7 downto 0);
signal rd5 : std_logic_vector(7 downto 0);
signal rd6 : std_logic_vector(7 downto 0);
signal rd7 : std_logic_vector(7 downto 0);
-- obraz
signal rdo0 : std_logic_vector(7 downto 0) := "11111111";
signal rdo1 : std_logic_vector(7 downto 0) := "11000011";
signal rdo2 : std_logic_vector(7 downto 0) := "10100101";
signal rdo3 : std_logic_vector(7 downto 0) := "10011001";
signal rdo4 : std_logic_vector(7 downto 0) := "10011001";
signal rdo5 : std_logic_vector(7 downto 0) := "10100101";
signal rdo6 : std_logic_vector(7 downto 0) := "11000011";
signal rdo7 : std_logic_vector(7 downto 0) := "11111111";
begin

-- registr segmentovek
-- registr nahody
process (registr(15))
	begin
	if (rising_edge(registr(15)))  then
		regs <= regs(6 downto 0) & regs(7);
		if (tlac = '0' and d0(10) = '1') then
			rndreg <= rndreg(4 downto 0) & rndreg(5);
		end if;		
	end if;
end process;
-- citac reg
process (clk)
	begin
	if (rising_edge(clk)) then
		registr <= registr + 1;
	end if;
end process;
-- registr dat
process (data(12))
	begin
	if (rising_edge(data(12)))  then
		dregs <= dregs(6 downto 0) & dregs(7);
	end if;
end process;
-- citac dat
process (clk)
	begin
	if (rising_edge(clk)) then
		data <= data + 1;
	end if;
end process;
-- zmena dat
process (data(12))
	begin
	if (rising_edge(data(12)))  then
		--
		rd0 <= rdo0 and dregs;
		rd1 <= rdo1 and dregs;
		rd2 <= rdo2 and dregs;
		rd3 <= rdo3 and dregs;
		rd4 <= rdo4 and dregs;
		rd5 <= rdo5 and dregs;
		rd6 <= rdo6 and dregs;
		rd7 <= rdo7 and dregs;
	end if;	
end process;

process (data(12)) 
begin
	if (rising_edge(data(12))) then
		if (rndreg="000001") then
			rdo0 <= "00000000";
			rdo1 <= "00000000";
			rdo2 <= "00000000";
			rdo3 <= "00011000";
			rdo4 <= "00011000";
			rdo5 <= "00000000";
			rdo6 <= "00000000";
			rdo7 <= "00000000";
		end if;
		if (rndreg="000010") then
			rdo0 <= "00000000";
			rdo1 <= "01100000";
			rdo2 <= "01100000";
			rdo3 <= "00000000";
			rdo4 <= "00000000";
			rdo5 <= "00000110";
			rdo6 <= "00000110";
			rdo7 <= "00000000";
		end if;
		if (rndreg="000100") then
			rdo0 <= "00000000";
			rdo1 <= "01100000";
			rdo2 <= "01100000";
			rdo3 <= "00011000";
			rdo4 <= "00011000";
			rdo5 <= "00000110";
			rdo6 <= "00000110";
			rdo7 <= "00000000";
		end if;
		if (rndreg="001000") then
			rdo0 <= "00000000";
			rdo1 <= "01100110";
			rdo2 <= "01100110";
			rdo3 <= "00000000";
			rdo4 <= "00000000";
			rdo5 <= "01100110";
			rdo6 <= "01100110";
			rdo7 <= "00000000";
		end if;
		if (rndreg="010000") then
			rdo0 <= "00000000";
			rdo1 <= "01100110";
			rdo2 <= "01100110";
			rdo3 <= "00011000";
			rdo4 <= "00011000";
			rdo5 <= "01100110";
			rdo6 <= "01100110";
			rdo7 <= "00000000";
		end if;
		if (rndreg="100000") then
			rdo0 <= "00000000";
			rdo1 <= "01100110";
			rdo2 <= "01111110";
			rdo3 <= "00100100";
			rdo4 <= "00100100";
			rdo5 <= "01111110";
			rdo6 <= "01100110";
			rdo7 <= "00000000";
		end if;
	end if;
end process;

process(registr(15))
begin
	if (rising_edge(registr(15))) then
		d0(1) <= d0(16);
		d0(2) <= d0(1);
		d0(3) <= d0(2) xor d0(16);
		d0(4) <= d0(3) xor d0(16);
		d0(5) <= d0(4) xor d0(16);
		d0(6) <= d0(5) xor d0(16);
		d0(7) <= d0(6);
		d0(8) <= d0(7);
		d0(9) <= d0(8);
		d0(10) <= d0(9);
		d0(11) <= d0(10);
		d0(12) <= d0(11);
		d0(13) <= d0(12);
		d0(14) <= d0(13);
		d0(15) <= d0(14);
		d0(16) <= d0(15);
	end if;
end process;

-- registr na piny
sloupce <= regs;
radky <= not (radky2);
--
with regs select
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
	