; GEOS by Berkeley Softworks
; reverse engineered by Maciej Witkowiak, Michael Steil
;
; pc-analog input driver

.include "jumptab.inc"

.segment "inputdrv"

MouseInit:
	jmp     _MouseInit
SlowMouse:
	jmp     _SlowMouse
UpdateMouse:
	jmp     _UpdateMouse
.ifdef bsw128
SetMouse:
	rts
.endif

LFE89:  .byte   $00
LFE8A:  .byte   $2D
LFE8B:  .byte   $33
LFE8C:  .byte   $39
LFE8D:  .byte   $07
LFE8E:  .byte   $05
LFE8F:  .byte   $39
LFE90:  .byte   $3E
LFE91:  .byte   $43
LFE92:  .byte   $08
LFE93:  .byte   $04

_MouseInit:
LFE94:  lda     #$00
	sta     $3B
	lda     #$00
	sta     $3A
	lda     #$00
	sta     $3C
_SlowMouse:
LFEA0:  rts

_UpdateMouse:
LFEA1:  bit     $30
	bpl     LFEA0
	lda     $01
	pha
	lda     #$35
	sta     $01
	lda     $DC00
	pha
	lda     $DC02
	pha
	lda     $DC03
	pha
	lda     #$FF
	sta     $DC02
	lda     #$40
	sta     $DC00
	ldx     #$66
LFEC4:  nop
	nop
	nop
	dex
	bne     LFEC4
	lda     $D419
	cmp     LFE8A
	bmi     LFEDA
	cmp     LFE8C
	bpl     LFF11
	jmp     LFF42

LFEDA:  sta     $02
	lda     LFE8B
	sec
	sbc     $02
	sta     $02
	lda     LFE8D
	sta     $04
	lda     #$00
	sta     $03
	sta     $05
	ldx     #$02
	ldy     #$04
	jsr     Ddiv
	lda     $3A
	sec
	sbc     $02
	sta     $3A
	lda     $3B
	beq     LFF08
	sbc     #$00
	sta     $3B
LFF05:  jmp     LFF42

LFF08:  bcs     LFF05
	lda     #$00
	sta     $3A
	jmp     LFF42

LFF11:  sec
	sbc     LFE8B
	sta     $02
	lda     LFE8E
	sta     $04
	lda     #$00
	sta     $03
	sta     $05
	ldx     #$02
	ldy     #$04
	jsr     Ddiv
	lda     $3A
	clc
	adc     $02
	sta     $3A
	lda     $3B
	adc     #$00
	sta     $3B
	beq     LFF05
	lda     $3A
	cmp     #$40
	bmi     LFF05
	lda     #$3F
	sta     $3A
LFF42:  lda     $D41A
	cmp     LFE8F
	bmi     LFF52
	cmp     LFE91
	bpl     LFF81
	jmp     LFFAB

LFF52:  sta     $02
	lda     LFE90
	sec
	sbc     $02
	sta     $02
	lda     LFE92
	sta     $04
	lda     #$00
	sta     $03
	sta     $05
	ldx     #$02
	ldy     #$04
	jsr     Ddiv
	lda     $3C
	sec
	sbc     $02
	bcc     LFF7A
	sta     $3C
	jmp     LFFAB

LFF7A:  lda     #$00
	sta     $3C
	jmp     LFFAB

LFF81:  sec
	sbc     LFE90
	sta     $02
	lda     LFE93
	sta     $04
	lda     #$00
	sta     $03
	sta     $05
	ldx     #$02
	ldy     #$04
	jsr     Ddiv
	lda     $3C
	clc
	adc     $02
	cmp     #$C7
	bcs     LFFA7
	sta     $3C
	jmp     LFFAB

LFFA7:  lda     #$C7
	sta     $3C
LFFAB:  lda     #$00
	sta     $DC02
	sta     $DC03
	lda     $DC01
	and     #$0C
	cmp     LFE89
	beq     LFFD0
	sta     LFE89
	asl     a
	asl     a
	asl     a
	asl     a
	bpl     LFFC7
	asl     a
LFFC7:  sta     $8505
	lda     $39
	ora     #$20
	sta     $39
LFFD0:  pla
	sta     $DC03
	pla
	sta     $DC02
	pla
	sta     $DC00
	pla
	sta     $01
	rts
