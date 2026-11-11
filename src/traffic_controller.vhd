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
  
  constant GREEN_CYCLES : STD_LOGIC_VECTOR(3 downto 0) := "1010"; -- 10 em binário
  constant YELLOW_CYCLES : STD_LOGIC_VECTOR(3 downto 0) := "0101"; -- 5 em binário

  signal counter : STD_LOGIC_VECTOR(3 downto 0) := "0000";
  signal rst_counter : STD_LOGIC := '0';
  signal comb_reset : STD_LOGIC := '0';

begin

  comb_reset <= rst_counter or reset;

  d_counter : entity work.contador
  generic map(W => 3)
  port map(
    RESET => comb_reset,
    INPUT => clk,
    OUTPUT => counter
  );


  REG: process (clk, reset) begin 
    if reset = '1' then
      state <= IDLE_STATE;
      rst_counter <= '0';
    elsif rising_edge(clk) then     
      state <= next_state;
      
      if state /= next_state then
         rst_counter <= '1';
      else
         rst_counter <= '0';
      end if;
      
    end if;    
  end process REG;

  CMB: process (state, start, counter) begin
    street_a_g <= '0'; street_a_y <= '0'; street_a_r <= '1';
    street_b_g <= '0'; street_b_y <= '0'; street_b_r <= '1';
    done <= '0';
    next_state <= state;

    case state is
      when IDLE_STATE =>
        if start = '1' then
          next_state <= A_GREEN_B_RED;

        end if;

      when A_GREEN_B_RED =>
        street_a_g <= '1';
        street_a_y <= '0';
        street_a_r <= '0';

        street_b_g <= '0';        
        street_b_y <= '0'; 
        street_b_r <= '1';

        if counter = GREEN_CYCLES then
          next_state <= A_YELLOW_B_RED;

        end if;

      when A_YELLOW_B_RED =>
        street_a_g <= '0';
        street_a_y <= '1';
        street_a_r <= '0';

        street_b_g <= '0';        
        street_b_y <= '0'; 
        street_b_r <= '1';

        if counter = YELLOW_CYCLES then
          next_state <= A_RED_B_GREEN;

        end if;

      when A_RED_B_GREEN =>
        street_a_g <= '0';
        street_a_y <= '0';
        street_a_r <= '1';

        street_b_g <= '1';
        street_b_y <= '0';
        street_b_r <= '0';

        if counter = GREEN_CYCLES then
          next_state <= A_RED_B_YELLOW;

        end if;

      when A_RED_B_YELLOW =>
        street_a_g <= '0';
        street_a_y <= '0';
        street_a_r <= '1';
        
        street_b_g <= '0';
        street_b_y <= '1';
        street_b_r <= '0';

        if counter = YELLOW_CYCLES then
          next_state <= DONE_STATE;

        end if;

      when DONE_STATE =>
        done <= '1';
        next_state <= IDLE_STATE;
        
    end case;
  end process CMB;
end behaviour;
