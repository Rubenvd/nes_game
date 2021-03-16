.proc wait_for_nmi
    PHA
    LDA nmi_count
    nmi_check_loop:
        CMP nmi_count
    BEQ nmi_check_loop
    PLA
    RTS
.endproc

nmi:
    INC nmi_count
    RTI

