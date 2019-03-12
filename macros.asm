        #importonce

        // Clobbers N, Z
.macro inc16(dest) {
        inc dest
        bne !skip+
        inc dest + 1
!skip:
}

        // Clobbers A, N, Z
.macro dec16(dest) {
        lda dest
        bne !skip+
        dec dest + 1
!skip:
        dec dest
}

        // Clobbers A, C, N, V, Z
.macro sub16(dest, op1, op2) {
        sec
        lda op1
        sbc op2
        sta dest
        lda op1 + 1
        sbc op2 + 1
        sta dest + 1
}

        // Clobbers A, C, N, V, Z
.macro add16(dest, op1, op2) {
        clc
        lda op1
        adc op2
        sta dest
        lda op1 + 1
        adc op2 + 1
        sta dest + 1
}
