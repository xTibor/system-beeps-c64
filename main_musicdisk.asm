        #importonce
        #import "macros.asm"
        #import "irq.asm"
        #import "error.asm"
        #import "player.asm"
        #import "lz77.asm"
        #import "playlist.asm"
        #import "loader.asm"

        .filenamespace main

start:
        jsr playlist.init

        lda #$00
        sta loader.song_id
        jsr loader.load

        jsr player.init
        jsr irq.init
        jmp *
