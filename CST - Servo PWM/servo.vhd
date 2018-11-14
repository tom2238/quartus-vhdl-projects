library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity servo is
    Port ( clk           : in  STD_LOGIC;
               reset      : in  STD_LOGIC;
               button_l : in  STD_LOGIC; 
               button_r : in  STD_LOGIC;
               pwm       : out  STD_LOGIC);
   end servo;

architecture Behavioral of servo is
      constant period:integer:=1000000;
      constant dcycle_max:integer:=100000;
      constant dcycle_min:integer:=50000;
      constant duty_in:integer:=200;
      signal pwm_reg,pwm_next:std_logic;
      signal duty_cycle,duty_cycle_next:integer:=0;
      signal counter,counter_next:integer:=0;
      signal tick:std_logic;
    begin
    --register
         process(clk,reset)
              begin
                   if reset = '1' then
                        pwm_reg<='0';
                        counter<=0;
                        duty_cycle<=0;
                   elsif clk='1' and clk'event then
                         pwm_reg<=pwm_next;
                         counter<=counter_next;
                         duty_cycle<=duty_cycle_next;
                   end if;
             end process;

counter_next<= 0 when counter = period else
                           counter+1;
tick<= '1' when counter= 0 else
             '0';

--Changing Duty Cycle
   process(button_l,button_r,tick,duty_cycle)
        begin
             duty_cycle_next<=duty_cycle;
              if tick='1' then
                   if button_l ='1' and duty_cycle >dcycle_min then
                          duty_cycle_next<=duty_cycle-duty_in;
                   elsif button_r ='1' and duty_cycle < dcycle_max then
                          duty_cycle_next<=duty_cycle+duty_in;
                  end if;             
            end if;                           
      end process;
--Buffer
pwm<=pwm_reg;    
pwm_next<= '1' when counter < duty_cycle else
                         '0';   
end Behavioral;