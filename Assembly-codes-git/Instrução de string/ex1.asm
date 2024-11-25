.MODEL SMALL
.STACK 100h

.DATA
    TAMANHO_VETOR DW 0                  ; Armazenar o tamanho do vetor do usuário
    MSG1 DB 10, 13, "DIGITE A STRING (10 CARACTERES): $"
    MSG2 DB 10, 13, "STRING DIGITADA: $"
    MSG3 DB 10, 13, "STRINGS SAO IGUAIS $"
    MSG4 DB 10, 13, "STRINGS SAO DIFERENTES $"
    MSG5 DB 10, 13, "QUANTIDADE DE 'a': $"
    VETOR DB 10 DUP(0)                  ; Vetor para armazenar string digitada
    COMPARACAO DB "talesabcde"          ; String fixa para comparação
    LETRAS_A DW 0                      ; Para armazenar a quantidade de 'a'

.CODE

main proc
    MOV AX, @DATA
    MOV DS, AX
    MOV ES, AX

    CALL ler_vetor
    CALL comparar
    CALL contar_a

    MOV AH, 4CH
    INT 21H
main endp

; Procedimento para ler string de até 10 caracteres
ler_vetor proc
    MOV AH, 9
    LEA DX, MSG1                      ; Exibe mensagem de entrada
    INT 21H

    XOR DI, DI                        ; Configura DI para início do vetor
    MOV CX, 10                        ; Tamanho do vetor fixo
    MOV AH, 1                         ; Função para leitura de caracteres
LER_LOOP:
    INT 21H
    CMP AL, 13                        ; Verifica Enter
    JE FIM_LER
    STOSB                             ; Armazena caractere em VETOR[DI]
    LOOP LER_LOOP
FIM_LER:
    MOV TAMANHO_VETOR, 10             ; Define tamanho fixo do vetor
    RET
ler_vetor endp

; Procedimento para comparar strings
comparar proc
    LEA SI, VETOR                     ; Ponteiro para o vetor
    LEA DI, COMPARACAO                ; Ponteiro para string fixa
    MOV CX, 10                        ; Tamanho fixo para comparação
    CLD                               ; Configura direção crescente
    REPE CMPSB                        ; Compara enquanto forem iguais
    JNE DIFERENTES
    MOV AH, 9
    LEA DX, MSG3                      ; Exibe mensagem de igualdade
    INT 21H
    JMP FIM_COMPARAR
DIFERENTES:
    MOV AH, 9
    LEA DX, MSG4                      ; Exibe mensagem de diferença
    INT 21H
FIM_COMPARAR:
    RET
comparar endp

; Procedimento para contar quantidade de 'a'
contar_a proc
    XOR SI, SI                        ; Ponteiro para o início de VETOR
    MOV CX, 10                        ; Tamanho fixo do vetor
    XOR AX, AX                        ; Contador de 'a'
    MOV DL, 'a'                       ; Letra a ser contada
CONTA_LOOP:
    LODSB                             ; Lê byte de VETOR para AL
    CMP AL, DL                        ; Compara com 'a'
    JNZ NAO_E_A
    INC AX                            ; Incrementa contador se for 'a'
NAO_E_A:
    LOOP CONTA_LOOP
    MOV LETRAS_A, AX                  ; Armazena quantidade de 'a'

    ; Exibe a quantidade de 'a'
    MOV AH, 9
    LEA DX, MSG5
    INT 21H
    CALL exibir_quantidade
    RET
contar_a endp

; Procedimento para exibir número armazenado em AX
exibir_quantidade proc
    PUSH AX                           ; Salva o número em AX
    XOR DX, DX                        ; Zera DX
    MOV BX, 10                        ; Divisor para base decimal
    DIV BX                            ; AX / 10, DX contém o resto
    ADD DL, 30H                       ; Converte unidade para ASCII
    MOV AH, 2
    INT 21H                           ; Imprime unidade
    POP AX                            ; Restaura o número original
    RET
exibir_quantidade endp

END MAIN
