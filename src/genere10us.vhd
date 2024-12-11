library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity genere10us is 
generic(
        frequence_horloge : integer := 50000000;
        freq_10us : integer:=100000
    );

port(
    clk, rst : std_logic;
    tick_10us : out std_logic
);
end entity;

architecture RTL of genere10us is 
constant cycles_10us : integer := frequence_horloge / freq_10us; -- Nombre de cycles pour 10 µs
signal counter : integer range 0 to cycles_10us-1:=0;
begin 
p1 : process( clk, rst )
begin
    if rst='0' then
        counter<=0;
        tick_10us <='0';
    elsif rising_edge(clk) then
        if counter < cycles_10us-1 then
            counter <= counter+1;
            tick_10us <='0';
        else
            counter <=0;
            tick_10us <='1';
        end if ;
    end if ;
    
end process ; -- p1

end architecture;