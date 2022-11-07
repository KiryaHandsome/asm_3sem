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
    
writeWord:                      ;write
    call writeCurrentChar
    cmp length, si              ;check for end of string
    jle  endProgram
    mov al,buffer[si + 2]       ;copy current index to al
    cmp al, ' '
    je process
    jmp writeWord
    
    
isDecimal:
    mov di, si           ;copy current index
proceed1:
    cmp di, length       ;check for end of string
    jge endProgram
    mov al, buffer[di + 2] 
    cmp al, ' ' 
    jne isNotSpace1
isSpace1:    
    mov si, di           ;move current index 
    inc si
    jmp process
isNotSpace1:
    mov al,buffer[di + 2]     
    call isDigit
    and ah, ah
    jz isHexadecimal
    inc di
    jmp proceed1
    
isHexadecimal:
    ; TODO 
    ; check word for hexadecimal number
    mov di, si
    mov al, buffer[di + 2]
    cmp al, '0'
    jne writeWord
    mov al, buffer[di + 2 + 1]
    cmp al, 'x'
    jne writeWord
    add di, 2
proceed2:
    cmp di, length       ;check for end of string
    jge endProgram
    mov al, buffer[di + 2]
    cmp al, ' ' 
    jne isNotSpace2
isSpace2:    
    mov si, di           ;move current index 
    inc si
    jmp process
isNotSpace2:    
    mov al, buffer[di + 2]
    inc di
    call isDigit
    and ah, ah
    jnz proceed2
    call isABCDEF
    and ah, ah   
    jz writeWord         ;if is not abcdef
    inc di 
    jmp proceed2
    
isDigit proc
    cmp al,'9'        ;check for number
    jg isNotDig       ;if greater
    cmp al, '0'
    jl isNotDig       ;if less
isDig:
    mov ah, 1
    ret 
isNotDig:
    mov ah, 0
    ret
isDigit endp

isABCDEF proc
    mov ah, 'a'
    mov cx, 6
isSmallLetter:         ;check for small letters 
    cmp al, ah
    je exitTrue
    inc ah
    loop isSmallLetter
    mov ah, 'A'
    mov cx, 6
isBigLetter:          ;check for big letters
    cmp al, ah
    je exitTrue
    inc ah
    loop isBigLetter    
exitFalse:
    mov ah, 0
    ret
exitTrue:
    mov ah, 1
    ret     
isABCDEF endp
    
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