        #importonce
        #import "mem.asm"

        // TODO: Move this under the error namespace
.macro raise_error(arg_str) {
        lda #<arg_str;  sta error.string
        lda #>arg_str;  sta error.string + 1
        jsr error.do_raise_error
}

        .filenamespace error

        .label string = $18

do_raise_error:
        // Set red border
        lda #$02
        sta $D020

        // Set black background
        lda #$00
        sta $D021

        ldx #$00
!loop:
        // Fill screen RAM with spaces
        lda #$20
        sta mem.text_ram + $0000, x
        sta mem.text_ram + $0100, x
        sta mem.text_ram + $0200, x
        sta mem.text_ram + $0300, x
        // Fill color RAM with red
        lda #$02
        sta mem.color_ram + $0000, x
        sta mem.color_ram + $0100, x
        sta mem.color_ram + $0200, x
        sta mem.color_ram + $0300, x
        inx
        bne !loop-

        // Print error message
        ldy #$00
!loop:
        lda (string), y
        beq !halt+
        sta mem.text_ram, y
        iny
        jmp !loop-

!halt:
        jmp *
