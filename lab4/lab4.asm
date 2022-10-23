 org $8000
	
	jmp main

loop: 
	ldaa #1
	anda 0,y
	beq  incCounter ; если число четно
contin	iny
	cpy  #end
	bls  loop	; если <= end, то продолжаем
	stx  $5
	rti		; завершение программы

incCounter:
	inx
	jmp contin
	

main:
	ldx  #$8003 ; адрес первой команды в loop
	stx  $fff6  ; адрес программного прерывания
	ldx $5
	ldy  #$2200 
	ldx  #0     ; ответ в x
end 	equ  $22ff
	swi
	ldx  $5
	
