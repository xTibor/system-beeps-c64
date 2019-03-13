        #importonce
        #import "error.asm"
        #import "macros.asm"

        .filenamespace lz77

        .label source = $20
        .label target = $22

        .label decompressed_size = $24
        .label block_header = $26
        .label block_remaining_bits = $27

        .label reference_length = $28
        .label reference_offset = $2A
        .label reference_start = $2C

error_01:
        raise_error("Not a GBA-LZ77 compressed stream")
error_02:
        raise_error("Decompressed size larger than $FFFF")

decompress:
        ldy #$00

        // Check compression type
        lda (source), y
        inc16(source)
        cmp #$10
        bne error_01

        // Decompressed size 0x0000FF
        lda (source), y
        inc16(source)
        sta decompressed_size

        // Decompressed size 0x00FF00
        lda (source), y
        inc16(source)
        sta decompressed_size + 1

        // Decompressed size 0xFF0000
        lda (source), y
        inc16(source)
        cmp #$00
        bne error_02

read_block:
        lda #$08
        sta block_remaining_bits

        lda (source), y
        inc16(source)
        sta block_header

process_block_loop:
        asl block_header
        bcs process_reference

process_uncompressed:
        lda (source), y
        inc16(source)
        sta (target), y
        inc16(target)
        dec16(decompressed_size)
        jmp process_block_loop_next

process_reference:
        // Read reference length
        lda (source), y
        inc16(source)
        sta reference_length
        lsr reference_length
        lsr reference_length
        lsr reference_length
        lsr reference_length
        inc reference_length
        inc reference_length
        inc reference_length

        // Read reference offset MSB
        and #$0F
        sta reference_offset + 1

        // Read reference offset LSB
        lda (source), y
        inc16(source)
        sta reference_offset
        inc16(reference_offset)

        sub16(reference_start, target, reference_offset)
        sub16(decompressed_size, decompressed_size, reference_length)
        // TODO: decompressed_size underflow check

        // Copy the reference
!loop:
        lda (reference_start), y
        inc16(reference_start)
        sta (target), y
        inc16(target)
        dec reference_length
        bne !loop-

process_block_loop_next:
        lda #$00
        cmp decompressed_size
        bne !+
        cmp decompressed_size + 1
        bne !+
        rts
!:
        dec block_remaining_bits
        bne !+
        jmp read_block
!:
        jmp process_block_loop
