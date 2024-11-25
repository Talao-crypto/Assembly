TITLE PROGRAMA EXEMPLO PARA MANIPULAÇÃO DE VETORES USANDO BX
.MODEL SMALL

.DATA
VETOR DB 1, 1, 1, 2, 2, 2 ;declarar vetor
.CODE

MAIN PROC
MOV AX, @DATA
MOV DS,AX

XOR DL, DL ;zerar dl para receber os numeros do vetor
MOV CX,6 ;vai fazer um loop para ler os 6 caracteres do vetor

LEA BX, VETOR ;ler string
VOLTA:
MOV DL, [BX] ;recebe os numeros
INC BX ;passa para o proximo

ADD DL, 30H ;transformar em decimal 
MOV AH, 02
INT 21H
LOOP VOLTA

MOV AH,4CH
INT 21H ;saida para o DOS
MAIN ENDP
END MAIN
