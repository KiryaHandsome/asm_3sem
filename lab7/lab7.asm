.model	small
.stack	100h
.data            

Temp_Column db 6      ;NUMBER OF COLUMNS
Temp_Row    db 5      ;NUMBER OF ROWS    
            
ArrayLength          db  ?

Error                db  0Dh,'Error!',0Ah, '$'                                
ErrorInputStr        db  0Dh,'Input error!',0Ah, '$'
HelloMessage         db  0Dh,'Enter matrix 5x6',0Ah, '$'
                                 
InputInterval        db  0Dh,'Interval -127 to 127.', 0Ah, '$'    
AnswerQuotient       db  3 dup('0'),'$'  
AnswerRemainder      db  3 dup(0),'$'  
AnswerArray          db  3 dup(0),'$' 

ResultStr            db  0Dh,'Result: $'      
                                
Buffer               db  ?
                                           
quotient             db ?
remainder            db ?                                                                             
                                
MaxNumLen            db  6  
Len                  db  ?                         
buff                 db  MaxNumLen dup (0)              
                                
minus                dw  0 

matr                 dw  30 dup(0)
                   
ResultStrSum         db  'Sum = $'
correct              db  0Ah,0Dh, '$'
space                db ' $'


str_1                db 0Dh,'Matrix ['
CurrRow              db '0'
str_2                db ']['
CurrColumn           db '0'
str_3                db '] = $'

.code
 
main    proc
        mov     ax,     @data
        mov     ds,     ax
        
        lea  dx, HelloMessage
        call outputString
        call inputArray
        call newLine
        xor     bx, bx               
        xor     ax, ax       
        mov     bl, Temp_Column       
        mov     al, 2
        mul     bl
        mov     bx, ax
        
        xor     cx, cx     
        mov     cl, Temp_Row    
        lea     si, matr         
            
        ForI:
                push cx          
                mov  cl, Temp_Column    
                mov  di, si   
                mov  ax, 0    
        ForJ:
                add  ax, [di]         
                push ax
                mov  ax, [di]
                call show_AColumn
                call spaceproc
                pop  ax
                jo   Trigger                                 
                add  di, 2                         
        loop    ForJ
                
                pop  cx           
                
                push dx                            
                lea dx, ResultStrSum   ;print result        
                call outputString
                pop dx               
                call show_AColumn    
                call newLine
                
        Next:
                add  si, bx       
                loop ForI         
        
        Ending:                               
                                                              
                mov  ax, 4C00h   ;End
                int  21h
        
        Trigger:                        ;End
                mov ah, 09h
                lea dx, Error
                int 21h
                mov ax, 4C00h
                int 21h                            
          
main    endp 

outputString proc
    push ax
    mov ah,09h                                         
    int 21h
    pop ax
    ret
outputString endp    
    
newLine proc
        push dx                          
        lea dx, correct           
        call outputString
        pop dx  
        ret    
newLine endp

spaceproc proc
        push ax
        push bx   
        push cx    
        push dx   
 
        mov  bl, Len           
        mov  cx, 6     
        sub  cx, bx
        loop1:
            mov  ah, 09h
            lea  dx, space   
            int  21h
            loop loop1
        
        pop dx
        pop cx
        pop bx
        pop ax               
ret
spaceproc endp


show_AColumn proc
        push    ax
        push    cx
        push    dx
        push    di
 
        mov     cx, 10
        xor     di, di
 
        or      ax, ax
        jns     Conv       ;jump not sign
        push    ax
        mov     dx, '-'
        mov     ah, 2
        int     21h
        pop     ax
 
        neg     ax
 
Conv:
        xor     dx, dx
        div     cx
        add     dl, '0'
        inc     di
        push    dx
        or      ax, ax
        jnz     Conv
        
Show:
        pop     dx
        mov     ah, 2
        int     21h
        dec     di
        jnz     Show
 
        pop     di
        pop     dx
        pop     cx
        pop     ax
        ret
show_AColumn endp

inputArray proc
    lea di,matr                     
    
    push ax
    push dx
    
    xor ax,ax
    xor dx,dx
    
    mov al,Temp_Row
    mov dl,Temp_Column
    mul dl                                           
    mov cx,ax  
    
    pop dx
    pop ax 
    
    lea dx, InputInterval
    mov ah, 09h 
    int 21h   
             
    inputArrayLoop: 
       call showInput                    
       call inputElementBuff      
       
       test ah, ah
       jnz inputArrayLoop
       
       mov bx,word ptr Buffer
       cmp bl, 0
       jl Minus_bl 
       mov [di], bx
       add di, 2
       call columnRowshow
                            
       loop inputArrayLoop           
       ret
    Minus_bl:
    mov bh, -1
    mov [di], bx
    add di, 2
    call columnRowshow
     
    loop inputArrayLoop           
    ret      
inputArray endp  

columnRowshow proc
    push ax
    push dx
    push si
    
    xor dx,dx
    xor ax,ax 
    
    mov dl, [CurrColumn]
    sub dl, 30h                  
    mov si, offset Temp_Column   
    mov al, [si]
    sub al, 1                    
    cmp dl, al
    je minus5
    add CurrColumn,01
       
    jmp endSHOW
    
    minus5:
        sub CurrColumn, al 
        add CurrRow, 1
    
    endSHOW: 
        pop si
        pop dx
        pop ax 
        ret    
columnRowshow endp    

inputElementBuff proc             
    push cx                       
    inputElMain:                  
        mov Buffer, 0 ;reset buffer          
        
        mov ah,0Ah                  
        lea dx, MaxNumLen         
        int 21h                   
                                  
        mov dl,10                 
        mov ah,2                  
        int 21h                  
                                  
        cmp Len,0                 
        je errInputEl              
                                  
        mov minus,0               ;Reset minus
        xor bx,bx                 ;Reset bx
                                  
        mov bl,Len                
        lea si,Len                
                                  
        add si,bx                 
        mov bl,1                  
                                                         
        xor cx,cx                 
        mov cl,Len                
        inputElLoop:                     
            std                  
            lodsb                 
                                 
            call checkSymbol                           
            cmp ah,1        ;ah - flag     
            je errInputEl        
                                 
            cmp ah,2              
            je nextSym          
                                
            sub al,'0'            
            mul bl               
                                
            test ah,ah           
                                 
            jnz errInputEl       
                                  
            add Buffer,al         ;e.g. 123 = 3 + 2*10 + 1*100
                                  
            jo errInputEl        
            js errInputEl        
                                  
            mov al,bl            
            mov bl,10            
            mul bl                
                                  
            test ah,ah           
            jz ElNextCheck                            
                                  
            cmp ah,3             
            jne errInputEl                           
                                  
            ElNextCheck:          
                mov bl,al         
                jmp nextSym                                        
                                  
            errInputEl:           
                call errorInput   
                jmp exitInputEl   
                                  
            nextSym: 
                xor ah, ah            
        loop inputElLoop          
                                  
    cmp minus,0                   
    je exitInputEl        
    neg Buffer                   
                                  
    exitInputEl:                  
        pop cx                        
        ret                           
inputElementBuff endp

checkSymbol proc                     
    cmp al,'-'                   
    je minusSym                    
                                  
    cmp al,'9'                    
    ja errCheckSym               
                                  
    cmp al,'0'                    
    jb errCheckSym               
                                  
    jmp exitCheckGood      
                                  
    minusSym:                     
        cmp si,offset Len         
        je exitWithMinus          
                                 
    errCheckSym:                  
        mov ah,1                  ;Incorrect symbol
        jmp exitCheckSym          
                                  
    exitWithMinus:                
        mov ah,2                  
        mov minus, 1             
        cmp Len, 1               
        je errCheckSym           
                                  
        jmp exitCheckSym          
                                  
    exitCheckGood:                
        xor ah,ah                 ;Ah = 0 
                                  
    exitCheckSym:                 
        ret                       
checkSymbol endp                              
                                  
errorInput proc                   
    lea dx, ErrorInputStr      
    mov ah, 09h                   
    int 21h                       
    ret                           
errorInput endp                                       
                              
showInput proc                   
    mov ax,di                    
    add ax,1                 
    mov bl, 10
    div bl          
              
    push di                                                    
    push dx
                                                 
    lea dx, str_1            ;print
    call outputString        ;input
    
    pop dx
    pop di                
    ret                           
showInput endp    
 
end     main