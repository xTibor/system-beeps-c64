        #importonce

        .filenamespace mem

        .label raw_font_data = $8000  // Size: $0800 / 2KiB
        .label raw_text_data = $8800  // Size: $0400 / 1KiB
        .label color_data = $D800     // Size: $0400 / 1KiB

        .label lz77_song_data = $2000 // Size: $1000 / 4KiB
        .label raw_song_data = $3000  // Size: $4000 / 16KiB
