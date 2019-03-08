        BasicUpstart2(start)

        * = $1000 "Main"

        #import "macros.asm"
        #import "irq.asm"
        #import "error.asm"
        #import "player.asm"
        #import "lz4.asm"

start:
        lda #<lz4_song_data;  sta lz4_src
        lda #>lz4_song_data;  sta lz4_src + 1

        lda #<raw_song_data;  sta lz4_dst
        lda #>raw_song_data;  sta lz4_dst + 1

        jsr lz4_decompress

        jsr player_init
        jsr irq_init
        jmp *

        * = $2000 "Song data"
raw_song_data:
        .import binary "res/songs-sid/sqw.bin"

        * = $8000 "Compressed data"
lz4_song_data:
        .import binary "res/songs-sid/sqw.lz4"
