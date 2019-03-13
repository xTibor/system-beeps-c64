        #importonce
        #define MUSICDISK
        BasicUpstart2(main.start)

        #import "menu.asm"
        #import "error.asm"

        .filenamespace main
start:
        jsr menu.init
        jsr menu.eventloop
        jmp $FFFC

        .align $0100
start_end:
