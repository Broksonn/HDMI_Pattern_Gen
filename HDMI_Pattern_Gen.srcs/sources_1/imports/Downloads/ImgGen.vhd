--   Simple video image generator: animated square and test patterns
-----------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ImgGen is
    Port (
           Clk  : in STD_LOGIC;
           RstN : in STD_LOGIC;
           Mode : in STD_LOGIC_VECTOR(1 downto 0); -- DODANE (wybór trybu)
           PosX : in  STD_LOGIC_VECTOR (9 downto 0);
           PosY : in  STD_LOGIC_VECTOR (9 downto 0);
           R    : out STD_LOGIC_VECTOR (7 downto 0);
           G    : out STD_LOGIC_VECTOR (7 downto 0);
           B    : out STD_LOGIC_VECTOR (7 downto 0)
        );
end ImgGen;

architecture Behavioral of ImgGen is

    -- Constants
    constant MODE_WIDTH  : integer := 640;
    constant MODE_HEIGHT : integer := 480;

    -- Animated white square moves every frame
    constant SQ_SIZE : integer := MODE_HEIGHT / 10;
    -- position of left / top corner:
    signal Sq_posX : signed (10 downto 0) := (others => '0');
    signal Sq_posY : signed (10 downto 0) := (others => '0');
    -- anim. speed; 1 px per frame
    signal Sq_dX : signed (1 downto 0) := to_signed( 1,  2 );
    signal Sq_dY : signed (1 downto 0) := to_signed( 1,  2 );
    -- aux signals for out-of-range detection
    signal next_posX, next_posY : signed (10 downto 0);
    
    -- PosX, PosY: conversion of std_logic_vector inputs to unsigned
    signal sPosX, sPosY : signed(10 downto 0);

begin
    sPosX <= signed( '0' & posX );
    sPosY <= signed( '0' & posY );

    -- RGB outputs (ZMIENIONY PROCES - MULTIPLEKSER OBRAZÓW)
    process( sPosX, sPosY, Sq_posX, Sq_posY, PosX, Mode )
    begin
        case Mode is
            -- ==========================================
            -- TRYB 00: ORYGINALNY KOD PROFESORA (Gradienty + Kwadrat)
            -- ==========================================
            when "00" =>
                if sPosX >= Sq_posX and sPosX < Sq_posX + SQ_SIZE and
                   sPosY >= Sq_posY and sPosY < Sq_posY + SQ_SIZE     then
                    -- inside white square
                    R <= (others => '1');
                    G <= (others => '1');
                    B <= (others => '1');
                else
                    -- some color background
                    if sPosY < MODE_HEIGHT / 3 then
                        R <= PosX( 7 downto 0 );
                        G <= (others => '0');
                        B <= (others => '0');
                    elsif sPosY < MODE_HEIGHT * 2 / 3 then
                        R <= (others => '0');
                        G <= not PosX( 7 downto 0 );
                        B <= (others => '0');
                    else
                        R <= (others => '0');
                        G <= (others => '0');
                        B <= PosX( 7 downto 0 );
                    end if;
                end if;

            -- ==========================================
            -- TRYB 01: PIONOWE PASY KOLOROWE (Color Bars)
            -- ==========================================
            when "01" =>
                R <= (others => PosX(8));
                G <= (others => PosX(7));
                B <= (others => PosX(6));

            -- ==========================================
            -- TRYB 10: SZACHOWNICA (Checkerboard 32x32)
            -- ==========================================
            when "10" =>
                if (PosX(5) xor PosY(5)) = '1' then
                    R <= (others => '1'); G <= (others => '1'); B <= (others => '1'); -- Biały
                else
                    R <= (others => '0'); G <= (others => '0'); B <= (others => '0'); -- Czarny
                end if;

            -- ==========================================
            -- TRYB 11: PUSTY EKRAN (Bezpiecznik)
            -- ==========================================
            when others =>
                R <= (others => '0'); G <= (others => '0'); B <= (others => '0');
        end case;
    end process;

    -- Animation of the square (BEZ ZMIAN)
    next_posX <= Sq_posX + Sq_dX;
    next_posY <= Sq_posY + Sq_dY;
    process( Clk )
    begin
        if rising_edge( Clk ) then
            if RstN = '0' then
                Sq_posX <= (others => '0');
                Sq_posY <= (others => '0');
                Sq_dX <= to_signed( 1,  2 );
                Sq_dY <= to_signed( 1,  2 );
            elsif sPosX = MODE_WIDTH - 1  and  sPosY = MODE_HEIGHT - 1 then     -- once per frame
                -- update positionX
                if next_posX < 0 then
                    -- bounce from left
                    Sq_posX <= ( others => '0' );
                    Sq_dX <= to_signed( 1,  2 );
                elsif next_posX > MODE_WIDTH - SQ_SIZE then
                    -- bounce from right
                    Sq_posX <= to_signed( MODE_WIDTH - SQ_SIZE, 11 );
                    Sq_dX <= to_signed( -1,  2 );
                else
                    -- normal move
                    Sq_posX <= next_posX;
                end if;
                -- update position Y
                if next_posY < 0 then
                    -- bounce from top
                    Sq_posY <= ( others => '0' );
                    Sq_dY <= to_signed( 1,  2 );
                elsif next_posY > MODE_HEIGHT - SQ_SIZE then
                    -- bounce from bottom
                    Sq_posY <= to_signed( MODE_HEIGHT - SQ_SIZE, 11 );
                    Sq_dY <= to_signed( -1,  2 );
                else
                    -- normal move
                    Sq_posY <= next_posY;
                end if;
            end if;
        end if;
    end process;

end Behavioral;