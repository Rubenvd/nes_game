check_controls:
    CONTROLLER_1 = $4016
    CONTROLLER_2 = $4017

    ; reset buttons
    LDA #$0 
    LDX #$1 

    set CONTROLLER_1, #$01
    set CONTROLLER_1, #$00

    LDA CONTROLLER_1    ; A 
    AND #$01
    STA button_a
    
    LDA CONTROLLER_1    ; B 
    AND #$01
    STA button_b
    
    LDA CONTROLLER_1    ; Select
    AND #$01
    STA button_select
    
    LDA CONTROLLER_1    ; Start
    AND #$01
    STA button_start
    
    LDA CONTROLLER_1    ; Up
    AND #$01
    STA button_u
    
    LDA CONTROLLER_1    ; Down
    AND #$01
    STA button_d
    
    LDA CONTROLLER_1    ; Left
    AND #$01
    STA button_l
    
    LDA CONTROLLER_1    ; Right
    AND #$01
    STA button_r
    
JMP check_controls_ret

