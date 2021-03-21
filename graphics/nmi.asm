wait_for_nmi:
    LDA nmi_count
    nmi_check_loop:
        CMP nmi_count
    BEQ nmi_check_loop
    LDA #$0
    STA sprite_bank_offset
JMP wait_for_nmi_ret

nmi:
    INC nmi_count
    RTI

