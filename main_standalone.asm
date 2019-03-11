        #importonce
        #import "irq.asm"
        #import "player.asm"

        .filenamespace main

        BasicUpstart2(start)
start:
        jsr player.init
        jsr irq.init
        jmp *

        * = mem.raw_song_data
        .import binary "res/songs-sid/sqw.bin"
