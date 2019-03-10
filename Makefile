KICKASS=~/git/kickass/kickass.jar
EMULATOR=~/Downloads/C64Debugger
#EMULATOR=x64

PIT_BINS := $(wildcard res/songs-pit/*.bin)
SID_BINS := $(patsubst res/songs-pit/%.bin, res/songs-sid/%.bin, $(PIT_BINS))
SID_BINS_LZ77 := $(patsubst res/songs-pit/%.bin, res/songs-sid/%.lz77, $(PIT_BINS))

FONT_PNGS := $(wildcard res/fonts/*.png)
FONT_64CS := $(patsubst res/fonts/%.png, res/fonts/%.64c, $(FONT_PNGS))
FONT_64CS_LZ77 := $(patsubst res/fonts/%.png, res/fonts/%.lz77, $(FONT_PNGS))

TEXT_BINS := $(wildcard res/texts/*.bin)
TEXT_BINS_LZ77 := $(patsubst res/texts/%.bin, res/texts/%.lz77, $(TEXT_BINS))

SOURCES := $(wildcard *.asm)

.PHONY: clean

res/songs-sid/%.bin: res/songs-pit/%.bin
	cargo run --manifest-path ./tools/Cargo.toml --bin pit2sid -- --input $< --output $@

res/songs-sid/%.lz77: res/songs-sid/%.bin
	cargo run --manifest-path ./tools/Cargo.toml --bin lz77 -- --input $< --output $@

res/fonts/%.64c: res/fonts/%.png
	cargo run --manifest-path ./tools/Cargo.toml --bin img2font -- --input $< --output $@

res/fonts/%.lz77: res/fonts/%.64c
	cargo run --manifest-path ./tools/Cargo.toml --bin lz77 -- --input $< --output $@

res/texts/%.lz77: res/texts/%.bin
	cargo run --manifest-path ./tools/Cargo.toml --bin lz77 -- --input $< --output $@

120hz.d64: $(SOURCES) $(SID_BINS_LZ77) $(SID_BINS) $(FONT_64CS) $(FONT_64CS_LZ77) $(TEXT_BINS) $(TEXT_BINS_LZ77)
	java -jar $(KICKASS) disk.asm

run: 120hz.d64
	${EMULATOR} 120hz.d64

clean:
	rm 120hz.d64 disk.sym
	rm $(SID_BINS)
	rm $(SID_BINS_LZ77)
	rm $(FONT_64CS)
	rm $(FONT_64CS_LZ77)
	rm $(TEXT_BINS_LZ77)
