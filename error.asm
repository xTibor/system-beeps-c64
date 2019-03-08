        .label error_string_pointer = $20

error_strings_lo:
        .byte <error_string_00
        .byte <error_string_01
error_strings_hi:
        .byte >error_string_00
        .byte >error_string_01

        .encoding "screencode_upper"
error_string_00:
        .text "UNIMPLEMENTED FEATURE"
        .byte $00
error_string_01:
        .text "BOJLER ELADO"
        .byte $00

        // A = error code
raise_error:
        // Retrieve string pointer from error code
        tax
        lda error_strings_lo, x;  sta error_string_pointer
        lda error_strings_hi, x;  sta error_string_pointer + 1

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
        lda (error_string_pointer), y
        beq !+
        sta $0400, y
        iny
        jmp !-
!:

        // Halt
!:
        inc $07E7
        jmp !-
