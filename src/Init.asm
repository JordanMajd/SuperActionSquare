.MACRO InitSystem
	SEI								; Set interrupt disable flag.
										
										; SNES boots in 6502 emulation mode.
										; Set Native mode:
	CLC								; 1. Clear carry flag.
	XCE								; 2. Exchange carry with emulation

										; Set A, X, Y to 16 bit, decimal mode off.
	REP #$38					; Reset Flag (REP) clears bits specified in the operands of the flag.

										;
	LDX #$1FFF				; 1FFF = End of bank 1
	TXS								; Transfer X to Stack

	JSR Init

.ENDM

.BANK 0 SLOT 0
.ORG 0
.SECTION "InitializeSystem" FREE ; See FREE, SEMIFREE and FORCE in WLA docs
Init:
	RTS
.ENDS
