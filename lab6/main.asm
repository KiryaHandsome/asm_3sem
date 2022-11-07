; multi-segment executable file template.

data segment
    ; add your data here!
    pkey db "Press any key...$"
    msgEnterString db 'Enter string (max length = 200)',  0x0a,0x0d, '$' 
    resultMsg db 'Entered string without words which are numbers: $'
    writeln db 0x0a,0x0d, '$'
    MAX_LEN equ 202
    length dw ?    
    buffer db MAX_LEN dup('$')
ends

stack segment
    dw   128  dup(0)
ends

code segment
start:
; set segment registers:
    mov ax, data
    mov ds, ax
    mov es, ax
 
    mov buffer[0],MAX_LEN - 2 
    call inputString
     
    mov cx, 0          ;clear cx
    mov cl, buffer[1]  ;set real size of string to CL
    mov length, cx
    mov si, 0          ;si - current index, 
    mov bx, 0          ;bx - index to write 
    
process:
    cmp si, length
    jge endProgram
    mov al,buffer[si + 2] 
    cmp al, ' '
    jne isDecimal           ;check for numbers
    call writeCurrentChar
    jmp process       
    
writeWord:    
    call writeCurrentChar
    cmp length, si
    jle  endProgram
    mov al,buffer[si + 2] 
    cmp al, ' '
    je process
    jmp writeWord
        
    ;./////////    
    
    
isDecimal:
    ; TODO 
    ; check word for decimal number
    ;mov dx, 0  ;size of current word
    mov di, si
proceed:
    cmp di, length
    jge endProgram
    mov al, buffer[di + 2] 
    cmp al, ' ' 
    jne isNotSpace
isSpace:    
    mov si, di
    inc si
    jmp process
isNotSpace:
    mov al,buffer[di + 2]     
    cmp al,'9'
    jg isHexadecimal       ;if greater
    cmp al, '0'
    jl isHexadecimal       ;if less
    inc di
    jmp proceed
    
isHexadecimal:
    ; TODO 
    ; check word for hexadecimal number
    jmp writeWord
    ;mov si, bp
    ;jmp incCurrIndex
    
writeCurrentChar proc
    mov ah, buffer[si + 2] 
    mov buffer[bx + 2], ah
    inc si
    inc bx
    ret
writeCurrentChar endp

inputString proc
    lea dx, msgEnterString
    call outputString
    mov dx, offset buffer  
    mov ah, 0ah               ;sub-function of input
    int 21h                   ;read
    ret
inputString endp 
    
outputString proc
    mov ah, 09h                ;move to ah register "String ouput" command
    int 21h                    ;system interrupt
    ret  
outputString endp

endProgram:
    mov buffer[bx + 2], '$' ;make terminated string
    lea dx, writeln
    call outputString
      
    lea dx, resultMsg
    call outputString
    lea dx, buffer + 2
    call outputString                   
    mov ah, 1     ; wait for any key....
    int 21h
    mov ax, 4c00h ; exit to operating system.
    int 21h 

ends

end start ; set entry point and stop the assembler.
