; GEOS by Berkeley Softworks
; reverse engineered by Maciej Witkowiak, Michael Steil
;
; pc-analog input driver

.include "geossym.inc"
.include "geosmac.inc"
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

lastF:	.byte   $00
xlow:	.byte   $2D
xav:	.byte   $33
xhigh:	.byte   $39
xlstep:	.byte   $07
xhstep:	.byte   $05
ylow:	.byte   $39
yav:	.byte   $3E
yhigh:	.byte   $43
ylstep:	.byte   $08
yhstep:	.byte   $04

_MouseInit:
	lda     #$00
	sta     $3B
	lda     #$00
	sta     mouseXPos
	lda     #$00
	sta     mouseYPos
_SlowMouse:
rts0:   rts

_UpdateMouse:
	bit     $30
	bpl     rts0
	lda     $01
	pha
	lda     #$35
	sta     $01
	PushB   cia1base+0
	PushB   cia1base+2
	PushB   cia1base+3
	lda     #$FF
	sta     cia1base+2
	lda     #%01000000
	sta     cia1base+0
	ldx     #$66
LFEC4:  nop
	nop
	nop
	dex
	bne     LFEC4
	lda     sidbase+$19
	cmp     xlow
	bmi     XLO
	cmp     xhigh
	bpl     XHI
	jmp     ReadY

XLO:	sta     r0L
	lda     xav
	sub     r0L
	sta     r0L
	lda     xlstep
	sta     r1L
	lda     #$00
	sta     r0H
	sta     r1H
	ldx     #r0
	ldy     #r1
	jsr     Ddiv
	lda     mouseXPos
	sub     r0L
	sta     mouseXPos
	lda     $3B
	beq     LFF08
	sbc     #$00
	sta     $3B
LFF05:  jmp     ReadY

LFF08:  bcs     LFF05
	lda     #$00
	sta     mouseXPos
	jmp     ReadY

XHI:	sub     xav
	sta     r0L
	lda     xhstep
	sta     r1L
	lda     #$00
	sta     r0H
	sta     r1H
	ldx     #r0
	ldy     #r1
	jsr     Ddiv
	lda     mouseXPos
	clc
	adc     r0
	sta     mouseXPos
	lda     $3B
	adc     #$00
	sta     $3B
	beq     LFF05
	lda     mouseXPos
	cmp     #$40
	bmi     LFF05
	lda     #$3F
	sta     mouseXPos
ReadY:	lda     sidbase+$1A
	cmp     ylow
	bmi     YLO
	cmp     yhigh
	bpl     YHI
	jmp     ReadF

YLO:	sta     r0L
	lda     yav
	sub     r0L
	sta     r0L
	lda     ylstep
	sta     r1L
	lda     #$00
	sta     r0H
	sta     r1H
	ldx     #r0
	ldy     #r1
	jsr     Ddiv
	lda     mouseYPos
	sub     r0
	bcc     LFF7A
	sta     mouseYPos
	jmp     ReadF

LFF7A:  lda     #$00
	sta     mouseYPos
	jmp     ReadF

YHI:	sub     yav
	sta     r0L
	lda     yhstep
	sta     r1L
	lda     #$00
	sta     r0H
	sta     r1H
	ldx     #r0
	ldy     #r1
	jsr     Ddiv
	lda     mouseYPos
	clc
	adc     r0
	cmp     #$C7
	bcs     LFFA7
	sta     mouseYPos
	jmp     ReadF

LFFA7:  lda     #$C7
	sta     mouseYPos
ReadF:	lda     #$00
	sta     cia1base+2
	sta     cia1base+3
	lda     cia1base+1
	and     #%00001100
	cmp     lastF
	beq     LFFD0
	sta     lastF
	asl     a
	asl     a
	asl     a
	asl     a
	bpl     LFFC7
	asl     a
LFFC7:  sta     mouseData
	lda     $39
	ora     #$20
	sta     $39
LFFD0:  PopB    cia1base+3
	PopB    cia1base+2
	PopB    cia1base+0
	pla
	sta     $01
	rts
