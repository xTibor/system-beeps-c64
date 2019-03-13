        #importonce
        #import "kernal.asm"
        #import "lz77.asm"
        #import "mem.asm"
        #import "loader.asm"
        #import "player.asm"
        #import "irq.asm"

        .filenamespace menu

font_lz77:
        .import binary "res/fonts/cga-font.lz77"
text_lz77:
        .import binary "res/texts/menu.lz77"

        .const color_selected = $01
        .const color_normal = $0F

        .const marker_none = $20
        .const marker_loading = $AF
        .const marker_playing = $0E

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

        ldy #marker_none
        jsr set_marker_shape

        ldy #color_selected
        jsr set_selection_color

        rts

item_text_offset_lo:
        .fill 23, <(mem.text_ram + 40 * (i + 2) + 4)
item_text_offset_hi:
        .fill 23, >(mem.text_ram + 40 * (i + 2) + 4)
item_color_offset_lo:
        .fill 23, <(mem.color_ram + 40 * (i + 2) + 4)
item_color_offset_hi:
        .fill 23, >(mem.color_ram + 40 * (i + 2) + 4)

        // Y = marker character
        // Clobbers A, X  // TODO: flags it clobbers
set_marker_shape:
        ldx item_playing
        lda item_text_offset_lo, x
        sta !addr+ + 1
        lda item_text_offset_hi, x
        sta !addr+ + 2
!addr:  sty.abs $0000
        rts

        // Y = selection color
        // Clobbers A, X, Y  // TODO: flags it clobbers
set_selection_color:
        ldx item_selected
        lda item_color_offset_lo, x
        sta !addr+ + 1
        lda item_color_offset_hi, x
        sta !addr+ + 2
        tya
        ldx #35  // Selection width
!loop:
!addr:  sta.abs $0000, x
        dex
        bpl !loop-
        rts

eventloop:
        jsr kernal.getin
        cmp #$00
        beq eventloop
        cmp #$11
        beq event_movedown
        cmp #$91
        beq event_moveup
        cmp #$0D
        beq event_load
        cmp #$03
        beq event_exit
        jmp eventloop

event_movedown:
        ldy #color_normal
        jsr set_selection_color
        inc item_selected
        lda item_selected
        cmp #23
        bne !no_wraparound+
        lda #$00
        sta item_selected
!no_wraparound:
        ldy #color_selected
        jsr set_selection_color
        jmp eventloop

event_moveup:
        ldy #color_normal
        jsr set_selection_color
        dec item_selected
        bpl !no_wraparound+
        lda #22
        sta item_selected
!no_wraparound:
        ldy #color_selected
        jsr set_selection_color
        jmp eventloop

event_load:
        jsr irq.fini
        jsr player.fini

        ldy #marker_none
        jsr set_marker_shape

        lda item_selected
        sta item_playing

        ldy #marker_loading
        jsr set_marker_shape

        lda item_playing
        jsr loader.load

        ldy #marker_playing
        jsr set_marker_shape

        jsr player.init
        jsr irq.init

        jmp eventloop

event_exit:
        jsr irq.fini
        jsr player.fini
        rts
