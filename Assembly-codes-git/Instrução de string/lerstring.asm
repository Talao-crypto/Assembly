.model SMALL
.STACK 100h

push_4 MACRO R1, R2, R3, R4
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
ENDM

POP_4 MACRO R1, R2, R3, R4
    POP R4
    POP R3
    POP R2 
    POP R1
ENDM

.DATA
    MSG1 db 'Digite a string: $'    
    vetor db 20 dup(0)            
.CODE

MAIN PROC
    MOV AX, @DATA                 
    MOV DS, AX

    push_4 AX, DI, CX, DX          ; Salva os valores originais de AX, DI, CX, e DX
    
    CLD                            ; Configura direção crescente (DI será incrementado automaticamente)
    
    
    MOV AH, 9
    LEA DX, MSG1                   
    INT 21H                        

    ; Configura para ler a string
    XOR DX, DX                     
    MOV CX, 20                     
    LEA DI, vetor                  ; Faz DI apontar para o início do vetor
    MOV AH, 1                      

lendo:
    INT 21H                        
    CMP AL, 13                     ; Verifica se o caractere é Enter (código ASCII 13)
    JZ fim                         ; Se for Enter, finaliza a leitura
    STOSB                          ; Armazena o caractere digitado em AL no vetor
    INC DX                         ; Incrementa o contador de caracteres digitados
    LOOP lendo                     ; Continua lendo enquanto CX > 0

fim:
    POP_4 AX, DI, CX, DX           ; Restaura os valores originais dos registradores
    RET
MAIN ENDP

END MAIN
