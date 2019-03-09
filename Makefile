KICKASS=~/git/kickass/kickass.jar
EMULATOR=~/Downloads/C64Debugger
#EMULATOR=x64

PIT_BINS := $(wildcard res/songs-pit/*.bin)
SID_BINS := $(patsubst res/songs-pit/%.bin, res/songs-sid/%.bin, $(PIT_BINS))
SID_BINS_LZ77 := $(patsubst res/songs-pit/%.bin, res/songs-sid/%.lz77, $(PIT_BINS))

SOURCES := $(wildcard *.asm)

.PHONY: clean

res/songs-sid/%.bin: res/songs-pit/%.bin
	cargo run --manifest-path ./tools/Cargo.toml --bin pit2sid -- --input $< --output $@

res/songs-sid/%.lz77: res/songs-sid/%.bin
	cargo run --manifest-path ./tools/Cargo.toml --bin lz77 -- --input $< --output $@

120hz.prg: $(SOURCES) $(SID_BINS_LZ77) $(SID_BINS)
	java -jar $(KICKASS) 120hz.asm

run: 120hz.prg
	${EMULATOR} 120hz.prg

clean:
	rm 120hz.prg 120hz.sym
	rm $(SID_BINS)
	rm $(SID_BINS_LZ77)
