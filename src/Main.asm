;== Main.asm ==
; Includes
.INCLUDE "Header.inc"
.INCLUDE "InitSNES.asm"

;== Start Start ==

.BANK 0 SLOT 0
.ORG 0
.SECTION "MainCode"

Start:
	InitSNES

	stz $2121		; Screen color, write in binary or hex.
	lda #$F0		; = 00011111
	sta $2122
	stz $2122		; second byte has no data so write 0.

	lda #$0F		; = 00001111
	sta $2100		; Turn screen on with full brightness.

Forever:
	jmp Forever

.ENDS

;== End Start ==
