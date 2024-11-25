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
    TAMANHO_VETOR DW 0            ; ARMAZENAR O TAMANHO DO VETOR DO USUARIO
    MSG1 DB 10, 13, "DIGITE A STRING:  $"
    MSG2 DB 10, 13, "STRING DIGITADA:  $"
    MSG3 DB 10, 13, "STRING IGUAIS  $"
    MSG4 DB 10, 13, "STRING DIFERENTES $"
    MSG5 DB 13, 10, "DIGITE A LETRA QUE DESEJA PROCURAR: $"
    MSG6 DB 10, 13, "NUMERO DE CARACTERES: $"
    VETOR DB 100 DUP(0)
    COPIA DB 100 DUP(0)
    COMPARACAO DB "tales"
.CODE

main proc
    mov ax, @data
    mov ds, ax
    mov es, ax

    call ler
    call copiar
    call comparar
    call imprimir
    call contar

    mov ah, 4ch
    int 21h
main endp

; Procedimento para ler string
ler proc
    push_4 AX, DI, CX, DX
    CLD 
    MOV AH, 9
    LEA DX, MSG1
    INT 21h

    XOR DX, DX
    MOV CX, 100
    LEA DI, VETOR
    MOV AH, 1
LOOP1:
    INT 21h
    CMP AL, 13                  ; COMPARA COM O ENTER
    JZ FIM1

    CMP AL, 8H                  ;USADO PARA IDENTIFICAR SE O USUARIO USOU O BACKSPACE
    JNZ CONTINUAR

    DEC DI
    XOR AL, AL
    STOSB                       ; SUBSTITUI O ULTIMO CARACTERE POR 0
    DEC DL
    DEC DI
    JMP LOOP1

CONTINUAR:
    STOSB                       ; GRAVA O CARACTERE DIGITADO NA POSIÇÃO QUE DI APONTA
    INC DX
    LOOP LOOP1
FIM1:
    MOV TAMANHO_VETOR, DX
    POP_4 AX, DI, CX, DX
    RET
ler endp

; Procedimento para imprimir string
imprimir proc
    push_4 AX, DI, CX, DX
    CLD
    LEA SI, VETOR

    MOV AH, 9
    LEA DX, MSG2
    INT 21H

    MOV CX, TAMANHO_VETOR
    CMP CX, 0 
    JZ IMPRIMIR_VAZIO
    MOV AH, 2
SAIDA:
    LODSB                       ; LÊ O BYTE APONTADO POR SI E O MOVE PARA AL
    MOV DL, AL                  ; PREPARA PARA IMPRIMIR O CARACTERE LIDO
    INT 21H
    LOOP SAIDA
IMPRIMIR_VAZIO:
    POP_4 AX, SI, CX, DX
    RET
imprimir endp

; Procedimento para copiar string
copiar proc
    push_4 AX, SI, CX, DI 
    LEA SI, VETOR
    LEA DI, COPIA 
    CLD                         ; CONFIGURA DIREÇÃO CRESCENTE

    MOV CX, TAMANHO_VETOR
    CMP CX, 0
    JZ FIM2

LOOP2:
    MOVSB                       ; MOVE BYTE APONTADO POR SI PARA DI, INCREMENTA AMBOS
    LOOP LOOP2
FIM2:
    POP_4 AX, SI, CX, DI
    RET
copiar endp

; Procedimento para comparar strings
comparar proc
    PUSH DX
    push_4 AX, SI, CX, DI
    LEA SI, VETOR
    LEA DI, COMPARACAO
    CLD                         ; CONFIGURA DIREÇÃO CRESCENTE
    
    mov ah,9
    MOV CX, TAMANHO_VETOR
    CMP CX, 0
    JZ FIM3

LOOP3:
    CMPSB                       ; COMPARA BYTE DE VETOR E COMPARACAO, INCREMENTA SI E DI
    JNZ DIFERENTES
    LOOP LOOP3

    LEA DX, MSG3
    INT 21H
    JMP FIM3

DIFERENTES:
    LEA DX, MSG4
    INT 21H

FIM3:
    POP_4 AX, SI, CX, DI
    POP DX
    RET
comparar endp

; Procedimento para contar caracteres
contar proc
    push_4 AX, SI, CX, DI
    XOR BX, BX                  ; ARMAZENA QUANTAS VEZES A LETRA APARECE
    MOV CX, TAMANHO_VETOR
    CMP CX, 0 
    JZ FIM4

    LEA SI, VETOR
    CLD                         ; CONFIGURA DIREÇÃO CRESCENTE

    MOV AH, 9
    LEA DX, MSG5
    INT 21H

    MOV AH, 1
    INT 21H

    CMP AL, 60H
    JG LETRA_MINUSCULA
    MOV DH, AL           
    MOV DL, AL 
    ADD DL, 20H
    JMP CONTAR2

LETRA_MINUSCULA:
    MOV DH, AL
    MOV DL, AL
    SUB DH, 20H

CONTAR2:
    LODSB                       ; LÊ BYTE DE VETOR PARA AL
    CMP AL, DH                  ; COMPARA COM A LETRA EM MAIÚSCULA
    JZ CONTAR3
    CMP AL, DL                  ; COMPARA COM A LETRA EM MINÚSCULA
    JNZ N_CONTAR
CONTAR3:
    INC BX
N_CONTAR:
    LOOP CONTAR2

MOV AH, 9
LEA DX, MSG6
INT 21H

CALL SAIDADECIMAL               ; IMPRIME O NÚMERO DE VEZES QUE A LETRA APARECE
FIM4:
    POP_4 AX, SI, CX, DI 
    RET
contar endp

; Imprime número decimal armazenado em BX
SAIDADECIMAL PROC
    PUSH_4 AX, BX, CX, DX
    MOV AX, BX
    MOV BX, 10
    XOR CX, CX
    XOR DX, DX
OUTPUTDECIMAL:
    DIV BX
    PUSH DX
    XOR DX, DX
    INC CX
    OR AX, AX
    JNZ OUTPUTDECIMAL

    MOV AH, 2
IMPRIMIRDECIMAL:
    POP DX
    OR DL, 30H
    INT 21H
    LOOP IMPRIMIRDECIMAL
    POP_4 AX, BX, CX, DX
    RET
SAIDADECIMAL ENDP

END MAIN
