; START HEADER
;==LoRom==
.MEMORYMAP										;	Begin describing the system arch.
	SLOTSIZE $8000							;	The slot is $8000 bytes in size.
	DEFAULTSLOT 0								; The SNES only has one slot.
	SLOT 0 $8000								; Define the starting address for Slot 0.
.ENDME

.ROMBANKSIZE $8000						; ROM banks are 32 KB in size.
.ROMBANKS 8										; Tell WLA to use 8 ROM Banks - 2 Mbits
.DEFINE HEADER_OFF	$8000			; Def header offset, used in InitSNES

.SNESHEADER
	ID "SNES"										; 1-4 letter string

	NAME "Name of Program     "	;	21 byte program title.

	SLOWROM
	LOROM

	CARTRIDGETYPE $00						; $00 = ROM only, see WLA docs.
	ROMSIZE $80									;	$08 = 2 Mbits, see WLA docs.
	SRAMSIZE $00								; NO SRAM, see WLA docs.
	COUNTRY $01									; $01 = US, $00 = Japan.
	LICENSEECODE $00						;
.ENDSNES

.SNESNATIVEVECTOR							; Def Native Mode interrupt vector table.
	COP EmptyHandler
	BRK EmptyHandler
	ABORT EmptyHandler
	NMI VBlank
	IRQ EmptyHandler
.ENDNATIVEVECTOR

.SNESEMUVECTOR								; Def Emu Mode interrupt vector table.
	COP EmptyHandler
	ABORT EmptyHandler
	NMI VBlank
	RESET Start
	IRQBRK EmptyHandler
.ENDEMUVECTOR

.BANK 0 SLOT 0								; Def ROM bank and slot it is in memory.
.ORG 0												; .ORG 0 is $8000 bc slot starts at $8000
.SECTION "EmptyVectors" SEMIFREE

EmptyHandler:
	rti
.ENDS

.EMPTYFILL $00

; END HEADER

