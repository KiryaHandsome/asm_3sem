 org $8000
	
	jmp main

loop: 
	ldaa #1
	anda 0,y
	beq  incCounter ; ���� ����� �����
contin	iny
	cpy  #end
	bls  loop	; ���� <= end, �� ����������
	stx  $5
	rti		; ���������� ���������

incCounter:
	inx
	jmp contin
	

main:
	ldx  #$8003 ; ����� ������ ������� � loop
	stx  $fff6  ; ����� ������������ ����������
	ldx $5
	ldy  #$2200 
	ldx  #0     ; ����� � x
end 	equ  $22ff
	swi
	ldx  $5
	
