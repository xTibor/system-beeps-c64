        #importonce
        #import "macros.asm"
        #import "mem.asm"

        .filenamespace player

        .label position = $10
        .label wait = $12
        .label loop_found = $13
        .label loop_position = $14

init:
        lda #<mem.raw_song_data;  sta position
        lda #>mem.raw_song_data;  sta position + 1

        lda #$00
        sta wait
        sta loop_found
        sta loop_position
        sta loop_position + 1

        rts

update:
        lda wait
        cmp #$00
        beq update_step
        dec wait
        beq update_step
        rts

update_step:
        ldy #$00
        lda (position), y
        sta wait

        inc16(position)

        cmp #$FF
        beq update_handle_loop
        cmp #$00
        beq update_handle_exit

        lda (position), y
        sta $D400
        inc16(position)

        lda (position), y
        sta $D401
        inc16(position)

        // Set SID registers
        // ADSR
        lda #$00
        sta $D405
        lda #$F0
        sta $D406

        // Square wave with 50% duty
        lda #$41
        sta $D404
        lda #$00
        sta $d402
        lda #$08
        sta $d403

        // Master volume to max
        lda #$0F
        sta $D418
        // ---
        rts

update_handle_loop:
        lda #$00
        sta wait

        lda loop_found
        beq update_set_loop

        // Jump to loop
        lda loop_position;     sta position
        lda loop_position + 1; sta position + 1
        rts

update_set_loop:
        lda #$01
        sta loop_found

        lda position;      sta loop_position
        lda position + 1;  sta loop_position + 1
        rts

update_handle_exit:
        // TODO
        //raise_error(error_01)
        // ---
        rts

update_end:
        rts
