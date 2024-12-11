library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity servomoteur_avalon is
    generic (
        Fclock : positive := 50E6 -- Fréquence d'horloge en Hz
    );
    port (
        -- Entrées Avalon-MM
        clk         : in  std_logic;                -- Horloge principale
        reset_n     : in  std_logic;                -- Réinitialisation active bas
        chipselect  : in  std_logic;                -- Activation de l'IP
        write_n     : in  std_logic;                -- Signal d’écriture (actif bas)
        WriteData   : in  std_logic_vector(31 downto 0); -- Données d'entrée (position)
        
        -- Sortie
        commande    : out std_logic                -- Signal de commande
    );
end entity;

architecture comportemental of servomoteur_avalon is
    -- Signaux internes
    signal compteur_20ms : integer range 0 to 1000000 := 0; -- Compteur pour 20 ms
    signal compteur_duree : integer range 0 to 100000 := 0; -- Compteur pour la durée d'impulsion
    signal actif : std_logic := '0'; -- Indique si l'impulsion est active
    signal position_internal : integer range 0 to 180 := 0; -- Position interne (0-180°)
begin
    -- Process principal
    process(clk, reset_n)
        variable duree : integer; -- Durée calculée localement pour éviter les conflits
    begin
        if reset_n = '0' then
            -- Réinitialisation des signaux et compteurs
            compteur_20ms <= 0;
            compteur_duree <= 0;
            actif <= '0';
            commande <= '0';
        elsif rising_edge(clk) then
            -- Calcul de la durée (en cycles d'horloge) à partir de position_internal
            duree := 50000 + (position_internal * 50000) / 180;

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

    -- Gestion des écritures Avalon-MM
    process(clk, reset_n)
    begin
        if reset_n = '0' then
            position_internal <= 0; -- Réinitialisation à la position neutre (0°)
        elsif rising_edge(clk) then
            if chipselect = '1' and write_n = '0' then
                -- Capture de la position écrite via WriteData
                position_internal <= to_integer(unsigned(WriteData));
            end if;
        end if;
    end process;
end architecture;
