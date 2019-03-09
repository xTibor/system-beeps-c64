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

        // Fill screen RAM with spaces
        // Fill color RAM with red
        ldx #$00
!:
        lda #$20
        sta $0400, x
        sta $0500, x
        sta $0600, x
        sta $0700, x
        lda #$02
        sta $D800, x
        sta $D900, x
        sta $DA00, x
        sta $DB00, x
        inx
        bne !-

        // Print error message
        ldy #$00
!:
        lda (error_str), y
        beq !+
        sta $0400, y
        iny
        jmp !-
!:

        // Halt
        jmp *
