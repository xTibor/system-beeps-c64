        BasicUpstart2(start)

.macro inc16(label) {
        inc label
        bne !skip+
        inc label + 1
!skip:
}

        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        * = $1000 "Main"
start:
        lda #<lz4_song_data;  sta lz4_src
        lda #>lz4_song_data;  sta lz4_src + 1

        lda #<song_data;  sta lz4_dst
        lda #>song_data;  sta lz4_dst + 1

        jsr lz4_decompress

        jsr player_init
        jsr irq_init
        jmp *

        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        * = $1100 "IRQ handler"
irq_scanline_index:
        .byte $00
irq_scanline_lo:
        .byte $00, $82, $04, $4E, $D0, $1A, $9C, $1E, $68, $EA, $34, $B6
irq_scanline_hi:
        // Pre-shifted to the right bit-position for binary OR-ing
        .byte $00, $00, $80, $00, $00, $00, $00, $80, $00, $00, $00, $00

        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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

        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        * = $1200 "Player"
        .label player_position = $10
        .label player_wait = $12
        .label player_loop_found = $13
        .label player_loop_position = $14

        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

player_init:
        // Decoration
        lda #$53
        sta $0400
        lda #$02
        sta $D800
        // ---

        lda #<song_data
        sta player_position
        lda #>song_data
        sta player_position + 1

        lda #$00
        sta player_wait
        sta player_loop_found
        sta player_loop_position
        sta player_loop_position +1

        rts

        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

player_update:
        lda player_wait
        cmp #$00
        beq player_update_step
        dec player_wait
        beq player_update_step
        rts

player_update_step:
        ldy #$00
        lda (player_position), y
        sta player_wait

        inc16(player_position)

        cmp #$FF
        beq player_update_handle_loop
        cmp #$00
        beq player_update_handle_exit

        lda (player_position), y
        sta $D400
        inc16(player_position)

        lda (player_position), y
        sta $D401
        inc16(player_position)

        // Set SID registers
        lda #$00
        sta $D405
        lda #$F0
        sta $D406

        lda #$11
        sta $D404

        lda #$0F
        sta $D418
        // ---
        rts

player_update_handle_loop:
        lda #$00
        sta player_wait

        lda player_loop_found
        beq player_update_set_loop

        // Jump to loop
        lda player_loop_position
        sta player_position
        lda player_loop_position + 1
        sta player_position + 1
        rts

player_update_set_loop:
        lda #$01
        sta player_loop_found

        lda player_position
        sta player_loop_position
        lda player_position + 1
        sta player_loop_position + 1
        rts

player_update_handle_exit:
        // TODO
        lda #$00
        jsr raise_error
        // ---
        rts

player_update_end:
        rts

        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        * = $1300 "Song data"
song_data:
        .import binary "res/songs-sid/sys.bin"


        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        * = $6000 "LZ4 decompressor"
lz4_src:
        .word $0000
lz4_dst:
        .word $0000

lz4_decompress:
        //lda #$01
        //jmp raise_error
        rts

        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        .label error_string_pointer = $20

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

        // Print error label
        ldx #$00 // Screen index
        ldy #$00 // String index
!:
        lda error_string_label, y
        beq !+
        sta $0400, x
        inx
        iny
        jmp !-
!:

        // Print error message
        ldy #$00
!:
        lda (error_string_pointer), y
        beq !+
        sta $0400, x
        inx
        iny
        jmp !-
!:

        jmp *

error_strings_lo:
        .byte <error_string_00
        .byte <error_string_01
error_strings_hi:
        .byte >error_string_00
        .byte >error_string_01

.encoding "screencode_upper"

error_string_label:
        .text "ERROR: "
        .byte $00
error_string_00:
        .text "UNIMPLEMENTED FEATURE"
        .byte $00
error_string_01:
        .text "BOJLER ELADO"
        .byte $00

        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        * = $8000 "Compressed data"
lz4_song_data:
        .import binary "res/songs-sid/sys.lz4"
