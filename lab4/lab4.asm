 org $8000
	ldy  #$2200 
	ldx  #0     ; ответ в x
end 	equ  $22ff

loop: 
	ldaa #1
	anda 0,y
	beq  incCounter ; если число четно
cntnue	iny
	cpy  #end
	bls  loop	; если <= end, то продолжаем
	jmp Done	; завершение программы
incCounter:
	inx
	jmp cntnue

Done:
	nop
