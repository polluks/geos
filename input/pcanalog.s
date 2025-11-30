; GEOS by Berkeley Softworks
; reverse engineered by Maciej Witkowiak, Michael Steil
;
; pc-analog input driver

.include "geossym.inc"
.include "jumptab.inc"
.include "c64.inc"

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

LFE89:	.byte   $00
LFE8A:	.byte   $2D
LFE8B:	.byte   $33
LFE8C:	.byte   $39
LFE8D:	.byte   $07
LFE8E:	.byte   $05
LFE8F:	.byte   $39
LFE90:	.byte   $3E
LFE91:	.byte   $43
LFE92:	.byte   $08
LFE93:	.byte   $04

_MouseInit:
LFE94:  lda     #$00
	sta     $3B
	lda     #$00
	sta     $3A
	lda     #$00
	sta     $3C
_SlowMouse:
rts0:   rts

_UpdateMouse:
LFEA1:  bit     $30
	bpl     rts0
	lda     $01
	pha
	lda     #$35
	sta     $01
	lda     cia1base+0
	pha
	lda     cia1base+2
	pha
	lda     cia1base+3
	pha
	lda     #$FF
	sta     cia1base+2
	lda     #$40
	sta     cia1base+0
	ldx     #$66
LFEC4:  nop
	nop
	nop
	dex
	bne     LFEC4
	lda     sidbase+$19
	cmp     LFE8A
	bmi     LFEDA
	cmp     LFE8C
	bpl     LFF11
	jmp     LFF42

LFEDA:  sta     r0L
	lda     LFE8B
	sec
	sbc     r0L
	sta     r0L
	lda     LFE8D
	sta     r1L
	lda     #$00
	sta     r0H
	sta     r1H
	ldx     #r0
	ldy     #r1
	jsr     Ddiv
	lda     $3A
	sec
	sbc     r0L
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
	sta     r0L
	lda     LFE8E
	sta     r1L
	lda     #$00
	sta     r0H
	sta     r1H
	ldx     #r0
	ldy     #r1
	jsr     Ddiv
	lda     $3A
	clc
	adc     r0
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
LFF42:  lda     sidbase+$1A
	cmp     LFE8F
	bmi     LFF52
	cmp     LFE91
	bpl     LFF81
	jmp     LFFAB

LFF52:  sta     r0L
	lda     LFE90
	sec
	sbc     r0L
	sta     r0L
	lda     LFE92
	sta     r1L
	lda     #$00
	sta     r0H
	sta     r1H
	ldx     #r0
	ldy     #r1
	jsr     Ddiv
	lda     $3C
	sec
	sbc     r0
	bcc     LFF7A
	sta     $3C
	jmp     LFFAB

LFF7A:  lda     #$00
	sta     $3C
	jmp     LFFAB

LFF81:  sec
	sbc     LFE90
	sta     r0L
	lda     LFE93
	sta     r1L
	lda     #$00
	sta     r0H
	sta     r1H
	ldx     #r0
	ldy     #r1
	jsr     Ddiv
	lda     $3C
	clc
	adc     r0
	cmp     #$C7
	bcs     LFFA7
	sta     $3C
	jmp     LFFAB

LFFA7:  lda     #$C7
	sta     $3C
LFFAB:  lda     #$00
	sta     cia1base+2
	sta     cia1base+3
	lda     cia1base+1
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
	sta     cia1base+3
	pla
	sta     cia1base+2
	pla
	sta     cia1base+0
	pla
	sta     $01
	rts
