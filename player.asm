        .label player_position = $10
        .label player_wait = $12
        .label player_loop_found = $13
        .label player_loop_position = $14

player_init:
        // Decoration
        lda #$53
        sta $0400
        lda #$02
        sta $D800
        // ---

        lda #<raw_song_data;  sta player_position
        lda #>raw_song_data;  sta player_position + 1

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
