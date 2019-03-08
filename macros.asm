.macro inc16(label) {
        inc label
        bne !skip+
        inc label + 1
!skip:
}
