Tiles:
    .db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .db $00, $FF, $00, $81, $00, $81, $00, $81, $00, $81, $00, $81, $00, $81, $00, $FF

BG_Palette:
    .db $00, $00, $00, $7C, $E0, $03, $1F, $00
    ;Color 0 = black
    ;Color 1 = blue
    ;Color 2 = green
    ;Color 3 = red
    ;high and low bytes are backwards
    ;0bbbbbgggggrrrrr = gggrrrrr0bbbbbgg



;0,0 = 7F7F = color 0 = black
;1,0 = FF7F = color 3 = blue
;0,1 = 7FFF = color 3 = green
;1,1 = FFFF = color 2 = red

; 000000000000000 = black line
; 111111110000000 = blue line
; 000000001111111 = green line
; 111111111111111 = red line

; 0000000010000001
