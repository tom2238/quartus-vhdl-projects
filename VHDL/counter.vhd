library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity COUNTER_2 is
    Port ( CLK                      :  in  STD_LOGIC;
               RESET                :  in  STD_LOGIC;
               START_STOP    :  in  STD_LOGIC;
               UP_DOWN         :  in  STD_LOGIC;
               OUTPUT             : out  STD_LOGIC_VECTOR (6 downto 0));
end COUNTER_2;

architecture Behavioral of COUNTER_2 is

--State definition
type state_type is (stop,up,down);
signal state, state_next: state_type:= stop;

--Counter definition
signal counter,counter_next: std_logic_vector(6 downto 0):="0000000";
   

begin

         process(CLK, RESET)
             begin
                 if RESET='1' then
                          counter <= "0000000";
                          state <= stop;
                 elsif CLK ='1' and CLK'event then
                          state <= state_next;
                          counter<= counter_next;
                 end if;
            end process;

       process(state,counter,START_STOP,UP_DOWN) 
            begin
                state_next<= state;
                counter_next<= counter;      
                case state is
                           when stop=>
                                                   if START_STOP= '1' then
                                                        if UP_DOWN = '1' then
                                                              state_next<= up;
                                                        else  
                                                               state_next<= down;
                                                        end if;
                                                   end if;                                              
                          when up =>  
                                                  counter_next<= counter + '1';
                                                  if START_STOP= '0' then
                                                        state_next<= stop;
                                                  elsif UP_DOWN = '0' then
                                                        state_next<= down;                                            
                                                 end if;                            
                        when down =>
                                                  counter_next<= counter - '1';                                                   
                                                  if START_STOP= '0' then
                                                        state_next<= stop;
                                                  elsif UP_DOWN = '1' then
                                                        state_next<= up;                                         
                                                  end if;          
             end case;
        end process;

     output<= counter;

   end Behavioral;