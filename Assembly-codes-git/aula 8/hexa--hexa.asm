TITLE Batalha Naval - Assembly 8086

.MODEL SMALL
.STACK 100h
.DATA
    matriz DB 400 DUP(0)        ; Matriz 20x20
    msgInicio DB 13,10,'Bem-vindo ao Batalha Naval!$', 0Dh, 0Ah, '$'
    msgTiro DB 13,10,'Digite linha e coluna (ex: 1 5): $'
    msgAcerto DB 13,10,'Acertou uma embarcacao!$', 0Dh, 0Ah, '$'
    msgErro DB 13,10,'Agua! Tente novamente.$', 0Dh, 0Ah, '$'
    msgFinal DB 13,10,'Todas as embarcacoes afundadas! Jogo finalizado.$', 0Dh, 0Ah, '$'
    msgFim DB 13,10,'Deseja finalizar o jogo? (S/N): $'
    msgInvalida DB 13,10,'Entrada invalida. Tente novamente.$', 0Dh, 0Ah, '$'
    msgTiroRepetido DB 13,10,'Voce ja atirou nesta posicao!$', 0Dh, 0Ah, '$'

    barcos DB 1, 1, 1, 1, 1     ; Contador para embarcações (1 encouraçado, 1 fragata...)
    ; Definição de valores dos barcos
    encouracado DB 5            ; Encouraçado ocupa 5 espaços
    fragata DB 4                ; Fragata ocupa 4 espaços
    submarino DB 3              ; Submarino ocupa 3 espaços
    hidroaviao DB 2             ; Hidroavião ocupa 2 espaços

.CODE
MAIN PROC
    ; Inicializa segmento de dados
    MOV AX, @DATA
    MOV DS, AX
    
    ; Limpa a matriz
    CALL IniciaTabuleiro
    
    ; Posiciona as embarcações
    CALL PosicionarBarcos
    
    ; Exibe mensagem de boas-vindas
    MOV AH, 09h
    LEA DX, msgInicio
    INT 21h
    
game_loop:
    ; Solicitar tiro ao jogador
    CALL LerCoordenadas
    
    ; Verifica o resultado do tiro
    CALL VerificarTiro
    
    ; Verifica se o jogador quer finalizar
    CALL PerguntaFinalizacao
    
    ; Volta para o loop do jogo
    JMP game_loop

fim:
    MOV AH, 4Ch
    INT 21h

MAIN ENDP

;-----------------------------------------------------
; Função: IniciaTabuleiro
; Descrição: Inicializa a matriz 20x20 com zeros (água).
;-----------------------------------------------------
IniciaTabuleiro PROC
    MOV CX, 400
    XOR BX, BX
init_loop:
    MOV matriz[BX], 0
    INC BX
    LOOP init_loop
    RET
IniciaTabuleiro ENDP

;-----------------------------------------------------
; Função: PosicionarBarcos
; Descrição: Posiciona as embarcações na matriz de forma aleatória.
;-----------------------------------------------------
PosicionarBarcos PROC
    ; Aqui você pode criar uma lógica simples para posicionar
    ; as embarcações aleatoriamente, garantindo que não se toquem.
    ; Exemplo de colocar um encouraçado (5 espaços) na linha 2, colunas 5 a 9:
    
    MOV AL, 1  ; Coloca encouraçado (valor 1)
    MOV matriz[25], AL
    MOV matriz[26], AL
    MOV matriz[27], AL
    MOV matriz[28], AL
    MOV matriz[29], AL
    
    ; Aqui você seguiria a mesma lógica para as outras embarcações.
    
    RET
PosicionarBarcos ENDP

;-----------------------------------------------------
; Função: LerCoordenadas
; Descrição: Lê as coordenadas (linha e coluna) fornecidas pelo jogador.
;-----------------------------------------------------
LerCoordenadas PROC
    MOV AH, 09h
    LEA DX, msgTiro
    INT 21h
    
    ; Ler linha
    MOV AH, 01h
    INT 21h
    SUB AL, '0'   ; Converter de caractere para valor numérico
    MOV DH, AL    ; Armazenar linha em DH
    
    ; Ler coluna
    MOV AH, 01h
    INT 21h
    SUB AL, '0'
    MOV DL, AL    ; Armazenar coluna em DL
    
    ; Calcular o índice da matriz (posição)
    MOV AL, DH
    MOV BL, 20    ; Multiplicar por 20 para obter o índice da linha
    MUL BL
    ADD AL, DL    ; Adiciona a coluna
    MOV BX, AX    ; Salva o índice em BX para futuros acessos
    
    RET
LerCoordenadas ENDP

;-----------------------------------------------------
; Função: VerificarTiro
; Descrição: Verifica se o tiro acertou ou errou.
;-----------------------------------------------------
VerificarTiro PROC
    MOV AL, matriz[BX]  ; Pega o valor da posição da matriz
    CMP AL, 0
    JE agua             ; Se for 0, é água
    
    CMP AL, 1
    JE acerto           ; Se for 1, acertou uma embarcação
    
    JMP fim_verificacao ; Tiro já dado nesta posição

agua:
    ; Marca como tiro errado (água)
    MOV matriz[BX], 2
    MOV AH, 09h
    LEA DX, msgErro
    INT 21h
    JMP fim_verificacao

acerto:
    ; Marca como acerto
    MOV matriz[BX], 3
    MOV AH, 09h
    LEA DX, msgAcerto
    INT 21h
    ; Aqui você pode adicionar uma lógica para verificar se todas as partes
    ; do barco foram acertadas e, se sim, informar que o barco afundou.
    
fim_verificacao:
    RET
VerificarTiro ENDP

;-----------------------------------------------------
; Função: PerguntaFinalizacao
; Descrição: Pergunta se o jogador quer finalizar o jogo.
;-----------------------------------------------------
PerguntaFinalizacao PROC
    MOV AH, 09h
    LEA DX, msgFim
    INT 21h
    
    ; Ler resposta
    MOV AH, 01h
    INT 21h
    CMP AL, 'S'
    JE fim
    RET
PerguntaFinalizacao ENDP

END MAIN