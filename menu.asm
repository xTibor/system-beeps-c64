        #importonce
        #import "lz77.asm"
        #import "mem.asm"

        .filenamespace menu

font_lz77:
        .import binary "res/fonts/cga-font.lz77"
text_lz77:
        .import binary "res/texts/menu.lz77"

        .const color_selected = $01
        .const color_normal = $0F

item_selected:
        .byte $00
item_playing:
        .byte $00

init:
        lda #$00
        sta $D020
        sta $D021

        ldx #$00
        lda #color_normal
!:
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

        lda #$00
        sta item_selected
        sta item_playing
        jsr set_playing_marker
        jsr set_selection

        //jsr clear_playing_marker
        //inc item_playing
        //jsr set_playing_marker

        //jsr clear_selection
        //inc item_selected
        //jsr set_selection

        rts

item_text_offset_lo:
        .fill 23, <(mem.text_ram + 40 * (i + 2) + 4)
item_text_offset_hi:
        .fill 23, >(mem.text_ram + 40 * (i + 2) + 4)
item_color_offset_lo:
        .fill 23, <(mem.color_ram + 40 * (i + 2) + 4)
item_color_offset_hi:
        .fill 23, >(mem.color_ram + 40 * (i + 2) + 4)

        // Clobbers A, X, Y
clear_playing_marker:
        ldy #$20  // Space
        jmp !draw+
set_playing_marker:
        ldy #$0E  // Note character
!draw:
        ldx item_playing
        lda item_text_offset_lo, x
        sta !addr+ + 1
        lda item_text_offset_hi, x
        sta !addr+ + 2
        tya
!addr:  sta.abs $0000
        rts

        // Clobbers A, X, Y
clear_selection:
        ldy #color_normal
        jmp !draw+
set_selection:
        ldy #color_selected
!draw:
        ldx item_selected
        lda item_color_offset_lo, x
        sta !addr+ + 1
        lda item_color_offset_hi, x
        sta !addr+ + 2
        tya
        ldx #35  // Item width
!loop:
!addr:  sta.abs $0000, x
        dex
        bpl !loop-
        rts
