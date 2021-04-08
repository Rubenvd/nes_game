.segment "ZEROPAGE"
button_1:       .res 1
nmi_count:      .res 1 ; is incremented every NMI
tmp:            .res 1 ; temporary variable
tmp_a:          .res 1
tmp_b:          .res 1
tmp_c:          .res 1
tmp_d:          .res 1
world_addr:     .res 1
world_addr_hi:  .res 1
guy_addr:       .res 1
guy_addr_hi:    .res 1
player_1:       .res 1  ; buttons
                        ; guy address

guy_1:          .res 14 ; x_pos (decnum)
                        ; y_pos (decnum)
                        ; x_speed (decnum)
                        ; y_speed (decnum)
                        ; health (decnum)
                        ; ID
                        ; state
guy_2:          .res 14

x_pos:          .res 1 ; when passing x to a function
y_pos:          .res 1 ; when passing y to a function
arg_1:          .res 1
arg_2:          .res 1
arg_3:          .res 1
arg_4:          .res 1

mario_dx:       .res 1
mario_dy:       .res 1
mario_y:        .res 1
mario_x:        .res 1
mario_jumping:  .res 1
sprite_bank_offset: .res 1
sprite_x_pos:   .res 1
sprite_y_pos:   .res 1
sprite_index:   .res 1
sprite_flags:   .res 1
tmpX:           .res 1
tmpY:           .res 1
tmpA:           .res 1
tmpSP:          .res 1
retVal:         .res 2 ; return value of a function, if any
SP:             .res 1 ; only useful for indirect addressing
.byte   $01
background_low: .res 1
background_high:.res 1
