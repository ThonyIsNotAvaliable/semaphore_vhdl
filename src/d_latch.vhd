library ieee;
use ieee.std_logic_1164.all;

entity d_latch is 
  generic(W : NATURAL := 4);
  port(
    D : in STD_LOGIC;
    ENA : in STD_LOGIC;
    RST : in STD_LOGIC;

    Q : out STD_LOGIC;
    notQ : out STD_LOGIC
  );
end d_latch;

architecture structural of d_latch is
  signal notD : STD_LOGIC;
  signal nandD : STD_LOGIC;
  signal nandCLK: STD_LOGIC;
  signal Qnand, notQnand : STD_LOGIC;
  signal notRst : STD_LOGIC;
begin
  notD <= not D;
  notRst <= not RST;

  nandD <= not (ENA and D and notRst);
  nandCLK <= not (ENA and notD);

  Qnand <= not (nandD and notQnand);

  notQnand <= not (nandCLK and Qnand and notRst);

  Q <= Qnand;

  notQ <= notQnand;

end architecture;
