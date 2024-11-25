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
    vetor db 20 dup(0)
.CODE

main proc
mov ax,@data
mov ds,ax

    push_4 ax,si,cx,di
    xor bx,bx ;ira armazenas a quantidades de 'a'

    mov cx,20
    lea si,vetor
    cld
    loop1:
    LODSB   ;continuara lendo o vetor até o fim incrementa automaticamente
    CMP AL,'a'
    je incrementa 
    cmp al,'A'
    je incrementa
    loop loop1
    jmp fim_conta

    incrementa:
    inc bx
    jmp loop1

    fim_conta:
    POP_4 ax,si,cx,bx
    mov ah,4ch
    int 21h

main endp