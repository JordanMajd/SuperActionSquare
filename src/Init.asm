; ========
; Macros
; ========
.MACRO InitSystem
  SEI               ; Set interrupt disable flag.

                    ; SNES boots in 6502 emulation mode.
                    ; Set Native mode:
  CLC               ; 1. Clear carry flag.
  XCE               ; 2. Exchange carry with emulation

  SEP  #$20         ; Set    00100000. Set A to 8 bit.
  REP #$18          ; Clear 00011000. Set X, Y to 16 bit, decimal mode off.

  JSR Init
.ENDM

; ========
; Init
; ========
.BANK 0 SLOT 0
.ORG 0
.SECTION "InitializeSystem" FREE

Init:
  PHP               ; Push processor status register

  SEP #$20          ; Set   00110000: Set A to 8 bit.
  REP #$10          ; Clear 00001000: Set X, Y to 16 bit

  LDA #$8F          ; Force VBlank
  STA $2100         ; DOCS: See 2-27-1 for $2100 PPU Reg [JM]

                    ; DOCS: See 2-26-1 for clearing registers
  STZ $2101         ; Clear registers
  STZ $2102
  STZ $2103

  ;STZ $2104        ; TODO: OAM Data? [kmw]

  LDX #$2105        ; TODO: Expand to start at 2101 without bugging on STZ $2104 [JM]
_ClearReg0:         ; Clear $2105-$201C
  STZ $0000,X
  INX
  CPX #$210D
  BNE _ClearReg0

_ClearReg1:          ; Clear $201D-$2114
  STZ $0000,X
  STZ $0000,X
  INX
  CPX $2115
  BNE _ClearReg1

  LDA #$80
  STA $2115

  STZ $2116
  STZ $2117

  ;STZ $2118        ; TODO: VRAM Data? [kmw]
  ;STZ $2119        ; TODO: VRAM Data? [kmw]

  STZ $211A

  STZ $211B         ; TODO: Is the low/high byte backwards? [JM]
  LDA #$01
  STA $211B

  STZ $211C
  STZ $211C
  STZ $211D
  STZ $211D

  STZ $211E         ; TODO: Is the low/high byte backwards? [JM]
  LDA #$01
  STA $211E

  STZ $211F
  STZ $211F
  STZ $211F
  STZ $2120
  STZ $2120

  STZ $2121

  ;STZ $2122        ; TODO: CG Data? [JM]

  LDX #$2123
_ClearReg2          ; Clear $2123-$212E
  STZ $0000,X
  INX
  CPX #$212F
  BNE _ClearReg2

  LDA #$30
  STA $2130

  STZ $2131

  LDA #$E0
  STA $2132

  STZ $2133
  STZ $4200

  LDA #$FF
  STA $4201

  LDX #$4202
_ClearReg3          ; Clear $4202-$420D
  STZ $0000,X
  INX
  CPX #$420E
  BNE _ClearReg3

  PLP                ; Pull processor status register

  RTS
.ENDS
