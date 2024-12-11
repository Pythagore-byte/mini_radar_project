library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_telemetre_us_avalon is
    -- Aucun port pour un banc de test
end entity;

architecture Behavioral of tb_telemetre_us_avalon is
    -- Composant sous test
    component telemetre_us_avalon
        generic (
            Fclock : positive := 50E6 -- Fréquence d'horloge
        );
        port (
            clk         : in std_logic;              -- Horloge principale
            rst_n       : in std_logic;              -- Réinitialisation active bas
            echo        : in std_logic;              -- Signal echo reçu
            trig        : out std_logic;             -- Signal trig généré
            distance    : out std_logic_vector(9 downto 0);  -- Distance calculée (en cm)
            chipselect  : in std_logic;              -- Activation de l'IP
            Read_n      : in std_logic;              -- Lecture (active bas)
            readdata    : out std_logic_vector(31 downto 0) -- Données lues
        );
    end component;

    -- Signaux pour connecter au composant
    signal clk         : std_logic := '0';       -- Horloge principale
    signal rst_n       : std_logic := '1';       -- Réinitialisation active bas
    signal echo        : std_logic := '0';       -- Signal echo simulé
    signal trig        : std_logic;              -- Signal trig généré
    signal distance    : std_logic_vector(9 downto 0);   -- Distance calculée
    signal chipselect  : std_logic := '0';       -- Activation de l'IP
    signal Read_n      : std_logic := '1';       -- Lecture (active bas)
    signal readdata    : std_logic_vector(31 downto 0); -- Données lues
    signal done :boolean;

    -- Constantes
    constant CLK_PERIOD : time := 20 ns; -- Période d'horloge = 50 MHz
begin
    -- Instance du composant sous test
    uut : telemetre_us_avalon
        generic map (
            Fclock => 50E6
        )
        port map (
            clk         => clk,
            rst_n       => rst_n,
            echo        => echo,
            trig        => trig,
            distance    => distance,
            chipselect  => chipselect,
            Read_n      => Read_n,
            readdata    => readdata
        );

    -- Génération de l'horloge
    rst_n <= '0','1' after CLK_PERIOD;
	clk <= '0' when done else not Clk after (CLK_PERIOD / 2);

    -- Stimuli pour tester le composant
    stimuli : process
    begin
       
        -- Étape 2 : Simulation d'une mesure avec echo (durée 0.2 ms)
        wait until trig = '1'; -- Attendre que trig soit activé
        wait for 10 us; -- Signal trig activé pendant 10 µs
        echo <= '1'; -- Simuler le signal echo activé
        wait for 0.2 ms; -- Echo reste actif pendant 0.2 ms (distance ~34 cm)
        echo <= '0'; -- Fin de l'echo
        wait for 1 ms; -- Attendre le calcul de la distance

        -- Étape 3 : Lecture via Avalon-MM
        chipselect <= '1'; -- Activer l'IP
        Read_n <= '0'; -- Effectuer une lecture
        wait for 200 ns; -- Temps pour lire les données
        Read_n <= '1'; -- Fin de la lecture
        chipselect <= '0'; -- Désactiver l'IP
        wait for 1 ms; -- Pause avant la prochaine simulation

        -- Étape 4 : Simulation d'une autre mesure (durée 0.46 ms)
        wait until trig = '1'; -- Attendre que trig soit activé
        wait for 10 us; -- Signal trig activé pendant 10 µs
        echo <= '1'; -- Simuler le signal echo activé
        wait for 0.46 ms; -- Echo reste actif pendant 0.46 ms (distance ~7,8 cm)
        echo <= '0'; -- Fin de l'echo
        wait for 1 ms; -- Attendre le calcul de la distance

        chipselect <= '1'; -- Activer l'IP
        Read_n <= '0'; -- Effectuer une lecture
        wait for 20 ns; -- Temps pour lire les données
        Read_n <= '1'; -- Fin de la lecture
        chipselect <= '0'; -- Désactiver l'IP
        wait for 1 ms; -- Pause avant la prochaine simulation
        --etape 5
        wait until trig = '1'; -- Attendre que trig soit activé
        wait for 10 us; -- Signal trig activé pendant 10 µs
        echo <= '1'; -- Simuler le signal echo activé
        wait for 23.5 ms; -- Echo reste actif pendant 0.46 ms (distance ~400 cm)
        echo <= '0'; -- Fin de l'echo
        wait for 1 ms; -- Attendre le calcul de la distance

        -- Étape 5 : Lecture via Avalon-MM pour la nouvelle distance
        chipselect <= '1'; -- Activer l'IP
        Read_n <= '0'; -- Effectuer une lecture
        wait for 20 ns; -- Temps pour lire les données
        Read_n <= '1'; -- Fin de la lecture
        chipselect <= '0'; -- Désactiver l'IP
        wait for 1 ms; -- Pause avant la prochaine simulation

        -- Fin de la simulation
        wait for 10 ms;
        assert false report "Simulation terminée avec succès." severity note;
        done <= true;
        wait;
    end process;
end architecture;




