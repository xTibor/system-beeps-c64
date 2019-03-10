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
        ldx #<song_disk_names + 3 * 0
        ldy #>song_disk_names + 3 * 0
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
        bcs !error+   // If carry set, a load error has happened

        lda #<lz77_song_data;  sta lz77_source
        lda #>lz77_song_data;  sta lz77_source + 1
        lda #<raw_song_data;   sta lz77_target
        lda #>raw_song_data;   sta lz77_target + 1
        jsr lz77_decompress

        rts

!error:
    lda #$04
    sta $d020
    jmp *
    rts
