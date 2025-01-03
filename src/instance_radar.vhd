
LIBRARY ieee;
USE ieee.std_logic_1164.all; 
USE ieee.numeric_std.all;



entity instance_radar is
    port(
        clk  :in  std_logic;
        rst_n : in std_logic;
        LEDR : out std_logic_vector(9 downto 0);
        commande : out std_logic

    );
end entity;




architecture struct of instance_radar is 

component system_radar is
    port (
        clk_clk                                           : in  std_logic                    := 'X'; -- clk
        reset_reset_n                                     : in  std_logic                    := 'X'; -- reset_n
        ip_telemetre_us_0_conduit_end_readdata            : out std_logic_vector(9 downto 0);        -- readdata
        new_component_0_conduit_end_writeresponsevalid_n : out std_logic                            -- writeresponsevalid_n
    );
end component system_radar;
begin
    u0 : system_radar
    port map (
        clk_clk                                           => clk,                                           --                           clk.clk
        reset_reset_n                                     => rst_n,                                     --                         reset.reset_n
        ip_telemetre_us_0_conduit_end_readdata            => LEDR,            -- ip_telemetre_us_0_conduit_end.readdata
        new_component_0_conduit_end_writeresponsevalid_n => commande  --  ip_servomoteur_0_conduit_end.writeresponsevalid_n
    );



end architecture;








