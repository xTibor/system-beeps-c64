        #importonce
        #define MUSICDISK
        BasicUpstart2(main.start)

        #import "menu.asm"
        #import "error.asm"

        .filenamespace main
start:
        jsr menu.init
        jsr menu.eventloop
        raise_error("TODO: RESET the machine here")

        .align $0100
start_end:
