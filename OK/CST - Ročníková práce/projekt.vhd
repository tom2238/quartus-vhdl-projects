library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

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
signal prepin : std_logic_vector(7 downto 0);
signal registr : std_logic_vector(15 downto 0);
signal helper : std_logic_vector(7 downto 0) := "00000001";
signal radek2 : std_logic_vector(7 downto 0);
signal cislo : std_logic_vector(30 downto 0);
signal reg : std_logic_vector(7 downto 0) := "00000001";
signal stat : std_logic := '1';
-- srdce
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
	helper <= helper(6 downto 0) & helper(7);
	end if;
end process;
-- citac registru
process (clk)
	begin
	if (rising_edge(clk)) then
		registr <= registr + 1;
	end if;
end process;
-- pwm
process (clk)
	begin
	if (rising_edge(clk)) then
		cislo <= cislo + 1;
	end if;
end process;
-- delka cyklu
process (cislo(15))
	begin
	if (rising_edge(cislo(15))) then
		if (stat = '1') then
			if (prepin = "11111000") then
				stat <= '0';
			else 
				prepin <= prepin + 8;
			end if;
		end if;
		if (stat = '0') then
			if (prepin = "00000000") then
				stat <= '1';
			else
				prepin <= prepin - 1;
			end if;
		end if;
	end if;
end process;

process (cislo(10))
	begin
	if (rising_edge(cislo(10)))  then
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
			srd1 <= "01000100";
			srd2 <= "00100010";
			srd3 <= "00010001";
			srd4 <= "00010001";
			srd5 <= "00100010";
			srd6 <= "01000100";
			srd7 <= "00111000";
		end if;
	end if;
end process;

sloup <= helper;
radek <= not (radek2);

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
	