lz4_src:
        .word $0000
lz4_dst:
        .word $0000

lz4_decompress:
        //lda #$00
        //jmp raise_error
        rts
