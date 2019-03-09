        // Clobbers N, Z
.macro inc16(label) {
        inc label
        bne !skip+
        inc label + 1
!skip:
}

        // Clobbers A, N, Z
.macro dec16(label) {
        lda label
        bne !skip+
        dec label + 1
!skip:
        dec label
}
