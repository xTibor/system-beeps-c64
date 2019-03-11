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

song_name_address:
        .word $0000

        // A = song_id
load_song:
        //ldx #$00
        //stx song_name_address
        //stx song_name_address + 1

        // Load LZ77 compressed song from disk to memory
        lda #$03      // Filenames are always 3 character long
        ldx #<song_disk_names + 3 * 22
        ldy #>song_disk_names + 3 * 22
        jsr $FFBD     // Call SETNAM

        lda #$01
        ldx $BA       // Last used device number
        bne !+
        ldx #$08      // Default to device 8
!:
        ldy #$01      // not $01 means: load to address stored in file
        jsr $FFBA     // Call SETLFS

        lda #$00      // Load to memory (not verify)
        jsr $FFD5     // Call LOAD
        bcs !handle_errors+   // If carry set, a load error has happened

        lda #<lz77_song_data;  sta lz77_source
        lda #>lz77_song_data;  sta lz77_source + 1
        lda #<raw_song_data;   sta lz77_target
        lda #>raw_song_data;   sta lz77_target + 1
        jsr lz77_decompress

        rts

!handle_errors:
        cmp #$00
        beq error_00
        cmp #$04
        beq error_04
        cmp #$05
        beq error_05
        cmp #$1D
        beq error_1D
        raise_error(loader_errorstr_unknown)

error_00:
        raise_error(loader_errorstr_00)
error_04:
        raise_error(loader_errorstr_04)
error_05:
        raise_error(loader_errorstr_05)
error_1D:
        raise_error(loader_errorstr_1D)

        .encoding "petscii_upper"
loader_errorstr_00:
        .text "Disk load error"
        .byte $00
loader_errorstr_04:
        .text "File not found"
        .byte $00
loader_errorstr_05:
        .text "Device not present"
        .byte $00
loader_errorstr_1D:
        .text "Load error"
        .byte $00
loader_errorstr_unknown:
        .text "Unknown error"
        .byte $00
