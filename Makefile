KICKASS=~/git/kickass/kickass.jar
EMULATOR=~/Downloads/C64Debugger
#EMULATOR=x64

.PHONY: clean

120hz.prg: 120hz.asm
	java -jar ${KICKASS} 120hz.asm

run: 120hz.prg
	${EMULATOR} 120hz.prg

clean:
	rm 120hz.prg 120hz.sym
