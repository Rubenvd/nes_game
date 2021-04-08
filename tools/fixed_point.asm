.proc add_fp
    ; arg_1.arg_2 = arg_1.arg2 + arg_3.arg_4

    CLC
    LDA arg_2
    ADC arg_4
    STA arg_2
    LDA arg_1
    ADC arg_3
    STA arg_1
    RTS
.endproc

.proc sub_fp
    ; arg_1.arg_2 = arg_1.arg2 - arg_3.arg_4

    SEC
    LDA arg_2
    SBC arg_4
    STA arg_2
    LDA arg_1
    SBC arg_3
    STA arg_1
    RTS
.endproc

.proc mul_fp
    ; arg_1.arg_2 = arg_1.arg_2 * arg_3.arg_4
    set tmp_c, #$00
    set tmp_d, #$00

    set tmp_a, arg_1
    set tmp_b, arg_2
    LDX #$08
        :
        CLC
        ROR tmp_a
        ROR tmp_b
        CLC
        ROL arg_4
        BCC :+
            CLC
            LDA tmp_d
            ADC tmp_b
            STA tmp_d
            LDA tmp_c
            ADC tmp_a
            STA tmp_c
        :

    DEX
    BNE :--

    set tmp_a, arg_1
    set tmp_b, arg_2
    LDX #$08
        :
        CLC
        ROR arg_3
        BCC :+
            CLC
            LDA tmp_d
            ADC tmp_b
            STA tmp_d
            LDA tmp_c
            ADC tmp_a
            STA tmp_c
        :
        CLC
        ROL tmp_b
        ROL tmp_a
    DEX
    BNE :--

    set arg_1, tmp_c
    set arg_2, tmp_d
    RTS
.endproc
