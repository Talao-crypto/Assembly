.MODEL SMALL
.STACK 100h

;guardar o conteudo de até 4 registradores
push_4 MACRO R1, R2, R3, R4
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
ENDM

;restaurar os valores salvos nos registradores
POP_4 MACRO R1, R2, R3, R4
    POP R4
    POP R3
    POP R2 
    POP R1
ENDM

PULAR_LINHA MACRO
    PUSH AX
    PUSH DX 

    MOV AH,2
    MOV DL,10
    INT 21H
    MOV DL,13
    INT 21H

    POP DX
    POP AX
ENDM

.DATA 

    vetor db 'Tales'
    copia db 6 dup(0)
.CODE

main proc
    mov ax,@data
    mov ds,ax
    
    push_4 ax,si,cx,di
    lea si, vetor
    lea di, copia
    cld  ;vai incrementar automaticamente pois esta na posição crescente

    mov cx,6
    loop1:
    MOVSB   ;joga no di o valor de si
    loop loop1

    fim:
    POP_4 ax,si,cx,di
    mov ah,4ch
    int 21H

main endp


