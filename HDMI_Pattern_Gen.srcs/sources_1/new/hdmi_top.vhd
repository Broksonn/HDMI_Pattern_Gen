library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity hdmi_top is
    Port (
        -- Główny zegar różnicowy z płyty (100 MHz)
        CLK_100MHz_P : in STD_LOGIC;
        CLK_100MHz_N : in STD_LOGIC;

        -- PRZEŁĄCZNIKI (DODANE)
        SW : in STD_LOGIC_VECTOR(1 downto 0); 

        -- Piny złącza HDMI na płycie rozszerzeń
        HDMI_CK_P : out STD_LOGIC;
        HDMI_CK_N : out STD_LOGIC;
        HDMI_D2_P : out STD_LOGIC;
        HDMI_D2_N : out STD_LOGIC;
        HDMI_D1_P : out STD_LOGIC;
        HDMI_D1_N : out STD_LOGIC;
        HDMI_D0_P : out STD_LOGIC;
        HDMI_D0_N : out STD_LOGIC
    );
end hdmi_top;

architecture Behavioral of hdmi_top is

    component clk_wiz_0
    port (
      clk_in1_p : in std_logic;
      clk_in1_n : in std_logic;
      clk_out1  : out std_logic; 
      clk_out2  : out std_logic; 
      reset     : in std_logic;
      locked    : out std_logic
    );
    end component;

    component VideoTiming
        Port ( pixClk : in  STD_LOGIC;
               ResetN : in  STD_LOGIC;
               DE     : out STD_LOGIC;
               HSync  : out STD_LOGIC;
               VSync  : out STD_LOGIC;
               PosX   : out STD_LOGIC_VECTOR(9 downto 0);
               PosY   : out STD_LOGIC_VECTOR(9 downto 0) );
    end component;

    component ImgGen
        Port ( Clk  : in  STD_LOGIC;
               RstN : in  STD_LOGIC;
               Mode : in  STD_LOGIC_VECTOR(1 downto 0); -- DODANE
               PosX : in  STD_LOGIC_VECTOR(9 downto 0);
               PosY : in  STD_LOGIC_VECTOR(9 downto 0);
               R    : out STD_LOGIC_VECTOR(7 downto 0);
               G    : out STD_LOGIC_VECTOR(7 downto 0);
               B    : out STD_LOGIC_VECTOR(7 downto 0) );
    end component;

    component HDMI_TX_wrap
        Port (
            pxClk     : in  STD_LOGIC;
            pxClkX5   : in  STD_LOGIC;
            ResetN    : in  STD_LOGIC;
            DE        : in  STD_LOGIC;
            HSync     : in  STD_LOGIC;
            VSync     : in  STD_LOGIC;
            R         : in  STD_LOGIC_VECTOR( 7 downto 0 );
            G         : in  STD_LOGIC_VECTOR( 7 downto 0 );
            B         : in  STD_LOGIC_VECTOR( 7 downto 0 );
            HDMI_D0_P : out STD_LOGIC;
            HDMI_D0_N : out STD_LOGIC;
            HDMI_D1_P : out STD_LOGIC;
            HDMI_D1_N : out STD_LOGIC;
            HDMI_D2_P : out STD_LOGIC;
            HDMI_D2_N : out STD_LOGIC;
            HDMI_CK_P : out STD_LOGIC;
            HDMI_CK_N : out STD_LOGIC
        );
    end component;

    signal clk_25M, clk_125M, pll_locked : std_logic;
    signal sync_h, sync_v, vde : std_logic;
    signal pos_x, pos_y : std_logic_vector(9 downto 0);
    signal red, green, blue : std_logic_vector(7 downto 0);
    
    attribute mark_debug : string;
    attribute mark_debug of pos_x  : signal is "true";
    attribute mark_debug of pos_y  : signal is "true";
    attribute mark_debug of sync_h : signal is "true";
    attribute mark_debug of sync_v : signal is "true";
    attribute mark_debug of vde    : signal is "true";

begin

    CLK_GEN : clk_wiz_0 port map (
       clk_in1_p => CLK_100MHz_P,
       clk_in1_n => CLK_100MHz_N,
       clk_out1  => clk_25M,
       clk_out2  => clk_125M,
       reset     => '0',
       locked    => pll_locked
    );

    TIMING : VideoTiming port map (
        pixClk => clk_25M,
        ResetN => pll_locked,
        DE     => vde,
        HSync  => sync_h,
        VSync  => sync_v,
        PosX   => pos_x,
        PosY   => pos_y
    );

    PICTURE : ImgGen port map (
        Clk  => clk_25M,
        RstN => pll_locked,
        Mode => SW,         -- PODPIĘCIE PRZEŁĄCZNIKÓW (DODANE)
        PosX => pos_x,
        PosY => pos_y,
        R    => red,
        G    => green,
        B    => blue
    );

    HDMI_OUT : HDMI_TX_wrap port map (
        pxClk     => clk_25M,
        pxClkX5   => clk_125M,
        ResetN    => pll_locked,
        DE        => vde,
        HSync     => sync_h,
        VSync     => sync_v,
        R         => red,
        G         => green,
        B         => blue,
        HDMI_D0_P => HDMI_D0_P,
        HDMI_D0_N => HDMI_D0_N,
        HDMI_D1_P => HDMI_D1_P,
        HDMI_D1_N => HDMI_D1_N,
        HDMI_D2_P => HDMI_D2_P,
        HDMI_D2_N => HDMI_D2_N,
        HDMI_CK_P => HDMI_CK_P,
        HDMI_CK_N => HDMI_CK_N
    );

end Behavioral;