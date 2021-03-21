.segment "ZEROPAGE"

nmi_count:      .res 1 ; is incremented every NMI
tmp:            .res 1 ; temporary variable
x_pos:          .res 1 ; when passing x to a function
y_pos:          .res 1 ; when passing y to a function
button_a:       .res 1
button_b:       .res 1
button_start:   .res 1
button_select:  .res 1
button_u:       .res 1
button_d:       .res 1
button_l:       .res 1
button_r:       .res 1
mario_y:        .res 1
mario_x:        .res 1
sprite_bank_offset: .res 1
sprite_x_pos:   .res 1
sprite_y_pos:   .res 1
sprite_index:   .res 1
sprite_flags:   .res 1
tmpX:           .res 1
tmpSP:          .res 1
retVal:         .res 2 ; return value of a function, if any
SP:             .res 1 ; only useful for indirect addressing
highSP:         .res 1 ; don't touch this. It's so indirect stack addressing can be done.

