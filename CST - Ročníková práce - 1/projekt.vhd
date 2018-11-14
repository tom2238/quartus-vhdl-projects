-- knihovny 
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
-- porty (vstupy vystupy)
entity projekt is
	port
	(
		clk 	: in std_logic;
	    sloup	: out std_logic_vector(7 downto 0);
	    radek	: out std_logic_vector(7 downto 0)
	);
end projekt;

architecture Behavioral of projekt is
-- signals
--rychlost delky cyklu
signal prepin : std_logic_vector(7 downto 0);
-- obnovovací frekvence displaye
signal registr : std_logic_vector(15 downto 0);
-- jednicka co beha na sloupcich
signal helper : std_logic_vector(7 downto 0) := "00000001";
-- negace na display
signal radek2 : std_logic_vector(7 downto 0);
--rychlost pulzovani
signal cislo : std_logic_vector(30 downto 0);
-- pwm pricitani pri kazdem cyklu
signal reg : std_logic_vector(7 downto 0) := "00000001";
-- jestli ma pulzovat nahoru nebo dolu
signal stat : std_logic := '1';
-- srdce radky
signal srd0 : std_logic_vector(7 downto 0);
signal srd1 : std_logic_vector(7 downto 0);
signal srd2 : std_logic_vector(7 downto 0);
signal srd3 : std_logic_vector(7 downto 0);
signal srd4 : std_logic_vector(7 downto 0);
signal srd5 : std_logic_vector(7 downto 0);
signal srd6 : std_logic_vector(7 downto 0);
signal srd7 : std_logic_vector(7 downto 0);
begin

-- registr na sloupci
process (registr(15))
	begin
	if (rising_edge(registr(15)))  then
		-- kolovani 1 ve vektoru
		helper <= helper(6 downto 0) & helper(7);
	end if;
end process;
-- citac registru
process (clk)
	begin
	if (rising_edge(clk)) then
	-- pricitani 1 k reg 
		registr <= registr + 1;
	end if;
end process;
-- pwm
process (clk)
	begin
	if (rising_edge(clk)) then
	-- pricitani 1 kvuli pulzu
		cislo <= cislo + 1;
	end if;
end process;
-- delka cyklu
process (cislo(15))
	begin
	if (rising_edge(cislo(15))) then
		-- pulz dolu - zhasinani
		if (stat = '1') then
			if (prepin = "11111000") then
				stat <= '0';
			else 
				prepin <= prepin + 8;
			end if;
		end if;
		-- puly nahoru - rozinani
		if (stat = '0') then
			if (prepin = "00000000") then
				stat <= '1';
			else
				prepin <= prepin - 1;
			end if;
		end if;
	end if;
end process;
-- tvar srdce
process (cislo(1))
	begin
	if (rising_edge(cislo(1)))  then
	reg <= reg + 1;
		if (prepin > reg) then
			srd0 <= "00000000";
			srd1 <= "00000000";
			srd2 <= "00000000";
			srd3 <= "00000000";
			srd4 <= "00000000";
			srd5 <= "00000000";
			srd6 <= "00000000";
			srd7 <= "00000000";
		else
			srd0 <= "00111000";
			srd1 <= "01111100";
			srd2 <= "00111110";
			srd3 <= "00011111";
			srd4 <= "00011111";
			srd5 <= "00111110";
			srd6 <= "01111100";
			srd7 <= "00111000";
		end if;
	end if;
end process;

sloup <= helper;
radek <= not (radek2);
--
with helper select
	radek2 <=  srd0 when "10000000",
			srd1 when "01000000",
			srd2 when "00100000",
			srd3 when "00010000",
			srd4 when "00001000",
			srd5 when "00000100",
			srd6 when "00000010",
			srd7 when "00000001",
			"00000000" when others;


end Behavioral;		
	