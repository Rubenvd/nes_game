.feature c_comments

.include "./segments/header.asm"
.include "./segments/oam.asm"
.include "./segments/tiles.asm"
.include "./segments/vectors.asm"
.include "./segments/zeropage.asm"

.segment "CODE"
.include "./graphics/background.asm"
.include "./graphics/nmi.asm"
.include "./graphics/ppu.asm"
.include "./objects/mario.asm"
.include "./controls.asm"

reset:
    SEI
    CLD

    JMP load_palette
    load_palette_ret:
    JMP init_ppu
    init_ppu_ret:

    JMP init_mario
    init_mario_ret:

    JMP clear_background
    clear_background_ret:

    JMP draw_background
    draw_background_ret:

    JMP load_attribute
    load_attribute_ret:

    JMP init_scroll
    init_scroll_ret:

Forever:
    JMP draw_mario
    draw_mario_ret:

    JMP check_controls
    check_controls_ret:

    JMP move_mario
    move_mario_ret:

    JMP wait_for_nmi
    wait_for_nmi_ret:

    JMP load_sprite
    load_sprite_ret:

    JMP Forever

irq:
    RTI

