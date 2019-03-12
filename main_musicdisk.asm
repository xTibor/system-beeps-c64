        #importonce
        #define MUSICDISK

        #import "irq.asm"
        #import "loader.asm"
        #import "menu.asm"
        #import "player.asm"

        .filenamespace main
start:
        jsr menu.init

        lda #$00
        jsr loader.load

        jsr player.init
        jsr irq.init
        jmp *

        .align $0100
start_end:
