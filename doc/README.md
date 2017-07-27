# Docs

Here is where I will keep my development notes. As the project evolves so will this document.

## Assembly Instructions

## Hardware Registers

- Screen Display Register
	- $2100

- Color Selection Register
	- $2121
	-	Contains address for Color #.

- Color Data Register
	- $2122
	- Contains Value of Color.
		- Color is 16-bit (0bbbbbgggggrrrrr)
		- Split into 2 bytes:
			- Low byte (0bbbbbgg)
			- High byte (gggrrrrr)
		- EX: 0000001111111111 or $04FF is blue.



