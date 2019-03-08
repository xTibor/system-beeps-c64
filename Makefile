KICKASS=~/git/kickass/kickass.jar
EMULATOR=~/Downloads/C64Debugger
#EMULATOR=x64

PIT_BINS := $(wildcard res/songs-pit/*.bin)
SID_BINS := $(patsubst res/songs-pit/%.bin, res/songs-sid/%.bin, $(PIT_BINS))
SID_BINS_LZSS := $(patsubst res/songs-pit/%.bin, res/songs-sid/%.lzss, $(PIT_BINS))

SOURCES := $(wildcard *.asm)

.PHONY: clean

res/songs-sid/%.bin: res/songs-pit/%.bin
	cargo run --manifest-path ./tools/Cargo.toml --bin pit2sid -- --input $< --output $@

res/songs-sid/%.lzss: res/songs-sid/%.bin
	cargo run --manifest-path ./tools/Cargo.toml --bin lzss -- --input $< --output $@

120hz.prg: $(SOURCES) $(SID_BINS_LZSS) $(SID_BINS)
	java -jar $(KICKASS) 120hz.asm

run: 120hz.prg
	${EMULATOR} 120hz.prg

clean:
	rm 120hz.prg 120hz.sym
	rm $(SID_BINS)
	rm $(SID_BINS_LZSS)
