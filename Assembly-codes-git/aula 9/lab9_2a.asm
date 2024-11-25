TITLE PROGRAMA EXEMPLO PARA MANIPULAÇÃO DE VETORES USANDO SI ou DI
.MODEL SMALL

.DATA
VETOR DB 1, 1, 1, 2, 2, 2
.CODE

MAIN PROC
MOV AX, @DATA
MOV DS,AX

XOR DL, DL
MOV CX,6

LEA SI, VETOR ;SI e DI são registradores utilizados para receber a localização exata dessa variável do vetor
VOLTA:

MOV DL, [SI] ;Acessa diretamente o endereço armazenado no registrador 

INC SI

ADD DL, 30H
MOV AH, 02
INT 21H
LOOP VOLTA

MOV AH,4CH
INT 21H ;saida para o DOS
MAIN ENDP
END MAIN
