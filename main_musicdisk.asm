        #importonce
        #import "macros.asm"
        #import "irq.asm"
        #import "error.asm"
        #import "player.asm"
        #import "lz77.asm"
        #import "playlist.asm"
        #import "loader.asm"

start:
        jsr playlist_init

        lda #$04
        sta song_id
        jsr load_song

        jsr player_init
        jsr irq_init
        jmp *
