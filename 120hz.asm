        BasicUpstart2(start)

        * = $1000 "Main"

        #import "macros.asm"
        #import "irq.asm"
        #import "error.asm"
        #import "player.asm"
        #import "lzss.asm"

start:
        lda #<lzss_song_data;  sta lzss_source
        lda #>lzss_song_data;  sta lzss_source + 1

        lda #<raw_song_data;  sta lzss_target
        lda #>raw_song_data;  sta lzss_target + 1

        jsr lzss_decompress

        jsr player_init
        jsr irq_init
        jmp *

        .align $0100
lzss_song_data:
        .import binary "res/songs-sid/dld.lzss"

        * = $8000
raw_song_data:
