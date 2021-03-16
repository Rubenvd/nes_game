.segment "HEADER"
INES_MAPPER = 0 
INES_MIRROR = 1 
INES_SRAM   = 0 

.byte 'N', 'E', 'S', $1A ; NES, met dos EOF
.byte $02 ; PRG ROM size in 16KB units
.byte $01 ; CHR ROM size in 8KB units
.byte INES_MIRROR | (INES_SRAM << 1 ) | ((INES_MAPPER & $F) << 4)
.byte (INES_MAPPER & %11110000)
.byte $0, $0, $0, $0, $0, $0, $0, $0
; header moet 16 bits groot zijn

