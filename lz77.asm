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

        .encoding "petscii_upper"
lz77_errorstr_01:
        .text "NOT A GBA-LZ77 STREAM"
        .byte $00
lz77_errorstr_02:
        .text "SIZE GREATER THAN $FFFF"
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
        dec16(lz77_decompressed_size)
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
        and #$0F
        sta lz77_reference_offset + 1

        // Read reference offset LSB
        lda (lz77_source), y
        inc16(lz77_source)
        sta lz77_reference_offset
        inc16(lz77_reference_offset)

        // Calculate start address of reference
        sec
        lda lz77_target
        sbc lz77_reference_offset
        sta lz77_reference_start
        lda lz77_target + 1
        sbc lz77_reference_offset + 1
        sta lz77_reference_start + 1

        // Copy the reference
!:
        lda (lz77_reference_start), y
        inc16(lz77_reference_start)
        sta (lz77_target), y
        inc16(lz77_target)
        dec16(lz77_decompressed_size)   // TODO: Before the loop: lz77_decompressed_size -= lz77_reference_length
        dec lz77_reference_length
        bne !-

lz77_process_block_loop_next:
        lda #$00
        cmp lz77_decompressed_size
        bne !+
        cmp lz77_decompressed_size + 1
        bne !+
        rts
!:
        dec lz77_block_remaining_bits
        bne !+
        jmp lz77_read_block
!:
        jmp lz77_process_block_loop
