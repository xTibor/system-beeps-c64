        #importonce
        #import "lz77.asm"
        #import "mem.asm"

        .filenamespace playlist

font_lz77:
        .import binary "res/fonts/cga-font.lz77"
text_lz77:
        .import binary "res/texts/playlist.lz77"

init:
        lda #$00
        sta $D020
        sta $D021

        ldx #$00
!:
        lda #$0F
        sta mem.color_ram + $0000, x
        sta mem.color_ram + $0100, x
        sta mem.color_ram + $0200, x
        sta mem.color_ram + $0300, x
        inx
        bne !-

        lda $DD00
        and #$0C
        ora #$01
        sta $DD00

        lda #$20
        sta $D018

        lda #<font_lz77;  sta lz77.source
        lda #>font_lz77;  sta lz77.source + 1
        lda #<mem.font_ram;  sta lz77.target
        lda #>mem.font_ram;  sta lz77.target + 1
        jsr lz77.decompress

        lda #<text_lz77;  sta lz77.source
        lda #>text_lz77;  sta lz77.source + 1
        lda #<mem.text_ram;  sta lz77.target
        lda #>mem.text_ram;  sta lz77.target + 1
        jsr lz77.decompress

        lda #$0E // Note symbol
        sta mem.text_ram + 40 * 2 + 4

        rts
