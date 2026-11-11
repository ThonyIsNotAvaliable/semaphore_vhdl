library ieee;
use ieee.std_logic_1164.all;

entity d_flipflop is 
  generic(W : NATURAL := 4);
  port(
    D : in STD_LOGIC;
    CLK : in STD_LOGIC;
    RST : in STD_LOGIC;

    Q : out STD_LOGIC;
    notQ : out STD_LOGIC
  );
end d_flipflop;

architecture structural of d_flipflop is
  signal notCLK : STD_LOGIC;
  signal master_Q : STD_LOGIC;
begin
  notCLK <= not CLK;

  master_inst: entity work.d_latch
    port map(
      D    => D,
      ENA  => notCLK,
      RST  => RST,
      Q    => master_Q,
      notQ => open -- open deixa a porta desconectada
    );

    slave_inst: entity work.d_latch
    port map(
      D    => master_Q,  
      ENA  => CLK,       
      RST  => RST,
      Q    => Q,
      notQ => notQ
    );
end architecture;
