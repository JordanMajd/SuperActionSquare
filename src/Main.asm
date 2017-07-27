.INCLUDE "Header.inc"
.INCLUDE "Init.asm"

.BANK 0 SLOT 0
.ORG 0
.SECTION "MainCode"

Start:
	InitSystem	; Initialize Macro

							; Force VBlank
	LDA #$80		; = 10000000
	STA $2100		; Turn off screen using the Screen Display Register.

							; Color is 16-bit, 0bbbbbgggggrrrrr.
							; Split into 2 bytes, low byte(0bbbbbgg) and high byte (gggrrrrr).
	LDA #$04		; Load a color for the low byte.
	STA $2122		; Store low byte in Color Data Register.
	LDA #$FF		; Load a color for the high byte.
	STA $2122		; Store high byte in Color Data Register.

	LDA #$0F		; = 00001111
	STA $2100		; Turn on screen using the Screen Display Register.

Forever:
	JMP Forever

.ENDS

