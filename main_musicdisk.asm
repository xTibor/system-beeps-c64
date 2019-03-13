        #importonce
        #define MUSICDISK
        BasicUpstart2(main.start)

        #import "irq.asm"

        #import "menu.asm"
        #import "player.asm"

        .filenamespace main
start:
        jsr menu.init
        //jsr player.init
        //jsr irq.init
        jsr menu.eventloop

        // TODO: Reset the machine
        lda #$03
        sta $D020
        jmp *

        .align $0100
start_end:
