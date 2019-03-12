        #importonce
        #define MUSICDISK

        #import "irq.asm"
        #import "loader.asm"
        #import "player.asm"
        #import "playlist.asm"

        .filenamespace main
start:
        jsr playlist.init

        lda #$00
        sta loader.song_id
        jsr loader.load

        jsr player.init
        jsr irq.init
        jmp *

        .align $0100
start_end:
