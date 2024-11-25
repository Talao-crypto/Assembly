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
    vetor db 20 dup
    comparação db 'cu'
.CODE

main proc
    mov ax,@data
    mov ds,ax

    push DX
    push_4 AX,SI,CX,DI

    ;apontar para o começo
    lea si,vetor
    lea di,comparação
    cld ;crescente

    mov cx,20
    loop1
    CMPSB   ;compara o valor si com di
    jnz DIFERENTES 
    loop loop1

    ;mensagem de iguais
    jmp fim

    DIFERENTES
    ;mensagem de diferentes
    fim:
    mov ah,4ch 
    int 21h
main endp
end main