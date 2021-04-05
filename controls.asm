check_controls:
    CONTROLLER_1 = $4016
    CONTROLLER_2 = $4017

    set CONTROLLER_1, #$01
    set CONTROLLER_1, #$00
    LDA #$00
    STA button_1
    LDX #$08
    :
        ROL button_1
        LDA CONTROLLER_1    ; A
        AND #$01
        ADC button_1
        STA button_1
    DEX
    BNE :-
JMP check_controls_ret
