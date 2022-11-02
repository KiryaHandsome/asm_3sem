    .model small                       
    .code   

start:  mov ax, dseg   ;set data segment address
        mov ds, ax     ;to ds
               
        mov ah, 02h    ;sub-function of output character 
        mov cx, 19     ;size of msg
        mov si, 0      ;set message offset 
inf:    
        mov dl, 07h    ;07h - ascii code of sound signal(beep)
        int 21h        ;call interrupt which print character in dl to stdout   
        mov dl,msg[si] ;set current character to dl
        int 21h        ;call interrupt
        inc si         ;increment offset
        loop inf       ;repeat until cx > 0
    
        mov ax, 4C00h  ;4C - "terminate program" sub-function, 00 - code of successful execution
        int 21h         
dseg segment
msg DB '!@#$%^&*()<>[Hello]'
dseg ends
  
    end start