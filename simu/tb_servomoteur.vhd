library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_servomoteur is
    -- Pas de ports pour un test bench
end entity;

architecture Behavioral of tb_servomoteur is
    -- Composant sous test
    component servomoteur
        generic (
            Fclock : positive := 50E6 -- Fréquence d'horloge en Hz
        );
        port (
            clk       : in  std_logic;                 -- Horloge principale
            reset_n   : in  std_logic;                 -- Réinitialisation active bas
            position  : in  std_logic_vector(7 downto 0); -- Position (0-180°)
            commande  : out std_logic                 -- Signal de commande
        );
    end component;

    -- Signaux internes pour connecter au DUT
    signal clk       : std_logic := '0';       -- Horloge
    signal reset_n   : std_logic := '0';       -- Réinitialisation active bas
    signal position  : std_logic_vector(7 downto 0) := (others => '0'); -- Position
    signal commande  : std_logic;             -- Signal généré

    -- Constantes
    constant CLK_PERIOD : time := 20 ns; -- Horloge 50 MHz (période = 20 ns)
begin
    -- Instance du composant sous test
    uut : servomoteur
        generic map (
            Fclock => 50E6 -- Fréquence d'horloge
        )
        port map (
            clk       => clk,
            reset_n   => reset_n,
            position  => position,
            commande  => commande
        );

    -- Génération de l'horloge
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    -- Stimuli
    stimuli : process
    begin
        -- Étape 1 : Réinitialisation
        reset_n <= '0'; -- Réinitialisation
        wait for 100 ns;
        reset_n <= '1'; -- Fin de la réinitialisation

        -- Étape 2 : Tester position = 0° (1 ms = 50,000 cycles)
        position <= std_logic_vector(to_unsigned(0, 8)); -- 0°
        wait for 20 ms; -- Attendre un cycle complet

        -- Étape 3 : Tester position = 90° (1.5 ms = 75,000 cycles)
        position <= std_logic_vector(to_unsigned(90, 8)); -- 90°
        wait for 20 ms; -- Attendre un cycle complet

        -- Étape 4 : Tester position = 180° (2 ms = 100,000 cycles)
        position <= std_logic_vector(to_unsigned(180, 8)); -- 180°
        wait for 20 ms; -- Attendre un cycle complet

        -- Fin de la simulation
        wait for 50 ms;
        assert false report "Simulation terminée avec succès." severity note;
        wait;
    end process;
end architecture;