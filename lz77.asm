        .label lz77_source = $20
        .label lz77_target = $22

        .label lz77_decompressed_size = $24
        .label lz77_block_header = $26
        .label lz77_block_remaining_bits = $27

        .label lz77_reference_length = $28
        .label lz77_reference_offset = $2A
        .label lz77_reference_start = $2C

lz77_error_01:
        raise_error(lz77_errorstr_01)
lz77_error_02:
        raise_error(lz77_errorstr_02)

        .encoding "screencode_upper"
lz77_errorstr_01:
        .text "NOT AN LZ77 STREAM"
        .byte $00
lz77_errorstr_02:
        .text "SIZE GREATER THAN $FFFF"
        .byte $00
lz77_errorstr_03:
        .text "UNIMPLEMENTED"
        .byte $00

lz77_decompress:
        ldy #$00

        // Check compression type
        lda (lz77_source), y
        inc16(lz77_source)
        cmp #$10
        bne lz77_error_01

        // Decompressed size 0x0000FF
        lda (lz77_source), y
        inc16(lz77_source)
        sta lz77_decompressed_size

        // Decompressed size 0x00FF00
        lda (lz77_source), y
        inc16(lz77_source)
        sta lz77_decompressed_size + 1

        // Decompressed size 0xFF0000
        lda (lz77_source), y
        inc16(lz77_source)
        cmp #$00
        bne lz77_error_02

lz77_read_block:
        lda #$08
        sta lz77_block_remaining_bits

        lda (lz77_source), y
        inc16(lz77_source)
        sta lz77_block_header

lz77_process_block_loop:
        asl lz77_block_header
        bcs lz77_process_reference

lz77_process_uncompressed:
        lda (lz77_source), y
        inc16(lz77_source)
        sta (lz77_target), y
        inc16(lz77_target)
        jmp lz77_process_block_loop_next

lz77_process_reference:
        // Read reference length
        lda (lz77_source), y
        inc16(lz77_source)
        sta lz77_reference_length
        lsr lz77_reference_length
        lsr lz77_reference_length
        lsr lz77_reference_length
        lsr lz77_reference_length
        inc lz77_reference_length
        inc lz77_reference_length
        inc lz77_reference_length

        // Read reference offset MSB
        sta lz77_reference_offset + 1
        and #$F0

        // Read reference LSB
        lda (lz77_source), y
        inc16(lz77_source)
        inc lz77_reference_offset
        inc16(lz77_reference_offset)



        // TODO


lz77_process_block_loop_next:
        dec16(lz77_decompressed_size)
        lda #$00
        cmp lz77_decompressed_size
        bne !+
        cmp lz77_decompressed_size + 1
        bne !+
        rts
!:
        dec lz77_block_remaining_bits
        bne lz77_process_block_loop
        jmp lz77_read_block






/*
        .label lz77_backref = $54

lz77_decompress:
        ldy #$00
        lda (lz77_source), y
        tay
        inc16(lz77_source)
        tya
        beq !done+
        bmi !backreference+

!uncompressed:
        // Uncompressed when (token and $80) == $00
        tax // Byte count in X
        ldy #$00
!:
        lda (lz77_source), y
        sta (lz77_target), y
        inc16(lz77_source)
        inc16(lz77_target)
        dex
        bne !-

        jmp lz77_decompress

!backreference:
        // Backreference when (token and $80) == $80
        and #$7F
        // X = byte count
        tax

        // lz77_backref = lz77_target
        lda lz77_target;      sta lz77_backref
        lda lz77_target + 1;  sta lz77_backref + 1

        // A = back offset
        ldy #$00
        lda (lz77_source), y
        inc16(lz77_source)

        // lz77_backref -= back offset
        sec
        sbc lz77_backref
        bcs !+
        dec lz77_backref + 1
!:
        lda (lz77_backref), y
        sta (lz77_target), y
        inc16(lz77_backref)
        inc16(lz77_target)
        dex
        bne !-

        jmp lz77_decompress

!done:
        // Done when token == $00
        rts
*/
