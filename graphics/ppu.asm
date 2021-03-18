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

.proc init_ppu
    PHA
    set PPU_CTRL, #$80
    set PPU_MASK, #$10
    PLA
    RTS
.endproc

.proc load_palette
    PHA
    LDA PPU_STATUS      ; read makes us reset the latch
    set PPU_ADDR, #$3F
    set PPU_ADDR, #$00  ; load $3F00 as the PPU address
    LDX #$00
    loadPalette:
        LDA palette_background, X
        STA PPU_DATA    ; write data to PPU_ADDR
        INX
        CPX #$20
    BNE loadPalette     ; go over it #20 times (32)
    PLA
    RTS
.endproc

.proc load_sprite
    PHA
    set OAM_ADDR, #$00
    set OAM_DMA, #$02
    PLA
    RTS
.endproc

.proc draw_sprite   ; pattern_table_offset sprite_index flags
    prologue

    ; the real code
    CLC
    ldarg 1         ; pattern_table_offset
    ROL
    ROL
    TAX
    
    LDA y_pos
    STA $0200, X    ; y_pos

    INX
    ldarg 2
    STA $0200, X    ; sprite_index
    
    INX
    ldarg 3
    STA $0200, X    ; flags

    INX
    LDA x_pos
    STA $0200, X    ; x_pos
    
    CLC
    epilogue 3

    RTS
.endproc

