 org $8000
	ldy  #$2200 
	ldx  #0     ; ����� � x
end 	equ  $22ff

loop: 
	ldaa #1
	anda 0,y
	beq  incCounter ; ���� ����� �����
cntnue	iny
	cpy  #end
	bls  loop	; ���� <= end, �� ����������
	jmp Done	; ���������� ���������
incCounter:
	inx
	jmp cntnue

Done:
	nop
