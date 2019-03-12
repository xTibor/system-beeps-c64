        #importonce
        #import "error.asm"
        #import "lz77.asm"
        #import "mem.asm"

        .filenamespace loader

        .encoding "petscii_upper"
song_disk_names:
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

song_id:
        .byte $00

load:
        // Set filename
        // Multiplication is kept as an u8, so the max ID it can handle is 85
        lda song_id
        clc
        adc song_id
        clc
        adc song_id
        adc #<song_disk_names
        tax  // X = (song_id * 3) + #<song_disk_names

        lda #>song_disk_names
        adc #$00
        tay  // Y = #>song_disk_names + carry

        lda #$03  // Set filename length
        jsr $FFBD     // Call SETNAM

        //
        lda #$01
        ldx $BA       // Last used device number
        bne !skip+
        ldx #$08      // Default to device 8
!skip:


        ldy #$01      // not $01 means: load to address stored in file
        jsr $FFBA     // Call SETLFS

        lda #$00      // Load to memory (not verify)
        jsr $FFD5     // Call LOAD
        bcs !handle_error+   // If carry set, a load error has happened

        lda #<mem.song_lz77;  sta lz77.source
        lda #>mem.song_lz77;  sta lz77.source + 1
        lda #<mem.song_bin;   sta lz77.target
        lda #>mem.song_bin;   sta lz77.target + 1
        jsr lz77.decompress

        rts

!handle_error:
        cmp #$00
        beq error_00
        cmp #$04
        beq error_04
        cmp #$05
        beq error_05
        cmp #$1D
        beq error_1D
        raise_error(errorstr_unknown)

error_00:
        raise_error(errorstr_00)
error_04:
        raise_error(errorstr_04)
error_05:
        raise_error(errorstr_05)
error_1D:
        raise_error(errorstr_1D)

        .encoding "petscii_upper"
errorstr_00:
        .text @"Disk load error\$00"
errorstr_04:
        .text @"File not found\$00"
errorstr_05:
        .text @"Device not present\$00"
errorstr_1D:
        .text @"Load error\$00"
errorstr_unknown:
        .text @"Unknown error\$00"
