
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_10us is 

end entity;

architecture test of  tb_10us is
signal clk, rst , tick: std_logic:='0';
signal done :boolean :=False;


begin


    ins: entity work.genere10us port map(
        clk=> clk, 
        rst=>rst,
        tick_10us=>tick
    );

    rst <='1', '0' after 5 ns;
    clk <='0' when done else not clk after 5 ns;

end architecture;