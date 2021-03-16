.feature c_comments

.include "./segments/header.asm"

.segment "ZEROPAGE"
    nmi_count:      .res 1 ; is incremented every NMI
    tmp:            .res 1 ; temporary variable
    x_pos:          .res 1 ; when passing x to a function
    y_pos:          .res 1 ; when passing y to a function
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

Forever:
    JSR wait_for_nmi
    
    INC $0700
    set x_pos, $0700
    set y_pos, $0700
    
    LDA #$40
    PHA

    LDA #$00
    PHA

    LDA #$00
    PHA

    JSR draw_sprite_try

    LDA #$2
    PHA
    LDA #$11
    PHA
    JSR rec_mul

    JSR load_sprite

    JMP Forever

irq:
    RTI

.proc rec_mul
    prologue

    NOP
    NOP
    ldarg 1
    TAX
    ldarg 2
    TAY
    BEQ skipScroll
    TXA
    ROL
    DEY
    
    STA tmp
    TYA
    PHA
    LDA tmp
    PHA

    JSR rec_mul
    JMP endfunction
    skipScroll:
    STX retVal
    endfunction:
    NOP
    NOP
    epilogue 2
    RTS
.endproc

.segment "OAM"
    oam: .res 256        ; sprite OAM data to be uploaded by DMA
