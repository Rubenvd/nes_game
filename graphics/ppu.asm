.include "./color.asm"
.include "../tools/macros.asm"

PPU_CTRL    = $2000
/*
    76543210
    | ||||||
    | ||||++- Base nametable address
    | ||||    (0 = $2000; 1 = $2400; 2 = $2800; 3 = $2C00)
    | |||+--- VRAM address increment per CPU read/write of PPUDATA
    | |||     (0: increment by 1, going across; 1: increment by 32, going down)
    | ||+---- Sprite pattern table address for 8x8 sprites (0: $0000; 1: $1000)
    | |+----- Background pattern table address (0: $0000; 1: $1000)
    | +------ Sprite size (0: 8x8; 1: 8x16)
    |
    +-------- Generate an NMI at the start of the vertical blanking interval vblank (0: off; 1: on)
*/

PPU_MASK    = $2001
/*
    76543210
    ||||||||
    |||||||+- Grayscale (0: normal color; 1: AND all palette entries
    |||||||   with 0x30, effectively producing a monochrome display;
    |||||||   note that colour emphasis STILL works when this is on!)
    ||||||+-- Disable background clipping in leftmost 8 pixels of screen
    |||||+--- Disable sprite clipping in leftmost 8 pixels of screen
    ||||+---- Enable background rendering
    |||+----- Enable sprite rendering
    ||+------ Intensify reds (and darken other colors)
    |+------- Intensify greens (and darken other colors)
    +-------- Intensify blues (and darken other colors)
*/
PPU_STATUS  = $2002
OAM_ADDR    = $2003
OAM_DATA    = $2004
PPU_SCROLL  = $2005
PPU_ADDR    = $2006
PPU_DATA    = $2007
OAM_DMA     = $4014

.segment "RODATA"

palette_background:
    .byte BLACK, LIGHTEST_YELLOW, MEDIUM_ORANGE,     DARK_ORANGE
    .byte BLACK, DARK_CHARTREUSE, MEDIUM_CHARTREUSE, LIGHT_CHARTREUSE
    .byte BLACK, DARK_BLUE,       MEDIUM_BLUE,       LIGHT_BLUE
    .byte BLACK, DARK_GRAY,       MEDIUM_GRAY,       LIGHTEST_GRAY

palette_sprites:
    .byte BLACK, LIGHTEST_YELLOW, LIGHT_ORANGE, MEDIUM_ORANGE
    .byte BLACK, MEDIUM_PURPLE,   LIGHT_PURPLE, LIGHTEST_PURPLE
    .byte BLACK, MEDIUM_CYAN,     LIGHT_CYAN,   LIGHTEST_CYAN
    .byte BLACK, MEDIUM_INDIGO,   LIGHT_INDIGO, LIGHTEST_INDIGO

.segment "CODE"

init_ppu:
    set PPU_CTRL, #$90
    set PPU_MASK, #$1E
JMP init_ppu_ret

init_scroll:
    LDA PPU_STATUS
    LDA #$00
    STA PPU_SCROLL
    LDA #$00
    STA PPU_SCROLL
JMP init_scroll_ret

load_palette:
    PHA
    LDA PPU_STATUS      ; read makes us reset the latch
    set PPU_ADDR, #$3F
    set PPU_ADDR, #$00  ; load $3F00 as the PPU address
    LDX #$00
    :
        LDA palette_background, X
        STA PPU_DATA    ; write data to PPU_ADDR
        INX
        CPX #$20
    BNE :-     ; go over it #20 times (32)
    PLA
JMP load_palette_ret

load_sprite:
    set OAM_ADDR, #$00
    set OAM_DMA, #$02
JMP load_sprite_ret

.proc fast_sprite
    SPRITE_BANK = $0200
    prologue

    LDX sprite_bank_offset

    LDA sprite_y_pos
    STA SPRITE_BANK, X

    INX
    LDA sprite_index
    STA SPRITE_BANK, X

    INX
    LDA sprite_flags
    STA SPRITE_BANK, X

    INX
    LDA sprite_x_pos
    STA SPRITE_BANK, X

    INX
    STX sprite_bank_offset

    epilogue 0
    RTS
.endproc

clear_background:
    LDA PPU_STATUS
    set PPU_ADDR, #$20
    set PPU_ADDR, #$00
    LDA #$24
    LDY #$20
    :
        LDX #$20
        :
            STA PPU_DATA
        DEX
        BNE :-
    DEY
    BNE :--
JMP clear_background_ret

get_block_val:
    LDA y_pos
    CLC
    ROL
    ROL
    ROL
    ROL
    ADC x_pos

    CLC
    ADC #<background1
    STA background_low
    LDA #>background1
    ADC #$0
    STA background_high
    STX tmpX
    LDX #$0
    LDA (background_low, X)
    LDX tmpX
;JMP get_block_val_ret

draw_background:
    LDA PPU_STATUS
    set PPU_ADDR, #$20
    set PPU_ADDR, #$00

    set background_low, #<background1
    set background_high, #>background1

    LDX #$00
    LDY #$00
    :
        LDA (background_low), Y
        STA PPU_DATA
        STA PPU_DATA
    CLC
    INY
    BNE :+
    JMP draw_background_ret
    :
    TYA
    AND #$0F
    BNE :--

    CPX #$00
    BNE :+
        LDX #$01
        TYA
        SEC
        SBC #$10
        TAY
        JMP :--
    :
    LDX #$00
    JMP :---
JMP draw_background_ret

load_attribute:
    CLC
    LDA PPU_STATUS
    set PPU_ADDR, #$23
    set PPU_ADDR, #$C0
    LDX #$00
    :
        LDA attribute, X
        STA PPU_DATA
        INX
        CPX #$40
        BNE :-
JMP load_attribute_ret
