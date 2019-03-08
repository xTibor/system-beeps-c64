        .label irq_scanline_index = $08

irq_scanline_lo:
        .byte $00, $82, $04, $4E, $D0, $1A, $9C, $1E, $68, $EA, $34, $B6
irq_scanline_hi:
        // Pre-shifted to the right bit-position for binary OR-ing
        .byte $00, $00, $80, $00, $00, $00, $00, $80, $00, $00, $00, $00

irq_init:
        sei

        // Disable CIA interrupts
        lda #$7F
        sta $DC0D
        sta $DD0D

        // Acknowledge pending CIA interrupts
        lda $DC0D
        lda $DD0D

        // Enable raster interrupts
        lda #$01
        sta $D01A

        // Trigger at line 0
        lda #$00
        sta $D012
        lda #$1B
        sta $D011

        // Unmap BASIC and KERNAL
        lda #$35
        sta $01

        // Set interrupt address
        lda #<irq_handler;  sta $FFFE
        lda #>irq_handler;  sta $FFFF

        lda #$00
        sta irq_scanline_index

        cli
        rts

        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

irq_handler:
        pha
        txa
        pha
        tya
        pha

        // Clear the interrupt condition
        lda #$FF
        sta $D019
        // ---

        inc $D020
        jsr player_update
        dec $D020

        // Set the next scanline trigger
        ldx irq_scanline_index
        inx
        cpx #$0C
        bne !+
        ldx #$00
!:
        stx irq_scanline_index

        lda irq_scanline_lo, x
        sta $D012
        lda irq_scanline_hi, x
        ora #$1B
        sta $D011
        // ---

        pla
        tay
        pla
        tax
        pla
        rti
