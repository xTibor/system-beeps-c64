        #importonce
        #import "main.asm" // TODO: Decouple this

        .label error_str = $18

.macro raise_error(arg_str) {
        lda #<arg_str;  sta error_str
        lda #>arg_str;  sta error_str + 1
        jsr do_raise_error
}

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
        sta raw_text_data + $0000, x
        sta raw_text_data + $0100, x
        sta raw_text_data + $0200, x
        sta raw_text_data + $0300, x
        // Fill color RAM with red
        lda #$02
        sta color_data + $0000, x
        sta color_data + $0100, x
        sta color_data + $0200, x
        sta color_data + $0300, x
        inx
        bne !loop-

        // Print error message
        ldy #$00
!loop:
        lda (error_str), y
        beq !halt+
        sta raw_text_data, y
        iny
        jmp !loop-

!halt:
        // Halt
        jmp *
