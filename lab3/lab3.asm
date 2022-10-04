	org $8000

 	ldaa     #$ff
 	ldab     #0
 	ldy      #1   ; pointer to memory with a and b
 	std      0,y 
 	ldaa     #8   ; counter
	staa     $5   ; load counter to memory 
 	ldd      #0   ; clear accumulator d
loop:
	lsld
	lsl     0,y   ; logical shift left of b
	adcb    #0    ; set bit 7 of a to bit 0 of accumulator d 
	lsld	      ; logical shift left acc d  
	lsl     1,y   ; logical shift left of a
	adcb    #0
	dec	$5    ; decrement counter
	bne	loop  
	
	xgdx	      ; return value to x	