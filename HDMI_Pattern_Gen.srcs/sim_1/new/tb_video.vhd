library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_video is
-- Testbench nie ma żadnych wejść i wyjść (Port), bo sam jest "światem zewnętrznym"
end tb_video;

architecture behavior of tb_video is
    -- 1. Deklaracja komponentu, który chcemy przetestować (nasz licznik od prowadzącego)
    component VideoTiming
        Port ( pixClk : in  STD_LOGIC;
               ResetN : in  STD_LOGIC;
               DE     : out  STD_LOGIC;
               HSync  : out  STD_LOGIC;
               VSync  : out  STD_LOGIC;
               PosX   : out  STD_LOGIC_VECTOR (9 downto 0);
               PosY   : out  STD_LOGIC_VECTOR (9 downto 0)
        );
    end component;

    -- 2. Wewnętrzne "kabelki" symulatora
    signal clk   : std_logic := '0';
    signal rst_n : std_logic := '0';
    signal de    : std_logic;
    signal hsync : std_logic;
    signal vsync : std_logic;
    signal posx  : std_logic_vector(9 downto 0);
    signal posy  : std_logic_vector(9 downto 0);

    -- Zegar 25 MHz = okres 40 nanosekund
    constant clk_period : time := 40 ns;
begin
    -- 3. Podłączenie testowanego modułu (UUT - Unit Under Test) do naszych kabelków
    UUT: VideoTiming port map (
        pixClk => clk,
        ResetN => rst_n,
        DE     => de,
        HSync  => hsync,
        VSync  => vsync,
        PosX   => posx,
        PosY   => posy
    );

    -- 4. Wirtualny generator zegara (odwraca stan z 0 na 1 co 20 nanosekund)
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- 5. Wirtualny przycisk Reset
    stim_proc: process
    begin
        rst_n <= '0';     -- Trzymaj wciśnięty reset...
        wait for 100 ns;  -- ...przez 100 nanosekund
        rst_n <= '1';     -- Puść reset, niech układ zacznie działać!
        
        -- Czekaj w nieskończoność
        wait;
    end process;
end behavior;