; GEOS by Berkeley Softworks
; reverse engineered by Maciej Witkowiak, Michael Steil
;
; Koala pad input driver

.include "const.inc" 
.include "geossym.inc"
.include "geosmac.inc" 
.include "c64.inc"

	.segment "inputdrv"

	jmp     _MouseInit

	jmp     _SlowMouse

	jmp     _UpdateMouse

dat0:  .byte 0
dat1:  .byte 0
dat2:  .byte 0
dat3:  .byte 0
dat4:  .byte 0
dat5:  .byte 0
dat6:  .byte 0
	brk
_MouseInit:
	lda     #$00
	sta     mouseXPos+1
	lda     #$08
	sta     mouseXPos
	sta     mouseYPos
	rts

_SlowMouse:
	bit     mouseOn
	bmi     _UpdateMouse
	jmp     LFF36

_UpdateMouse:
	PushB   CPU_DATA
	LoadB   CPU_DATA, IO_IN
	PushB   cia1base+2
	PushB   cia1base+3
	PushB   cia1base+0
	jsr     LFF37
	lda     dat5
	eor     #$FF
	sta     dat5
	bne     LFF28
	jsr     LFF5B
	lda     sidbase+$19
	sub     #$1F
	bcs     LFED0
	lda     #$00
LFED0:  sta     r0
	lsr     r0
	lsr     r0
	lsr     r0
	sub     r0
	cmp     #$0C
	bcc     LFF28
	cmp     #$AB
	beq     LFEE5
	bcs     LFF28
LFEE5:  sta     r0
	lda     sidbase+$1A
	cmp     #$32
	bcc     LFF28
	cmp     #$F9
	beq     LFEF4
	bcs     LFF28
LFEF4:  sta     r0H
	lda     menuNumber
	beq     LFEFE
	jsr     LFF6D
LFEFE:  lda     #$00
	sta     dat6
	lda     r0L
	ldx     dat1
	ldy     dat3
	jsr     LFFB1
	sty     dat3
	stx     dat1
	lda     r0H
	ldx     dat2
	ldy     dat4
	jsr     LFFB1
	sty     dat4
	stx     dat2
	jsr     LFF85
LFF28:  PopB    cia1base+0
	PopB    cia1base+3
	PopB    cia1base+2
	pla
	.byte   $85
LFF36:  .byte   CPU_DATA
LFF37:  rts

	lda     #$00
	sta     cia1base+2
	sta     cia1base+3
	lda     cia1base+1
	and     #$04
	cmp     dat0
	beq     LFF5B
	sta     dat0
	asl     a
	asl     a
	asl     a
	asl     a
	asl     a
	sta     mouseData
	lda     pressFlag
	ora     #$20
	sta     pressFlag
LFF5B:  rts

	lda     #$FF
	sta     cia1base+2
	lda     #$40
	sta     cia1base+0
	ldx     #$6E
Wait:   nop
	nop
	dex
	bne     Wait
LFF6D:  rts

	lda     mouseXPos+1
	sta     r1
	lda     mouseXPos
	ror     r1
	ror     a
	add     #$0C
	sta     dat1
	lda     mouseYPos
	add     #$32
	sta     dat2
LFF85:  rts

	bit     dat6
	bmi     LFFB1
	ldx     #$00
	lda     dat1
	asl     a
	bcc     LFF94
	inx
LFF94:  stx     mouseXPos+1
	and     #$FE
	sta     mouseXPos
	sec
	lda     mouseXPos
	sbc     #$18
	sta     mouseXPos
	lda     mouseXPos+1
	sbc     #$00
	sta     mouseXPos+1
	lda     dat2
	sub     #$32
	and     #$FE
	sta     mouseYPos
LFFB1:  rts

	stx     r0
	tax
	sub     r0
	sta     r0
	bpl     LFFC1
	eor     #$FF
	add     #$01
LFFC1:  cmp     #$06
	bcc     LFFCE
	lda     #$80
	ora     dat6
	sta     dat6
	rts

LFFCE:  rts

	tya
	ldy     r0
	bmi     LFFDE
	beq     LFFE8
	cmp     #$00
	bpl     LFFE8
	bmi     LFFE0
	cmp     #$00
LFFDE:  bmi     LFFE8
LFFE0:  lda     #$80
	ora     dat6
	sta     dat6
LFFE8:  rts
