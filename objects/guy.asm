.define GUY_X #$00
.define GUY_Y #$02
.define GUY_DX #$04
.define GUY_DY #$06
.define GUY_GRAV #$08
.define GUY_HEALTH #$0A
.define GUY_STATE #$0C
.define GUY_ID #$0D

.define GUY_STATE_IDLE #$00
.define GUY_STATE_JUMPING #$01

.macro guy_load val
    ; a = the val
    LDY val
    LDA (guy_addr), Y
.endmacro

.macro guy_save val
    ; A = value to save
    LDY val
    STA (guy_addr), Y
.endmacro

.macro guy_load_dec val
    ; arg_1 arg_2 : destination
    LDY val
    LDA (guy_addr), Y
    STA arg_1
    INY
    LDA (guy_addr), Y
    STA arg_2
.endmacro

.macro guy_save_dec val
    ; arg_1 arg_2 : value to save
    LDY val
    LDA arg_1
    STA (guy_addr), Y
    INY
    LDA arg_2
    STA (guy_addr), Y
.endmacro

guy_press_a:
    guy_load GUY_STATE
    CMP GUY_STATE_IDLE
    BNE guy_press_a_ret

    set arg_1, #$FC
    set arg_2, #$80
    guy_save_dec GUY_DY
    LDA GUY_STATE_JUMPING
    guy_save GUY_STATE
JMP guy_press_a_ret

guy_press_l:
    set arg_1, #$FE
    set arg_2, #$80
    guy_save_dec GUY_DX
    LDA GUY_STATE_JUMPING
    guy_save GUY_STATE
JMP guy_press_l_ret

guy_press_r:
    guy_load_dec GUY_DX

    set arg_1, #$01
    set arg_2, #$80
    guy_save_dec GUY_DX
    LDA GUY_STATE_JUMPING
    guy_save GUY_STATE
JMP guy_press_r_ret

guy_check_buttons:
    ; arg_3 : buttons
    LDA arg_3
    AND #$80
    BEQ :+
        JMP guy_press_a
        guy_press_a_ret:
    :

    LDA arg_3
    AND #$02
    BEQ :+
        JMP guy_press_l
        guy_press_l_ret:
    :

    LDA arg_3
    AND #$01
    BEQ :+
        JMP guy_press_r
        guy_press_r_ret:
    :
JMP guy_check_buttons_ret

.proc detect_falling_y_collision
    guy_load_dec GUY_DY
    set arg_3, arg_1
    set arg_4, arg_2
    guy_load_dec GUY_Y
    JSR add_fp              ; guy_y + guy_dy
    LDA arg_1
    CLC
    ADC #$08
    STA y_pos               ; y_pos = guy_y + 8
    guy_load GUY_X
    STA x_pos
    CLC
    ADC #$01
    JSR get_block_val
    CMP #$47
    BEQ :+
    LDA x_pos
    CLC
    ADC #$07
    STA x_pos
    JSR get_block_val
    CMP #$47
    BEQ :+
    guy_save_dec GUY_Y
    RTS
    :
    LDA GUY_STATE_IDLE
    guy_save GUY_STATE

    guy_load_dec GUY_Y
    set arg_3, arg_1
    set arg_4, arg_2

    LDA #$00
    STA arg_1
    STA arg_2
    guy_save_dec GUY_DY

    LDA y_pos
    AND #$F0
    CLC
    SBC #$08
    STA arg_1
    set arg_2, #$00
    JSR sub_fp
    set arg_3, arg_1
    set arg_4, arg_2
    guy_load_dec GUY_Y
    JSR add_fp
    guy_save_dec GUY_Y
    RTS
.endproc

.proc detect_jumping_y_collision
    guy_load_dec GUY_DY
    set arg_3, arg_1
    set arg_4, arg_2
    guy_load_dec GUY_Y
    JSR add_fp
    LDA arg_1
    STA y_pos
    guy_load GUY_X
    STA x_pos
    JSR get_block_val
    CMP #$47
    BEQ :+
    LDA x_pos
    CLC
    ADC #$07
    STA x_pos
    JSR get_block_val
    CMP #$47
    BEQ :+
    guy_save_dec GUY_Y
    RTS
    :
    guy_load_dec GUY_Y
    set arg_3, arg_1
    set arg_4, arg_2

    LDA #$00
    STA arg_1
    STA arg_2
    guy_save_dec GUY_DY

    LDA y_pos
    AND #$F0
    CLC
    ADC #$0F
    STA arg_1
    set arg_2, #$00
    JSR sub_fp
    set arg_3, arg_1
    set arg_4, arg_2
    guy_load_dec GUY_Y
    JSR add_fp
    guy_save_dec GUY_Y
    RTS
.endproc

.proc detect_left_x_collision
    guy_load_dec GUY_DX
    set arg_3, arg_1
    set arg_4, arg_2
    guy_load_dec GUY_X
    JSR add_fp
    LDA arg_1
    STA x_pos           ; x_pos is nieuwe X
    guy_load GUY_Y
    STA y_pos
    JSR get_block_val
    CMP #$47
    ;BEQ :+
    LDA y_pos
    CLC
    ADC #$07
    STA y_pos
    JSR get_block_val
    CMP #$47
    ;BEQ :+
    guy_save_dec GUY_X
    RTS
    :
    LDA #$00
    STA arg_1
    STA arg_2
    guy_save_dec GUY_DX     ; DX should be 0

    LDA x_pos
    AND #$F0
    CLC
    ADC #$10
    STA arg_3
    set arg_4, #$00         ; arg_1.arg_2 is coordinate of block to the left

    guy_load_dec GUY_X
    JSR sub_fp

    set arg_3, arg_1
    set arg_4, arg_2
    guy_load_dec GUY_X
    JSR sub_fp
    guy_save_dec GUY_X
    RTS
.endproc

.proc detect_right_x_collision
    guy_load_dec GUY_DX
    set arg_3, arg_1
    set arg_4, arg_2
    guy_load_dec GUY_X
    JSR add_fp          ;arg1.arg2 = new position
    LDA arg_1
    CLC
    ADC #$08            ; we add 8 because the pattern is 8 pixels
    STA x_pos
    guy_load GUY_Y
    STA y_pos
    JSR get_block_val
    CMP #$47
    BEQ :+
    LDA y_pos
    CLC
    ADC #$07
    STA y_pos
    JSR get_block_val
    CMP #$47
    BEQ :+
    guy_save_dec GUY_X
    RTS
    :
    guy_load_dec GUY_X
    set arg_3, arg_1
    set arg_4, arg_2

    LDA #$00
    STA arg_1
    STA arg_2
    guy_save_dec GUY_DX     ; reset dx to 0

    LDA x_pos
    AND #$F0                ; first 4 bits are the x_number
    CLC
    SBC #$07                ; substract the size of the tile
    STA arg_1
    set arg_2, #$00         ; arg_1.arg_2 is coordinate of block to the left
    JSR sub_fp
    set arg_3, arg_1
    set arg_4, arg_2
    guy_load_dec GUY_X
    JSR add_fp
    guy_save_dec GUY_X
    RTS
.endproc

.proc detect_collision
    ; a = guy_dy
    ; b = guy_y
    ;
    ; if (get_block_val(a + b)) {
    ;     guy_y = a + y_distance_to_block
    ;     guy_dy = 0
    ; }
    guy_load GUY_DY
    BMI :+
        JSR detect_falling_y_collision
        JMP :++
    :
        JSR detect_jumping_y_collision
    :
    guy_load GUY_DX
    BMI :+
        JSR detect_right_x_collision
        JMP :++
    :
        JSR detect_left_x_collision
    :
    RTS
.endproc

guy_move:
    JSR detect_collision
JMP guy_move_ret

guy_update_speed:
    guy_load_dec GUY_GRAV
    set arg_3, arg_1
    set arg_4, arg_2
    guy_load_dec GUY_DY
    JSR add_fp
    CLC
    guy_save_dec GUY_DY

    ; don't adapt speed if speed is 0
    guy_load_dec GUY_DX
    LDA arg_1
    ORA arg_2
    BEQ :+++          ; if GUY_DX != 0
    set arg_4, #$80
    LDA arg_1
    BMI :+          ; if GUY DX > 0
    set arg_3, #$FF
    JMP :++
    :
    set arg_3, #$00
    :
    JSR add_fp
    guy_save_dec GUY_DX
    :
JMP guy_update_speed_ret

guy_init:
    ; guy_addr = guy_address
    ; arg_1: x position
    ; arg_2: y position

    set tmp, arg_2
    set arg_2, #$00
    guy_save_dec GUY_X

    set arg_1, tmp
    guy_save_dec GUY_Y

    set arg_1, #$00
    set arg_2, #$10
    guy_save_dec GUY_GRAV

    set arg_1, #$00
    set arg_2, #$00
    guy_save_dec GUY_DX

    LDA GUY_STATE_IDLE
    guy_save GUY_STATE
JMP guy_init_ret

guy_act:
    ; guy_addr = guy address
    ; arg_1 = buttons

    JMP guy_check_buttons
    guy_check_buttons_ret:

    JMP guy_move
    guy_move_ret:

    JMP guy_update_speed
    guy_update_speed_ret:
JMP guy_act_ret

guy_draw:
    ; guy_addr = guy address
    set sprite_flags, #$0
    set sprite_index, #$85
    guy_load GUY_X
    STA sprite_x_pos
    guy_load GUY_Y
    STA sprite_y_pos
    JSR fast_sprite
JMP guy_draw_ret
