        .label lzss_source = $50
        .label lzss_target = $52
        .label lzss_backref = $54

lzss_decompress:
        ldy #$00
        lda (lzss_source), y
        tay
        inc16(lzss_source)
        tya
        beq !done+
        bmi !backreference+

!uncompressed:
        // Uncompressed when (token and $80) == $00
        tax // Byte count in X
        ldy #$00
!:
        lda (lzss_source), y
        sta (lzss_target), y
        inc16(lzss_source)
        inc16(lzss_target)
        dex
        bne !-

        jmp lzss_decompress

!backreference:
        // Backreference when (token and $80) == $80
        and #$7F
        // X = byte count
        tax

        // lzss_backref = lzss_target
        lda lzss_target;      sta lzss_backref
        lda lzss_target + 1;  sta lzss_backref + 1

        // A = back offset
        ldy #$00
        lda (lzss_source), y
        inc16(lzss_source)

        // lzss_backref -= back offset
        sec
        sbc lzss_backref
        bcs !+
        dec lzss_backref + 1
!:
        lda (lzss_backref), y
        sta (lzss_target), y
        inc16(lzss_backref)
        inc16(lzss_target)
        dex
        bne !-

        jmp lzss_decompress

!done:
        // Done when token == $00
        rts
