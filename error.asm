        #importonce
        #import "mem.asm"

.macro raise_error(arg_message) {
        lda #<!message+;  sta error.addr + 1
        lda #>!message+;  sta error.addr + 2
        jsr error.do_raise_error
!message:
        .encoding "petscii_upper"
        .text arg_message
        .byte $00
}

        .filenamespace error

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
addr:   lda $0000, y
        beq !halt+
        sta mem.text_ram, y
        iny
        jmp !loop-

        // TODO: Reset after keypress
!halt:
        jmp *
