 	org $8000 
	ldd   #$1050
	ldx   #$ffff ; set values to registers
 	ldy   #$7777 

 	stx   $01
 	sty   $03  ; store x, y and d registers in memory
 	std   $05
	ldd   #0   ; clear double register d

	ldx   #$0a
	staa  0,x  ; set zero to some memory
	ldy   #6
loop:	          
	addb  0,y
	adca  0,x  ; a - counter of carries
	dey	   ; decrement y
        bne   loop ; branch if not equal to zero
	
	; d is answer