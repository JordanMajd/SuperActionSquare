; ========
; Macros
; ========
.MACRO InitSystem
	SEI								; Set interrupt disable flag.

										; SNES boots in 6502 emulation mode.
										; Set Native mode:
	CLC								; 1. Clear carry flag.
	XCE								; 2. Exchange carry with emulation

	SEP	#$20					; Set		00100000. Set A to 8 bit.
	REP #$18					; Clear 00011000. Set X, Y to 16 bit, decimal mode off.

	JSR Init
.ENDM

; ========
; Init
; ========
.BANK 0 SLOT 0
.ORG 0
.SECTION "InitializeSystem" FREE
Init:
	PHP								; Push processor status register

	SEP #$20					; Set 	00110000: Set A to 8 bit.
	REP #$10					; Clear 00001000: Set X, Y to 16 bit

	LDA #$8F					; Force VBlank
	STA $2100					; DOCS: See 2-27-1 for $2100 PPU Reg [JM]

										; DOCS: See 2-26-1 for clearing registers
	STZ $2101					; Clear registers
	STZ $2102
	STZ $2103

	;STZ $2104				; TODO: OAM Data? [kmw]

	LDX #$1111
	;STZ $00,X

	STZ $2105
	STZ $2106
	STZ $2107
	STZ $2108
	STZ $2109
	STZ $210A
	STZ $210B
	STZ $201C

	STZ $210D					; clear low and high bytes [kmw]
	STZ $210D
	STZ $210E
	STZ $210E
	STZ $210F
	STZ $210F
	STZ $2110
	STZ $2110
	STZ $2111
	STZ $2111
	STZ $2112
	STZ $2112
	STZ $2113
	STZ $2113
	STZ $2114
	STZ $2114

	LDA #$80
	STA $2115

	STZ $2116
	STZ $2117

	;STZ $2118				; TODO: VRAM Data? [kmw]
	;STZ $2119				; TODO: VRAM Data? [kmw]

	STZ $211A

	STZ $211B					; TODO: Is the low/high byte backwards? [JM]
	LDA #$01
	STA $211B

	STZ $211C
	STZ $211C
	STZ $211D
	STZ $211D

	STZ $211E					; TODO: Is the low/high byte backwards? [JM]
	LDA #$01
	STA $211E

	STZ $211F
	STZ $211F
	STZ $211F
	STZ $2120
	STZ $2120

	STZ $2121

	;STZ $2122				; TODO: CG Data? [JM]

	STZ $2123
	STZ $2124
	STZ $2125
	STZ $2126
	STZ $2127
	STZ $2128
	STZ $2129
	STZ $212A
	STZ $212B
	STZ $212C
	STZ $212D
	STZ $212E

	LDA #$30
	STA $2130

	STZ $2131

	LDA #$E0
	STA $2132

	STZ $2133
	STZ $4200

	LDA #$FF
	STA $4201

	STZ $4202
	STZ $4203
	STZ $4204
	STZ $4205
	STZ $4206
	STZ $4207
	STZ $4208
	STZ $4209
	STZ $420A
	STZ $420B
	STZ $420C
	STZ $420D

	PLP								; Pull processor status register

	RTS
.ENDS
