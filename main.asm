        #import "macros.asm"
        #import "irq.asm"
        #import "error.asm"
        #import "player.asm"
        #import "lz77.asm"
        #import "playlist.asm"


start:
        jsr playlist_init

        lda #<lz77_song_data;  sta lz77_source
        lda #>lz77_song_data;  sta lz77_source + 1
        lda #<raw_song_data;  sta lz77_target
        lda #>raw_song_data;  sta lz77_target + 1
        jsr lz77_decompress

        jsr player_init
        jsr irq_init
        jmp *

        // LZ77 song data needs 4KiB
        * = $2000
lz77_song_data:
        //.import binary "res/songs-sid/sys.lz77"
        //.import binary "res/songs-sid/tmb.lz77"
        //.import binary "res/songs-sid/btl.lz77"
        //.import binary "res/songs-sid/mnc.lz77"
        //.import binary "res/songs-sid/hst.lz77"
        //.import binary "res/songs-sid/bad.lz77"
        //.import binary "res/songs-sid/dld.lz77"
        //.import binary "res/songs-sid/hsh.lz77"
        //.import binary "res/songs-sid/flo.lz77"
        //.import binary "res/songs-sid/pxl.lz77"
        //.import binary "res/songs-sid/ssd.lz77"
        //.import binary "res/songs-sid/led.lz77"
        //.import binary "res/songs-sid/clo.lz77"
        //.import binary "res/songs-sid/txr.lz77"
        //.import binary "res/songs-sid/srv.lz77"
        //.import binary "res/songs-sid/stf.lz77"
        //.import binary "res/songs-sid/asf.lz77"
        //.import binary "res/songs-sid/run.lz77"
        //.import binary "res/songs-sid/mym.lz77"
        //.import binary "res/songs-sid/sqw.lz77"
        //.import binary "res/songs-sid/fin.lz77"
        //.import binary "res/songs-sid/coy.lz77"
        //.import binary "res/songs-sid/aon.lz77"

        // Raw song data needs 16KiB
        * = $3000
raw_song_data:
        //.import binary "res/songs-sid/txr.bin"
