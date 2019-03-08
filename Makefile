KICKASS=~/git/kickass/kickass.jar
EMULATOR=~/Downloads/C64Debugger
#EMULATOR=x64

PIT_BINS := $(wildcard res/songs-pit/*.bin)
SID_BINS := $(patsubst res/songs-pit/%.bin, res/songs-sid/%.bin, $(PIT_BINS))

SID_BINS_LZ4 := $(patsubst res/songs-pit/%.bin, res/songs-sid/%.lz4, $(PIT_BINS))

.PHONY: clean

res/songs-sid/%.bin: res/songs-pit/%.bin
	cargo run --manifest-path ./tools/Cargo.toml --bin pit2sid -- --input $< --output $@

res/songs-sid/%.lz4: res/songs-sid/%.bin
	lz4 -9 -f $< $@

120hz.prg: 120hz.asm $(SID_BINS) $(SID_BINS_LZ4)
	java -jar ${KICKASS} 120hz.asm

run: 120hz.prg
	${EMULATOR} 120hz.prg

clean:
	rm 120hz.prg 120hz.sym
	rm $(SID_BINS)
	rm $(SID_BINS_LZ4)
