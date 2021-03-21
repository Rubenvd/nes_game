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
