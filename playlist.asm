        .label raw_font_data = $8000
        .label raw_text_data = $8800
        .label color_data = $D800

lz77_font_data:
        .import binary "res/fonts/cga-font.lz77"
lz77_text_data:
        .import binary "res/texts/playlist.lz77"

playlist_init:
        lda #$00
        sta $d020
        sta $d021

        ldx #$00
!:
        lda #$0F
        sta color_data + $0000, x
        sta color_data + $0100, x
        sta color_data + $0200, x
        sta color_data + $0300, x
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
        sta raw_text_data + 40 * 2 + 4

        rts

