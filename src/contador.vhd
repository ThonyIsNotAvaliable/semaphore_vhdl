library ieee;
use ieee.std_logic_1164.all;

entity contador is 
  GENERIC (W : INTEGER := 10);
  port(
    RESET : in STD_LOGIC;
    INPUT : in STD_LOGIC;

    OUTPUT : out STD_LOGIC_VECTOR(W downto 0)
  );
end contador;

architecture structural of contador is
  signal clk_chain : STD_LOGIC_VECTOR(W + 1 downto 0);
  signal nQ : STD_LOGIC_VECTOR(W downto 0);
  signal internal_out : STD_LOGIC_VECTOR(W + 1 downto 0);
  signal xor_b : STD_LOGIC_VECTOR(5 downto 0);
begin

    clk_chain(0) <= INPUT;

    counter: for i in 0 to W generate
      flip_inst: entity work.d_flipflop
       port map(
          D => nQ(i),
          CLK => clk_chain(i),
          RST => RESET,
          Q => OUTPUT(i),
          notQ => nQ(i)
      );

      clk_chain(i + 1) <= nQ(i);
      
      end generate counter;
  
end architecture;
