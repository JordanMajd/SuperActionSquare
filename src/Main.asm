; ========
;	Includes
; ========
.INCLUDE "Header.inc"
.INCLUDE "Init.asm"

; ========
; Macros
; ========
.MACRO LoadPalette
	STZ $2100

	LDA #:BG_Palette	; Bank address
	LDX #BG_Palette		; Bank offset
	LDY #(4*2)				; Bank length

	JSR DMAPalette
.ENDM

; ========
; Main
; ========
.BANK 0 SLOT 0
.ORG 0
.SECTION "MainCode"

Start:
	InitSystem
	LoadPalette

							; TODO: Set Acc to 8 bit?[JM]

							; DOCS: Color is 16-bit, 0bbbbbgggggrrrrr. [JM]
							; Split into 2 bytes, low byte(0bbbbbgg) and high byte (gggrrrrr).
	LDA #$04		; Load a color for the low byte.
	STA $2122		; Store low byte in Color Data Register.
	LDA #$FF		; Load a color for the high byte.
	STA $2122		; Store high byte in Color Data Register.

	LDA #$0F		; = 00001111
	STA $2100		; Turn on screen using the Screen Display Register.

Forever:
	JMP Forever

DMAPalette:
	 										;TODO: Preserve registers? [JM]
  STA	$4304						; Store data offset into DMA offset
  STX	$4302						; Store databank into DMA source bank
	STY	$4305						; Store size of data block DMA

	STZ $4300						; Set DMA mode
	LDA #$22						; Set dest register ($2122 - CGRAM write)
	STA $4301
	LDA #$01						; Init DMA transfer
	STA $420B

	RTS

VBlank:
	RTI

.ENDS

; ========
; Tiles
; ========
.BANK 1
.ORG 0
.SECTION "TileData"
	.INCLUDE "Tiles.inc"
.ENDS
