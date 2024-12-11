library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_servomoteur_avalon is
    -- Pas de ports dans le testbench
end entity;

architecture Behavioral of tb_servomoteur_avalon is
    -- Composant sous test
    component servomoteur_avalon
        generic (
            Fclock : positive := 50E6 -- Fréquence d'horloge en Hz
        );
        port (
            clk         : in  std_logic;                -- Horloge principale
            reset_n     : in  std_logic;                -- Réinitialisation active bas
            chipselect  : in  std_logic;                -- Activation de l'IP
            write_n     : in  std_logic;                -- Signal d’écriture (actif bas)
            WriteData   : in  std_logic_vector(7 downto 0); -- Données d'entrée (position)
            commande    : out std_logic                -- Signal de commande
        );
    end component;

    -- Signaux pour connecter au composant
    signal clk         : std_logic := '0';       -- Horloge principale
    signal reset_n     : std_logic := '0';       -- Réinitialisation active bas
    signal chipselect  : std_logic := '0';       -- Sélection de l'IP
    signal write_n     : std_logic := '1';       -- Écriture (actif bas)
    signal WriteData   : std_logic_vector(7 downto 0) := (others => '0'); -- Données d'entrée
    signal commande    : std_logic;              -- Signal de commande généré
    signal done : boolean;

    -- Constantes
    constant CLK_PERIOD : time := 20 ns; -- Horloge 50 MHz (période = 20 ns)
begin
    -- Instance du composant sous test
    uut : servomoteur_avalon
        generic map (
            Fclock => 50E6 -- Fréquence d'horloge
        )
        port map (
            clk         => clk,
            reset_n     => reset_n,
            chipselect  => chipselect,
            write_n     => write_n,
            WriteData   => WriteData,
            commande    => commande
        );

    -- Génération de l'horloge
    reset_n <= '0','1' after CLK_PERIOD;
	clk <= '0' when done else not Clk after (CLK_PERIOD / 2);



    -- Stimuli pour tester le composant
    stimuli : process
    begin

        -- Étape 1 : Écriture de position 0° (1 ms)
        chipselect <= '1';
        write_n <= '0'; -- Écriture active
        WriteData <= "00000000"; -- Position = 0°
        wait for 20 ns;
        write_n <= '1'; -- Fin de l'écriture
        chipselect <= '0';
        wait for 20 ms; -- Attendre un cycle complet PWM (20 ms)
        -- Étape 2 : Écriture de position 0° (1 ms)
        chipselect <= '1';
        write_n <= '0'; -- Écriture active
        WriteData <= "00101101"; -- Position = 45°
        wait for 20 ns;
        write_n <= '1'; -- Fin de l'écriture
        chipselect <= '0';
        wait for 20 ms; -- Attendre un cycle complet PWM (20 ms)

        -- Étape 3 : Écriture de position 90° (1.5 ms)
        chipselect <= '1';
        write_n <= '0'; -- Écriture active
        WriteData <= "01011010"; -- Position = 90° (décimal = 90)
        wait for 20 ns;
        write_n <= '1'; -- Fin de l'écriture
        chipselect <= '0';
        wait for 20 ms; -- Attendre un cycle complet PWM (20 ms)

        -- Étape 4 : Écriture de position 180° (2 ms)
        chipselect <= '1';
        write_n <= '0'; -- Écriture active
        WriteData <= "10110100"; -- Position = 180° (décimal = 180)
        wait for 20 ns;
        write_n <= '1'; -- Fin de l'écriture
        chipselect <= '0';
        wait for 20 ms; -- Attendre un cycle complet PWM (20 ms)

        -- Fin de la simulation
        wait for 100 ns;
        assert false report "Simulation terminée avec succès." severity note;
        done <= true;
        wait;
    end process;
end architecture;
