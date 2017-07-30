Tiles:
    ; Blank Tile, because VRAM is initialized to 0, unused tiles will use tile 0.
    .db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    ; Action Square
    .db $00, $FF, $00, $81, $00, $81, $00, $81, $00, $81, $00, $81, $00, $81, $00, $FF

BG_Palette:
    ;Color 0 = Black
    ;Color 1 = Blue
    ;Color 2 = Green
    ;Color 3 = Red
    ;high and low bytes are backwards
    ;0bbbbbgggggrrrrr = gggrrrrr0bbbbbgg
    .db $00, $00, $00, $7C, $E0, $03, $1F, $00

    ; Tile color selection:
    ; 0,0 = 7F7F = color 0 = black
    ; 1,0 = FF7F = color 3 = blue
    ; 0,1 = 7FFF = color 3 = green
    ; 1,1 = FFFF = color 2 = red

    ; 000000000000000 = black line
    ; 111111110000000 = blue line
    ; 000000001111111 = green line
    ; 111111111111111 = red line
