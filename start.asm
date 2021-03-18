.feature c_comments

.include "./segments/header.asm"

.segment "ZEROPAGE"
    nmi_count:      .res 1 ; is incremented every NMI
    tmp:            .res 1 ; temporary variable
    x_pos:          .res 1 ; when passing x to a function
    y_pos:          .res 1 ; when passing y to a function
    mario_x:        .res 1
    mario_y:        .res 1
    tmpX:           .res 1
    tmpSP:          .res 1
    retVal:         .res 2 ; return value of a function, if any
    SP:             .res 1 ; only useful for indirect addressing
    highSP:         .res 1 ; don't touch this. It's so indirect stack addressing can be done.

.include "./segments/vectors.asm"
.include "./segments/tiles.asm"

.segment "CODE"
.include "./graphics/nmi.asm"
.include "./graphics/ppu.asm"

reset:
    SEI
    CLD

    set highSP, #$01
    
    JSR load_palette
    JSR init_ppu

    set mario_x, #$50
    set mario_y, #$80

    JSR wait_for_nmi
Forever:
    
    set x_pos, mario_x
    set y_pos, mario_y
    LDA #$00
    PHA
    LDA #$36
    PHA
    LDA #$00
    PHA
    JSR draw_sprite

    LDA mario_y
    STA y_pos
    LDA mario_x
    CLC
    ADC #$08
    STA x_pos
    LDA #$00
    PHA
    LDA #$37
    PHA
    LDA #$01
    PHA
    JSR draw_sprite

    LDA mario_x
    STA x_pos
    LDA mario_y
    CLC
    ADC #$08
    STA y_pos
    LDA #$00
    PHA
    LDA #$38
    PHA
    LDA #$02
    PHA
    JSR draw_sprite

    LDA mario_y
    CLC
    ADC #$08
    STA y_pos
    LDA mario_x
    CLC
    ADC #$08
    STA x_pos
    LDA #$00
    PHA
    LDA #$39
    PHA
    LDA #$03
    PHA
    JSR draw_sprite

    JMP check_controls
    after_check:
    JSR wait_for_nmi
    JSR load_sprite

    JMP Forever

irq:
    RTI

check_controls:
    CONTROLLER_1 = $4016
    CONTROLLER_2 = $4017

    set CONTROLLER_1, #$01
    set CONTROLLER_1, #$00

    LDA CONTROLLER_1    ; A
    LDA CONTROLLER_1    ; B
    LDA CONTROLLER_1    ; Select
    LDA CONTROLLER_1    ; Start

    LDA CONTROLLER_1    ; Up
    AND #$01
    BEQ up_not_pressed
    LDX mario_y
    DEX
    STX mario_y
    up_not_pressed:

    LDA CONTROLLER_1    ; Down
    AND #$01
    BEQ down_not_pressed
    LDX mario_y
    INX
    STX mario_y
    down_not_pressed:

    LDA CONTROLLER_1    ; Left
    AND #$01
    BEQ left_not_pressed
    LDX mario_x
    DEX
    STX mario_x
    left_not_pressed:

    LDA CONTROLLER_1    ; Right
    AND #$01
    BEQ right_not_pressed
    LDX mario_x
    INX
    STX mario_x
    right_not_pressed:

    JMP after_check


.segment "OAM"
    oam: .res 256        ; sprite OAM data to be uploaded by DMA
