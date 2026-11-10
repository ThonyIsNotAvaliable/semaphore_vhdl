library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity traffic_controller is 
  port (
    clk : in STD_LOGIC;
    reset : in STD_LOGIC;
    start : in STD_LOGIC;
    done : out STD_LOGIC;
    
    street_a_g : out STD_LOGIC;
    street_a_y : out STD_LOGIC;
    street_a_r : out STD_LOGIC;
    
    street_b_g : out STD_LOGIC;
    street_b_y : out STD_LOGIC;
    street_b_r : out STD_LOGIC
  );
end traffic_controller;


architecture behaviour of traffic_controller is
  type STATE_TYPE is (IDLE_STATE, A_GREEN_B_RED, A_YELLOW_B_RED, A_RED_B_GREEN, A_RED_B_YELLOW, DONE_STATE);

  signal state, next_state: STATE_TYPE;
  
  constant GREEN_CYCLES : INTEGER := 10;
  constant YELLOW_CYCLES : INTEGER := 5;

  signal counter : INTEGER := 0;
  signal rst_counter : std_logic := '0';

begin
  REG: process (clk, reset) begin 
    if reset = '1' then
      state <= IDLE_STATE;
      counter <= 0;
    elsif rising_edge(clk) then
      if rst_counter = '1' then
        counter <= 0;
      else
        counter <= counter + 1;
      end if;
      
      state <= next_state;
    end if;    
  end process REG;

  CMB: process (state, start, counter) begin
    street_a_g <= '0'; street_a_y <= '0'; street_a_r <= '1';
    street_b_g <= '0'; street_b_y <= '0'; street_b_r <= '1';
    rst_counter <= '0';
    done <= '0';
    next_state <= state;

    case state is
      when IDLE_STATE =>
        if start = '1' then
          next_state <= A_GREEN_B_RED;
          rst_counter <= '1';
        end if;

      when A_GREEN_B_RED =>
        street_a_g <= '1';
        street_a_y <= '0';
        street_a_r <= '0';

        street_b_g <= '0';        
        street_b_y <= '0'; 
        street_b_r <= '1';

        if counter >= GREEN_CYCLES then
          next_state <= A_YELLOW_B_RED;
          rst_counter <= '1';
        end if;

      when A_YELLOW_B_RED =>
        street_a_g <= '0';
        street_a_y <= '1';
        street_a_r <= '0';

        street_b_g <= '0';        
        street_b_y <= '0'; 
        street_b_r <= '1';

        if counter >= YELLOW_CYCLES then
          next_state <= A_RED_B_GREEN;
          rst_counter <= '1';
        end if;

      when A_RED_B_GREEN =>
        street_a_g <= '0';
        street_a_y <= '0';
        street_a_r <= '1';

        street_b_g <= '1';
        street_b_y <= '0';
        street_b_r <= '0';

        if counter >= GREEN_CYCLES then
          next_state <= A_RED_B_YELLOW;
          rst_counter <= '1';
        end if;

      when A_RED_B_YELLOW =>
        street_a_g <= '0';
        street_a_y <= '0';
        street_a_r <= '1';
        
        street_b_g <= '0';
        street_b_y <= '1';
        street_b_r <= '0';

        if counter >= YELLOW_CYCLES then
          next_state <= DONE_STATE;
          rst_counter <= '1';
        end if;

      when DONE_STATE =>
        done <= '1';
        next_state <= IDLE_STATE;
        
    end case;
  end process CMB;
end behaviour;
