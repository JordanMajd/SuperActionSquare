; ========
;	Includes
; ========
.INCLUDE "Header.inc"
.INCLUDE "Init.asm"

; ========
; Macros
; ========
.MACRO LoadPalette
	LDA #\2
	STA $2121
	LDA #:\1					; Bank address
	LDX #\1						; Bank offset
	LDY #(\3 * 2)			; Bank length

	JSR DMAPalette
.ENDM

.MACRO LoadBlockToVRAM
	LDX #\2						; Initial address for upload
	STX $2116					; Set dest in VRAM Addr Reg

	LDA #:\1					; Bank address
	LDX #\1						; Bank offset
	LDY #\3						; Bank size (8 * color_depth(in bits) * number_of_characters)

	JSR LoadVRAM
.ENDM

; ========
; Main
; ========
.BANK 0 SLOT 0
.ORG 0
.SECTION "MainCode"

Start:
	InitSystem

	LoadPalette BGPalette, 0, 4
	LoadPalette SpritePalette, 128, 16

	LoadBlockToVRAM Tiles, $0000, $0020
	LoadBlockToVRAM Sprite, $0020, $0820

	JSR SetupSprites

	LDA #$80					; = 10000000
	STA $2115					; Init video port control reg, inc by 1

	LDX #$0400				; Tile location
	STX $2116 				; VRAM Addr Reg

	LDA #$01
	STA $2118 				;	VRAM data write reg

	JSR SetupVideo

	LDA #$80					; Enable NMI
	STA $4200

Forever:
	WAI									; Wait for interrupt

	LDA $0000 					; Load color from RAM
	INA									; Increment
	AND #$0F						; = 00001111
	STA $0000						; Store color to RAM

	JMP Forever

SetupVideo:
	STZ $2105						; Set video mode

	LDA #$04						; BG1s starting tile address ($0400
	STA $2107

	STZ $210B						; BG1s character location ($0000)

	LDA #$01
	STA $212C						; Enable BG1

	LDA #$F0						; Vertical BG Scroll? [JM]
	STA $210E
	LDA #$00						; Horizontal BG Scroll? [JM]
	STA $210E

	LDA #$0F						; = 00001111
	STA $2100						; Turn on screen using the Screen Display Register.

	RTS

SetupSprites:					; TODO: Set all sprites offscreen [JM]
	RTS

LoadVRAM:
	STX	$4302						; Store databank into DMA source bank
	STA	$4304						; Store data offset into DMA offset
	STY	$4305						; Store size of data block DMA

	LDA #$01						; #$01 = Word, normal increment.
	STA $4300						; Set DMA mode
	LDA #$18						; Set dest VRAM data write reg ($18 = $2118)
	STA $4301
	LDA #$01						; Set DMA channel
	STA $420B						; Init DMA transfer

	RTS

DMAPalette:
  STX	$4302						; Store databank into DMA source bank
	STA	$4304						; Store data offset into DMA offset
	STY	$4305						; Store size of data block DMA

											; #$00 = Byte, normal increment.
	STZ $4300						; Set DMA mode
	LDA #$22						; Set dest CGRAM reg ($22 = $2122)
	STA $4301
	LDA #$01						; Set DMA channel
	STA $420B						; Init DMA transfer

	RTS

VBlank
	STZ $2115						; Set video mode
	LDX #$0400					; Tile Address
	STX $2116						; VRAM Write addr

	LDA $0000						; Load color from RAM
	STA $2119						; Write to VRAM

	LDA $4210						; Clear NMI Flag

	RTI
.ENDS

; ========
; Tiles
; ========
.BANK 1 SLOT 0
.ORG 0
.SECTION "TileData"

	.INCLUDE "Tiles.inc"

Sprite:
	.INCBIN "biker.pic"

SpritePalette:
	.INCBIN "biker.clr"

.ENDS
