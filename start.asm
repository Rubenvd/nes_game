.feature c_comments

.include "./segments/header.asm"
.include "./segments/oam.asm"
.include "./segments/tiles.asm"
.include "./segments/vectors.asm"
.include "./segments/zeropage.asm"

.segment "CODE"
.include "./graphics/nmi.asm"
.include "./graphics/ppu.asm"
.include "./objects/mario.asm"
.include "./controls.asm"

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

    JMP draw_mario
    draw_mario_ret:

    JMP check_controls
    check_controls_ret:

    JMP wait_for_nmi
    wait_for_nmi_ret:

    JMP load_sprite
    load_sprite_ret:

    JMP Forever

irq:
    RTI

