        #importonce
        #import "lz77.asm"
        #import "mem.asm"

        .filenamespace playlist

lz77_font_data:
        .import binary "res/fonts/cga-font.lz77"
lz77_text_data:
        .import binary "res/texts/playlist.lz77"

init:
        lda #$00
        sta $d020
        sta $d021

        ldx #$00
!:
        lda #$0F
        sta mem.color_data + $0000, x
        sta mem.color_data + $0100, x
        sta mem.color_data + $0200, x
        sta mem.color_data + $0300, x
        inx
        bne !-

        lda $DD00
        and #$0C
        ora #$01
        sta $DD00

        lda #$20
        sta $D018

        lda #<lz77_font_data;  sta lz77.source
        lda #>lz77_font_data;  sta lz77.source + 1
        lda #<mem.raw_font_data;  sta lz77.target
        lda #>mem.raw_font_data;  sta lz77.target + 1
        jsr lz77.decompress

        lda #<lz77_text_data;  sta lz77.source
        lda #>lz77_text_data;  sta lz77.source + 1
        lda #<mem.raw_text_data;  sta lz77.target
        lda #>mem.raw_text_data;  sta lz77.target + 1
        jsr lz77.decompress

        lda #$0E // Note symbol
        sta mem.raw_text_data + 40 * 2 + 4

        rts

