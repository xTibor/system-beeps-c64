        #importonce
        #import "error.asm"
        #import "kernal.asm"
        #import "lz77.asm"
        #import "mem.asm"

        .filenamespace loader

        .encoding "petscii_upper"
filenames:
        .text "SYS"
        .text "TMB"
        .text "BTL"
        .text "MNC"
        .text "HST"
        .text "BAD"
        .text "DLD"
        .text "HSH"
        .text "FLO"
        .text "PXL"
        .text "SSD"
        .text "LED"
        .text "CLO"
        .text "TXR"
        .text "SRV"
        .text "STF"
        .text "ASF"
        .text "RUN"
        .text "MYM"
        .text "SQW"
        .text "FIN"
        .text "COY"
        .text "AON"

filename_offset:
        .byte $00

        // A = song_id
load:
        // Call kernal.setnam
        // Multiplication is kept as an u8, so the max ID it can handle is 85
        sta filename_offset
        clc
        adc filename_offset
        clc
        adc filename_offset  // filename_offset = song_id * 3
        adc #<filenames
        tax  // X = #<filenames + filename_offset

        lda #>filenames
        adc #$00
        tay  // Y = #>filenames + carry from above

        lda #$03  // Filename length
        jsr kernal.setnam

        // Call kernal.setlfs
        lda #$01
        ldx $BA       // Last used device number
        bne !skip+
        ldx #$08      // Default to device 8
!skip:
        ldy #$01      // not $01 means: load to address stored in file
        jsr kernal.setlfs

        // Call kernal.load
        lda #$00      // Load to memory (not verify)
        jsr kernal.load
        bcs !load_error+

        // Decompression
        lda #<mem.song_lz77;  sta lz77.source
        lda #>mem.song_lz77;  sta lz77.source + 1
        lda #<mem.song_bin;  sta lz77.target
        lda #>mem.song_bin;  sta lz77.target + 1
        jsr lz77.decompress

        rts

!load_error:
        cmp #$00
        beq load_error_00
        cmp #$04
        beq load_error_04
        cmp #$05
        beq load_error_05
        cmp #$1D
        beq load_error_1D
        raise_error("Unknown error")

load_error_00:
        raise_error("Disk load error")
load_error_04:
        raise_error("File not found")
load_error_05:
        raise_error("Device not present")
load_error_1D:
        raise_error("Load error")
