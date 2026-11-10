library ieee;
use ieee.std_logic_1164.all;
use std.env.stop;

entity tb_semaphore is
end tb_semaphore;

architecture sim of tb_semaphore is
  signal tb_clock : STD_LOGIC := '0';
  
  signal tb_reset : STD_LOGIC := '0';

  signal tb_start : STD_LOGIC := '0';

  signal tb_done : STD_LOGIC := '0';

  signal green_a : STD_LOGIC := '0';
  signal yellow_a : STD_LOGIC := '0';
  signal red_a : STD_LOGIC := '0';

  signal green_b : STD_LOGIC := '0';
  signal yellow_b : STD_LOGIC := '0';
  signal red_b : STD_LOGIC := '0';
  
begin

  controller : entity work.traffic_controller
  port map(
    clk => tb_clock,
    reset => tb_reset,
    start => tb_start,
    done => tb_done,

    street_a_g => green_a,
    street_a_y => yellow_a,
    street_a_r => red_a,

    street_b_g => green_b,
    street_b_y => yellow_b,
    street_b_r => red_b
  );


  clock_proc: process
    begin
      tb_clock <= '1';
      wait for 5 ns;
      tb_clock <= '0';
      wait for 5 ns;
  end process;

  stim_proc: process
  begin
      
    tb_reset <= '1';
    wait for 10 ns;

    tb_reset <= '0';
    
    wait for 10 ns; 

    tb_start <= '1';

    wait for 10 ns;

    tb_start <= '0';

    wait for 10 ns;

    wait until tb_done = '1';

    wait for 10 ns;

    stop;
    
  end process;  
  
end sim;
