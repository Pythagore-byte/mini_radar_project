library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mesure_echo is
    port (
        clk       : in  std_logic;               -- Signal d'horloge
        rst       : in  std_logic;               -- Signal de réinitialisation
        echo      : in  std_logic;               -- Signal echo du capteur
        time_echo : out integer range 0 to 1800000; -- Temps mesuré en cycles 2d = vxt => t = 2d/v avec v = 340m/s , et d = 400 cm( distance max mesurable par le capteur)
        -- donc t (aller-retour)= 8/340 = 0,0235 s = 23,5ms , donc pour trouver le temps ecoule , on fait un 
        --compteur qui qui compte jusqu'a frequence_horloge * t = 1176470 , donc en comptant jusqu'a 1176470 
        -- j'aurais deja le temps aller-retour , donc temps pendant lequel echo est a l'etat haut., ici
        -- j'ai choisi 2000000 pour une marge au cas ou. 
        valid     : out std_logic                -- Indique que la mesure est valide
    );
end entity;

architecture Behavioral of mesure_echo is
    signal counter      : integer range 0 to 1800000 := 0; -- Compteur interne = 40ms
    signal measuring    : std_logic := '0';                -- Indique si on mesure
    signal echo_prev    : std_logic := '0';                -- État précédent de echo
begin
    process(clk, rst)
    begin
        if rst = '0' then
            counter <= 0;
            measuring <= '0';
            echo_prev <= '0';
            time_echo <= 0;
            valid <= '0';
        elsif rising_edge(clk) then
            -- Détecter les transitions de echo
            if echo = '1' and echo_prev = '0' then
                -- Début de la mesure (front montant)
                measuring <= '1';
                counter <= 0; -- Réinitialiser le compteur
                valid <= '0'; -- Réinitialiser valid
            elsif echo = '0' and echo_prev = '1' then
                -- Fin de la mesure (front descendant)
                measuring <= '0';
                time_echo <= counter; -- Sauvegarder la durée mesurée
                valid <= '1'; -- Indiquer que la mesure est valide
            end if;
            -- Incrémenter le compteur si la mesure est active
            if measuring = '1' then
                counter <= counter + 1;
            end if;

            -- Mettre à jour l'état précédent de echo
            echo_prev <= echo;
        end if;
    end process;
end architecture;
