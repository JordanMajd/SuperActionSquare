; ========
; Includes
; ========
.INCLUDE "Header.inc"
.INCLUDE "Init.asm"
; ========
; Macros
; ========
.MACRO LoadPalette
  LDA #\2
  STA $2121
  LDA #:\1          ; Bank address
  LDX #\1            ; Bank offset
  LDY #(\3 * 2)      ; Bank length

  JSR DMAPalette
.ENDM

;----------------------------------------------------------
; Macro  | LoadBlockToVRAM
; 1      | Label of bank address
; 2      | Address for upload
; 3      | Bank size
;----------------------------------------------------------
.MACRO LoadBlockToVRAM
  LDX #\2            ; Initial address for upload
  STX $2116          ; Set dest in VRAM Addr Reg

  LDA #:\1           ; Bank address
  LDX #\1            ; Bank offset
  LDY #\3            ; Bank size (8 * color_depth(in bits) * number_of_characters)

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

  LoadBlockToVRAM  Init, $0000, $FFFF     ; Clear VRAM
                                          ; Init label is at $0000 (Bank 0, Slot 0)
                                          ;  Write to start of VRAM
                                          ; Write 64k - 1 bytes

  LoadPalette BGPalette, 0, 4
  LoadPalette SpritePalette, 128, 16

  LoadBlockToVRAM Tiles, $0000, $0020
  LoadBlockToVRAM Sprite, $0020, $0800

  JSR SetupSprites

                         ; Draw sprite 1 to middle of screen
  LDA #(256 / 2 - 16)    ; Screen / 2 - half sprite
  STA $0000              ; Sprite X coord, stored in RAM
  LDA #(224 / 2 - 16)    ; Screen / 2 - half sprite
  STA $0001              ; Sprite Y coord, stored in RAM


  LDA #$02          ; Tile 2 is the sprite
  STA $0002         ; Sprite starting tile #, stored in RAM
  LDA #$70          ; = 01110000
  STA $0003         ; VHOOPPPC (Vert, Horzontal, Order, Palette, Starting Tile #), stored in RAM

  LDA #$54          ; Clear
  STA $0200         ; Sprite X- MSB

                    ; Draw BG1 tile to screen
                    ; TODO: Replace with Tilemap? [JM]
  LDA #$80          ; = 10000000
  STA $2115         ; Init video port control reg, inc by 1

  LDX #$0400        ; Tile location
  STX $2116         ; VRAM Addr Reg

  LDA #$01
  STA $2118         ;  VRAM data write reg

  JSR SetupVideo

  LDA #$80          ; Enable NMI
  STA $4200

Forever:
  WAI               ; Wait for interrupt

                    ; Cycle BG1 pal color
  ;LDA $0000        ; Load color from RAM
  ;INA              ; Increment
  ;AND #$0F         ; = 00001111
  ;STA $0000        ; Store color to RAM

  JMP Forever

SetupVideo:
  STZ $2105         ; Set video mode

  LDA #$04          ; BG1s starting tile address ($0400)
  STA $2107

  STZ $210B         ; BG1s character location ($0000)

  LDA #$F0          ; Vertical BG Scroll
  STA $210E
  LDA #$00
  STA $210E

  LDA #$F0          ; Horizontal BG Scroll
  STA $210D
  LDA #$00
  STA $210D
                    ; DMA sprite data from RAM to OAM
                    ; TODO: Macro or subroutine? [JM]
                    ; TODO: Split writes into two lines to be explicit? [JM]
  LDY #$0400        ; Write $00 to $4300 & $04 to $4301
  STY $4300         ; Set DMA Mode, dest PPU, auto inc

  STZ $4302         ; DMA Source Address Registers
  STZ $4303         ; DMA Source Address Registers

  LDY #$0220
  STY $4305         ; DMA Size Register (Low)

  LDA #$7E          ; CPU address 7E:0000 - Work RAM
  STA $4304         ; DMA Offset (Source Address Registers)

  LDA #$01
  STA $420B         ; Start Transfer

  LDA #$A0
  STA $2101         ; Use 32x32 sprites

  LDA #$11          ; Enable BG1 & Sprites
  STA $212C

  LDA #$0F          ; = 00001111
  STA $2100         ; Turn on screen using the Screen Display Register.

  RTS

SetupSprites:       ; TODO: Set all sprites offscreen [JM]

  LDX #$0000        ; Loop through table one sprites ($0000 - $0200)
  LDA #$01          ;  To set their X coord to offscreen value
_offscreen:
  STA $0000, X      ; Set X coordinate to -255
  INX               ; Increment by 4 bytes
  INX               ; TODO: This is stupid, must be better way [JM]
  INX
  INX
  CPX #$0200
  BNE _offscreen

                    ; Loop through table two sprites ($0200 - $0220)
  LDY #$5555        ; To set their X SMB
_setXMSB:
  STY $0000, X      ;  Set X coords SMB
  INX               ; Increment by 2 bytes
  INX
  CPX #$0220
  BNE _setXMSB

  RTS

LoadVRAM:
  STX  $4302         ; Store databank into DMA source bank
  STA  $4304         ; Store data offset into DMA offset
  STY  $4305         ; Store size of data block DMA

  LDA #$01           ; #$01 = Word, normal increment.
  STA $4300          ; Set DMA mode
  LDA #$18           ; Set dest VRAM data write reg ($18 = $2118)
  STA $4301
  LDA #$01           ; Set DMA channel
  STA $420B          ; Init DMA transfer

  RTS

DMAPalette:
  STX $4302          ; Store databank into DMA source bank
  STA $4304          ; Store data offset into DMA offset
  STY $4305          ; Store size of data block DMA

                     ; #$00 = Byte, normal increment.
  STZ $4300          ; Set DMA mode
  LDA #$22           ; Set dest CGRAM reg ($22 = $2122)
  STA $4301
  LDA #$01           ; Set DMA channel
  STA $420B          ; Init DMA transfer

  RTS

VBlank
                     ; Set BG1 Pal color from RAM
  ;STZ $2115         ; Set video mode
  ;LDX #$0400        ; Tile Address
  ;STX $2116         ; VRAM Write addr

  ;LDA $0000         ; Load color from RAM
  ;STA $2119         ; Write to VRAM


  LDA $4210          ; Clear NMI Flag

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
