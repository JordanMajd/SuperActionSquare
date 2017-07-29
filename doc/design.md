# Design Overview

This serves as a overview of how the program will flow.

## Principles

1. Write an abundance of comments and document everything.
1. Use an abundance of subroutines.

## Program Flow

1. Header
1. Initialize
  - Disable Interrupts
  - Switch To Native Mode
  - Switch to 16 bit mode
  - Force VBlank
  - Clear registers
1. Main Program
  - Load palette to VRAM
  - Load palette to PPU Color RAM
  - Setup video
  - Draw initial screen
  - Enable Interrupts
1. VBlank (NMI Interrupt)
  - Read controller input
  - Update sprites
  - Update characters
  - Render backgrounds.
  - Render menus.
  - Clear NMI

## Considerations

  - Intro
  - Main menu
  - Credits
  - Music & Sound
