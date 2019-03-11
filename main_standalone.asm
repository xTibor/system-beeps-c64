        #importonce
        #import "irq.asm"
        #import "player.asm"

        BasicUpstart2(start)
start:
        jsr player_init
        jsr irq_init
        jmp *

//raw_song_data:
        * = raw_song_data
        .import binary "res/songs-sid/aon.bin"
