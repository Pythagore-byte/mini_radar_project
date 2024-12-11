library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_mesure_echo is
-- Aucun port ici car c'est un banc de test
end entity;

architecture test of tb_mesure_echo is
   
    -- Signaux internes
    signal clk       : std_logic := '0';
    signal rst       : std_logic := '0';
    signal echo      : std_logic := '0';
    signal time_echo : integer range 0 to 1800000;
    signal valid     : std_logic;

    -- Constantes
    constant CLK_PERIOD : time := 20 ns; -- Horloge à 50 MHz (période = 20 ns)
begin
    -- Instance du composant sous test
    uut : entity work.mesure_echo
        port map (
            clk       => clk,
            rst       => rst,
            echo      => echo,
            time_echo => time_echo,
            valid     => valid
        );

    -- Génération de l'horloge (50 MHz)
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
        rst <= '0'; -- Activer le reset
        wait for 10 ns; -- Attendre 10 ns
        rst <= '1'; -- Désactiver le reset

        -- Étape 2 : Simuler un signal echo HIGH pendant 100 cycles
        wait for 100 ns; -- Temps d'attente avant de commencer la mesure
        echo <= '1'; -- Signal echo passe à HIGH
        wait for 2 us; -- Rester HIGH pendant 2 us (environ 100 cycles à 50 MHz)
        echo <= '0'; -- Signal echo passe à LOW

        -- Étape 3 : Attendre la fin de la mesure
        wait for 1 us; -- Laisser le composant terminer sa mesure
        echo <='1';
        wait for 0.2 ms;
        echo <= '0'; -- Signal echo passe à LOW
        wait for 1 us;
        echo <='1';
        wait for 23.5 ms;
        echo <= '0'; -- Signal echo passe à LOW
        wait for 1 us;


        -- Étape 4 : Arrêter la simulation
        wait for 1 us;
        assert false report "Simulation terminée." severity note;
        wait;
    end process;
end architecture;
