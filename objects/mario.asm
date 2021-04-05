init_mario:
    set mario_dy, #$0
    set mario_x, #$50
    set mario_y, #$80
JMP init_mario_ret

draw_mario:
    set sprite_flags, #$0
    set sprite_index, #$36
    set sprite_x_pos, mario_x
    set sprite_y_pos, mario_y
    JSR fast_sprite

    set sprite_index, #$37
    LDA mario_x
    CLC
    ADC #$08
    STA sprite_x_pos
    set sprite_y_pos, mario_y
    JSR fast_sprite

    set sprite_index, #$38
    set sprite_x_pos, mario_x
    LDA mario_y
    CLC
    ADC #$8
    STA sprite_y_pos
    JSR fast_sprite

    set sprite_index, #$39
    LDA mario_x
    CLC
    ADC #$8
    STA sprite_x_pos
    LDA mario_y
    CLC
    ADC #$8
    STA sprite_y_pos
    JSR fast_sprite
JMP draw_mario_ret

mario_deltas:
    CLC
    LDA mario_x
    ADC mario_dx
    CLC
    CMP #$F0
    BCC :+
        ; you are off screen to the right
        LDA #$F0
    :
    CLC
    CMP #$02
    BCS :+
        ; you are off screen to the left
        LDA #$02
    :
    STA mario_x

    CLC
    LDA mario_y
    CPY #$E0
    BEQ :++
        LDX mario_dy
        INX
        CPX #$03
        BEQ :+
            STX mario_dy
        :
    : ; skip gravity
    ADC mario_dy
    CLC
    CMP #$CF
    BCC :+
        set mario_dy, #$0
        LDA #$CF
    :
    STA mario_y
JMP mario_deltas_ret

move_mario:
    LDA #$0
    STA mario_dx

    LDA mario_jumping
    BEQ no_jump
    LDA button_1
    AND #$80
    BEQ no_jump
        ; button_a is pressed
        set mario_dy, #$FA
        set mario_jumping, #$01
    no_jump:

    LDA button_1
    AND #$02
    BEQ no_l
        ; button_l is pressed
        set mario_dx, #$FE
    no_l:

    LDA button_1
    AND #$01
    BEQ no_r
        ; button_l is pressed
        set mario_dx, #$02
    no_r:

    JMP mario_deltas
    mario_deltas_ret:
JMP move_mario_ret
