        BasicUpstart2(start)

        #import "macros.asm"
        #import "irq.asm"
        #import "error.asm"
        #import "player.asm"
        #import "lz77.asm"

        .label raw_font_data = $8000
        .label raw_text_data = $8800

lz77_font_data:
        .import binary "res/fonts/cga-font.lz77"
lz77_text_data:
        .import binary "res/texts/screen.lz77"

start:
        // TODO: Move the gfx stuff to a separate file
        lda #$00
        sta $d020
        sta $d021

        ldx #$00
!:
        lda #$0F
        sta $D800, x
        sta $D900, x
        sta $DA00, x
        sta $DB00, x
        inx
        bne !-

        lda $DD00
        and #$0C
        ora #$01
        sta $DD00

        lda #$20
        sta $D018

        lda #<lz77_font_data;  sta lz77_source
        lda #>lz77_font_data;  sta lz77_source + 1
        lda #<raw_font_data;  sta lz77_target
        lda #>raw_font_data;  sta lz77_target + 1
        jsr lz77_decompress

        lda #<lz77_text_data;  sta lz77_source
        lda #>lz77_text_data;  sta lz77_source + 1
        lda #<raw_text_data;  sta lz77_target
        lda #>raw_text_data;  sta lz77_target + 1
        jsr lz77_decompress

        lda #$0E // Note symbol
        sta raw_text_data + 40 * 15 + 4




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
        //.import binary "res/songs-sid/aon.lz77"
        //.import binary "res/songs-sid/asf.lz77"
        //.import binary "res/songs-sid/bad.lz77"
        //.import binary "res/songs-sid/btl.lz77"
        //.import binary "res/songs-sid/clo.lz77"
        //.import binary "res/songs-sid/coy.lz77"
        //.import binary "res/songs-sid/dld.lz77"
        //.import binary "res/songs-sid/fin.lz77"
        //.import binary "res/songs-sid/flo.lz77"
        //.import binary "res/songs-sid/hsh.lz77"
        //.import binary "res/songs-sid/hst.lz77"
        //.import binary "res/songs-sid/led.lz77"
        //.import binary "res/songs-sid/mnc.lz77"
        //.import binary "res/songs-sid/mym.lz77"
        //.import binary "res/songs-sid/pxl.lz77"
        //.import binary "res/songs-sid/run.lz77"
        //.import binary "res/songs-sid/sqw.lz77"
        //.import binary "res/songs-sid/srv.lz77"
        //.import binary "res/songs-sid/ssd.lz77"
        //.import binary "res/songs-sid/stf.lz77"
        //.import binary "res/songs-sid/sys.lz77"
        //.import binary "res/songs-sid/tmb.lz77"
        .import binary "res/songs-sid/txr.lz77"

        // Raw song data needs 16KiB
        * = $3000
raw_song_data:
        //.import binary "res/songs-sid/txr.bin"
