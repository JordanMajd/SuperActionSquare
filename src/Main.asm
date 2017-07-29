.INCLUDE "Header.inc"
.INCLUDE "Init.asm"

.BANK 0 SLOT 0
.ORG 0
.SECTION "MainCode"

VBlank:
	RTI

Start:
	InitSystem	; Initialize Macro
							; DOCS: Color is 16-bit, 0bbbbbgggggrrrrr. [JM]
							; Split into 2 bytes, low byte(0bbbbbgg) and high byte (gggrrrrr).

							; TODO: Set Acc to 8 bit?[JM]

	LDA #$04		; Load a color for the low byte.
	STA $2122		; Store low byte in Color Data Register.
	LDA #$FF		; Load a color for the high byte.
	STA $2122		; Store high byte in Color Data Register.

	LDA #$0F		; = 00001111
	STA $2100		; Turn on screen using the Screen Display Register.

Forever:
	JMP Forever

.ENDS

.BANK 1
.ORG 0
.SECTION "TileData"
	.INCLUDE "Tiles.inc"
.ENDS
