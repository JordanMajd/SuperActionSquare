#!/bin/bash

# Name of main assembly file
MAIN="Main"

# Create link file
echo '[objects]' > temp
echo Main.obj >> temp

# Avengers assemble!
wla-65816 -I src -o $MAIN.obj src/$MAIN.asm
wlalink -v temp bin/$MAIN.smc

# Clean up build files
rm $MAIN.obj
rm temp

