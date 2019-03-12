        #importonce
        .filenamespace mem

#if MUSICDISK
        #import "main_musicdisk.asm"
        .label font_ram = $8000 // Size: $0800 / 2KiB
        .label text_ram = $8800 // Size: $0400 / 1KiB
        .label color_ram = $D800 // Size: $0400 / 1KiB

        .label song_lz77 = main.start_end + $0000 // Size: $1000 / 4KiB
        .label song_bin = main.start_end + $1000 // Size: $4000 / 16KiB
#elif STANDALONE
        #import "main_standalone.asm"
        .label song_bin = main.start_end
#endif
