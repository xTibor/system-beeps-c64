.segment MAIN []
#import "main_musicdisk.asm"

.segment SONG_SYS []
* = mem.song_lz77 "System Beeps"
.import binary "res/songs-sid/sys.lz77"

.segment SONG_TMB []
* = mem.song_lz77 "Too Many Bits"
.import binary "res/songs-sid/tmb.lz77"

.segment SONG_BTL []
* = mem.song_lz77 "Battery Low"
.import binary "res/songs-sid/btl.lz77"

.segment SONG_MNC []
* = mem.song_lz77 "Monoculear"
.import binary "res/songs-sid/mnc.lz77"

.segment SONG_HST []
* = mem.song_lz77 "Head Step"
.import binary "res/songs-sid/hst.lz77"

.segment SONG_BAD []
* = mem.song_lz77 "Bad Sector"
.import binary "res/songs-sid/bad.lz77"

.segment SONG_DLD []
* = mem.song_lz77 "Dial-Down"
.import binary "res/songs-sid/dld.lz77"

.segment SONG_HSH []
* = mem.song_lz77 "Handshake"
.import binary "res/songs-sid/hsh.lz77"

.segment SONG_FLO []
* = mem.song_lz77 "Floppy Flips"
.import binary "res/songs-sid/flo.lz77"

.segment SONG_PXL []
* = mem.song_lz77 "Pixel Rain"
.import binary "res/songs-sid/pxl.lz77"

.segment SONG_SSD []
* = mem.song_lz77 "Single-Sided Drive"
.import binary "res/songs-sid/ssd.lz77"

.segment SONG_LED []
* = mem.song_lz77 "Twinkle LED"
.import binary "res/songs-sid/led.lz77"

.segment SONG_CLO []
* = mem.song_lz77 "Clocking Ticks"
.import binary "res/songs-sid/clo.lz77"

.segment SONG_TXR []
* = mem.song_lz77 "TX/RX"
.import binary "res/songs-sid/txr.lz77"

.segment SONG_SRV []
* = mem.song_lz77 "Serverside"
.import binary "res/songs-sid/srv.lz77"

.segment SONG_STF []
* = mem.song_lz77 "Staff Roll"
.import binary "res/songs-sid/stf.lz77"

.segment SONG_ASF []
* = mem.song_lz77 "Astro Force"
.import binary "res/songs-sid/asf.lz77"

.segment SONG_RUN []
* = mem.song_lz77 "Run Under Fire"
.import binary "res/songs-sid/run.lz77"

.segment SONG_MYM []
* = mem.song_lz77 "My Mission"
.import binary "res/songs-sid/mym.lz77"

.segment SONG_SQW []
* = mem.song_lz77 "Square Wave"
.import binary "res/songs-sid/sqw.lz77"

.segment SONG_FIN []
* = mem.song_lz77 "Final Stretch"
.import binary "res/songs-sid/fin.lz77"

.segment SONG_COY []
* = mem.song_lz77 "Coming Year"
.import binary "res/songs-sid/coy.lz77"

.segment SONG_AON []
* = mem.song_lz77 "AONDEMO Soundtrack"
.import binary "res/songs-sid/aon.lz77"

.disk [filename="musicdisk.d64", name="SYSTEM BEEPS", id="2021!" ] {
        [ name="SYSTEM BEEPS",     type="prg", segments="MAIN"     ],
        [ name="----------------", type="rel"                      ],
        [ name="SYS",              type="prg", segments="SONG_SYS" ],
        [ name="TMB",              type="prg", segments="SONG_TMB" ],
        [ name="BTL",              type="prg", segments="SONG_BTL" ],
        [ name="MNC",              type="prg", segments="SONG_MNC" ],
        [ name="HST",              type="prg", segments="SONG_HST" ],
        [ name="BAD",              type="prg", segments="SONG_BAD" ],
        [ name="DLD",              type="prg", segments="SONG_DLD" ],
        [ name="HSH",              type="prg", segments="SONG_HSH" ],
        [ name="FLO",              type="prg", segments="SONG_FLO" ],
        [ name="PXL",              type="prg", segments="SONG_PXL" ],
        [ name="SSD",              type="prg", segments="SONG_SSD" ],
        [ name="LED",              type="prg", segments="SONG_LED" ],
        [ name="CLO",              type="prg", segments="SONG_CLO" ],
        [ name="TXR",              type="prg", segments="SONG_TXR" ],
        [ name="SRV",              type="prg", segments="SONG_SRV" ],
        [ name="STF",              type="prg", segments="SONG_STF" ],
        [ name="ASF",              type="prg", segments="SONG_ASF" ],
        [ name="RUN",              type="prg", segments="SONG_RUN" ],
        [ name="MYM",              type="prg", segments="SONG_MYM" ],
        [ name="SQW",              type="prg", segments="SONG_SQW" ],
        [ name="FIN",              type="prg", segments="SONG_FIN" ],
        [ name="COY",              type="prg", segments="SONG_COY" ],
        [ name="AON",              type="prg", segments="SONG_AON" ],
        [ name=@"\$00\$FF\$FF\$00\$00\$0E\$05\$00", type="rel" ],
        [ name=@"----------------", type="rel"                      ],
        [ name=@"                ", type="rel"                      ],
        [ name=@"  sYSTEM bEEPS  ", type="rel"                      ],
        [ name=@"                ", type="rel"                      ],
        [ name=@" - - - - - - - -", type="rel"                      ],
        [ name=@"                ", type="rel"                      ],
        [ name=@"                ", type="rel"                      ],
        [ name=@"                ", type="rel"                      ],
        [ name=@"                ", type="rel"                      ],
        [ name=@"                ", type="rel"                      ],
        [ name=@"                ", type="rel"                      ],
        [ name=@"                ", type="rel"                      ],
        [ name=@"                ", type="rel"                      ],
        [ name=@"                ", type="rel"                      ],
        [ name=@"                ", type="rel"                      ],
        [ name=@"                ", type="rel"                      ],
        [ name=@"                ", type="rel"                      ],
        [ name=@"                ", type="rel"                      ],
        [ name=@"                ", type="rel"                      ],
        [ name=@"                ", type="rel"                      ],
        [ name=@"                ", type="rel"                      ],
        [ name=@"----------------", type="rel"                      ],
}
