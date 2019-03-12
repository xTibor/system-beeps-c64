        #importonce
        #define STANDALONE
        BasicUpstart2(main.start)

        #import "irq.asm"
        #import "player.asm"

        .filenamespace main
start:
        jsr player.init
        jsr irq.init
        jmp *

        .align $0100
start_end:

        * = mem.song_bin
        .import binary "res/songs-sid/aon.bin"
