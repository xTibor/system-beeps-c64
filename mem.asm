        #importonce
        .filenamespace mem

        .label font_ram = $8000  // Size: $0800 / 2KiB
        .label text_ram = $8800  // Size: $0400 / 1KiB
        .label color_ram = $D800 // Size: $0400 / 1KiB

        .label song_lz77 = $2000 // Size: $1000 / 4KiB
        .label song_bin = $3000  // Size: $4000 / 16KiB
