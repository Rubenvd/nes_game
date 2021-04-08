check_controls:
    CONTROLLER_1 = $4016
    CONTROLLER_2 = $4017

    set CONTROLLER_1, #$01
    set CONTROLLER_1, #$00
    set button_1, #$00
    
    LDX #$08
    :
        CLC
        ROL button_1
        LDA CONTROLLER_1
        AND #$01
        ADC button_1
        STA button_1
    DEX
    BNE :-
JMP check_controls_ret
