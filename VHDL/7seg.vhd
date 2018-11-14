library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity seven_segment is
       Port (   clk          : in     STD_LOGIC;
                    output1 : out  STD_LOGIC;
                    output2 : out  STD_LOGIC;
                    output3 : out  STD_LOGIC;
                    output4 : out  STD_LOGIC;
                    output5 : out  STD_LOGIC;
                    output6 : out  STD_LOGIC;
                    output7 : out  STD_LOGIC);
     end seven_segment;

architecture Behavioral of seven_segment is
signal temp: std_logic_vector(6 downto 0);
signal  counter: integer:=0;
    begin
       process(clk)
           begin
              if clk'event and clk='1' then                 
                      if counter = 9 then
                            counter <=0;
                     else
                        counter<= counter + 1;
                  end if;
         end process; 

   output1 <= temp(0);
   output2 <= temp(1);
   output3 <= temp(2);
   output4 <= temp(3);
   output5 <= temp(4);
   output6 <= temp(5);
   output7 <= temp(6);

   with counter Select
       temp<= "1000000" when 0,  
                      "1111001" when 1,
                      "0100100" when 2,
                      "0110000" when 3,
                      "0011001" when 4,
                      "0010010" when 5,
                      "0000010" when 6, 
                      "1111000" when 7, 
                      "0000000" when 8,
                      "0010000" when 9,        
                      "1000000" when others;

end Behavioral;