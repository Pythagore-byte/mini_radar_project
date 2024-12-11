library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity servomoteur is
    generic (
        Fclock : positive := 50E6 -- Fréquence d'horloge en Hz
    );
    port (
        clk       : in  std_logic;                 -- Horloge principale
        reset_n   : in  std_logic;                 -- Réinitialisation active bas
        position  : in  std_logic_vector(7 downto 0); -- Position (0-180°)
        commande  : out std_logic                 -- Signal de commande
    );
end entity;

architecture comportemental of servomoteur is
    -- Signaux internes
    signal compteur_20ms : integer range 0 to 1000000 := 0; -- Compte jusqu'à 20 ms (1,000,000 cycles)
    signal compteur_duree : integer range 0 to 100000 := 0; -- Compte la durée d'impulsion
    signal actif : std_logic := '0'; -- Indique si l'impulsion est active
    signal duree : integer := 0; -- Durée calculée pour la position
begin
    -- Process principal
    process(clk, reset_n)
    begin
        if reset_n = '0' then
            -- Réinitialisation des signaux et compteurs
            compteur_20ms <= 0;
            compteur_duree <= 0;
            actif <= '0';
            commande <= '0';
            duree <= 0;
        elsif rising_edge(clk) then
            -- Calcul de la durée (en cycles d'horloge)
            -- 1 ms = 50,000 cycles, 2 ms = 100,000 cycles
            duree <= 50000 + (to_integer(unsigned(position)) * 50000) / 180;

            if compteur_20ms < 1000000 - 1 then
                compteur_20ms <= compteur_20ms + 1;

                if actif = '1' then
                    -- Gestion de l'impulsion HIGH
                    if compteur_duree < duree - 1 then
                        compteur_duree <= compteur_duree + 1;
                        commande <= '1';
                    else
                        -- Fin de l'impulsion
                        actif <= '0';
                        commande <= '0';
                        compteur_duree <= 0;
                    end if;
                end if;
            else
                -- Fin du cycle de 20 ms, redémarrage
                compteur_20ms <= 0;
                actif <= '1'; -- Activer une nouvelle impulsion
            end if;
        end if;
    end process;

end architecture;