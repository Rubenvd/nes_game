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
.include "./objects/guy.asm"
.include "./controls.asm"
.include "./tools/fixed_point.asm"

reset:
    SEI
    CLD

    set world_addr_hi, #>background1
    set world_addr, #<background1

    JMP load_palette
    load_palette_ret:
    JMP init_ppu
    init_ppu_ret:

    set guy_addr_hi, #>guy_1
    set guy_addr, #<guy_1

    set arg_1, #$80
    set arg_2, #$80
    JMP guy_init
    guy_init_ret:

    JMP clear_background
    clear_background_ret:

    JMP draw_background
    draw_background_ret:

    JMP load_attribute
    load_attribute_ret:

    JMP init_scroll
    init_scroll_ret:

Forever:
    JMP check_controls
    check_controls_ret:

    set arg_3, button_1
    JMP guy_act
    guy_act_ret:

    JMP guy_draw
    guy_draw_ret:

    JMP wait_for_nmi
    wait_for_nmi_ret:

    JMP load_sprite
    load_sprite_ret:

    JMP Forever

irq:
    RTI
