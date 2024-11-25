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
    MSG1 db 'Vetor: $'
.CODE

main proc
    mov ax,@data
    mov ds,ax

    push_4 ax,di,cx,dx
    CLD 
    LEA SI,VETOR

    MOV AH,9
    LEA DX,MSG1
    INT 21H

    MOV CX,20
    MOV AH,2        

    IMPRIMINDO:
    LODSB
    MOV DL,AL
    INT 21h
    LOOP IMPRIMINDO

mov ah,4ch 
int 21h
main endp