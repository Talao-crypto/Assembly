.MODEL SMALL
.DATA
VETOR DB 1, 1, 1, 2, 2, 2
.CODE

MAIN PROC
MOV AX, @DATA
MOV DS,AX

XOR DL, DL
MOV CX,6
XOR BX, BX

VOLTA:
MOV DL, VETOR[BX] ;diferença!!! os códigos sao semelhantes, mas aqui voce mexe com o conteudo de memoria do vetor na determinada posição 
INC BX
ADD DL, 30H
MOV AH, 02
INT 21H
LOOP VOLTA

MOV AH,4CH
INT 21H ;saida para o DOS
MAIN ENDP
END MAIN
