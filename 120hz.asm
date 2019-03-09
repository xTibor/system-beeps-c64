        BasicUpstart2(start)

        * = $1000 "Main"

        #import "macros.asm"
        #import "irq.asm"
        #import "error.asm"
        #import "player.asm"
        #import "lz77.asm"

start:
        lda #<lz77_song_data;  sta lz77_source
        lda #>lz77_song_data;  sta lz77_source + 1

        lda #<raw_song_data;  sta lz77_target
        lda #>raw_song_data;  sta lz77_target + 1

        jsr lz77_decompress

        jsr player_init
        jsr irq_init
        jmp *

        .align $0100
lz77_song_data:
        .import binary "res/songs-sid/sqw.lz77"

        * = $4000
raw_song_data:
        //.import binary "res/songs-sid/txr.bin"
