.macro set set_var, from
    lda from
    sta set_var
.endmacro

.macro prologue
    TXA         ; store X and Y on stack
    PHA
    TYA
    PHA

    LDA SP      ; store SP on stack
    PHA
    TSX
    STX SP
.endmacro

.macro epilogue argsize
    .LOCAL WRITE_TARGET_H
    .LOCAL WRITE_TARGET_L
    .local SP_JUMP

    SP_JUMP = argsize + 3
    WRITE_TARGET_H = argsize + 4
    WRITE_TARGET_L = argsize + 5

    LDY #$04
    LDA (SP), Y
    LDY #WRITE_TARGET_H
    STA (SP), Y


    LDY #$05
    LDA (SP), Y
    LDY #WRITE_TARGET_L
    STA (SP), Y

    LDA SP
    CLC
    ADC #SP_JUMP
    STA tmpSP

    PLA             ; load SP
    STA SP

    PLA             ; load Y
    TAY 
    PLA             ; load X
    STA tmpX
        
    LDX tmpSP
    TXS 

    LDX tmpX
.endmacro

.macro ldarg num
    .local ARGOFF
    ARGOFF = num + 5
    LDY #ARGOFF
    LDA (SP), Y
.endmacro
