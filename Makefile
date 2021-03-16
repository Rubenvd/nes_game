all:
	ca65 start.asm
	ld65 -o rom.nes -C layout.cfg start.o
