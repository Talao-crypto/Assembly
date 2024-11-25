title ex1
.model small 
.stack 100h

.DATA
msg1 db 13,10, "Digite um caracter em binario: $"

.CODE

main proc

mov ax,@DATA
mov ds,ax

mov ah,9
lea dx,msg1
int 21h

xor bx,bx

mov ah,1

ler_caracter:

int 21h

cmp al,13 ;compara o al com a tecla enter
je fim 

shl bx,1 ;desloca BX para a esquerda
sub al,'0'
add bl, al 
jmp ler_caracter



fim:
add bl,'0'
mov dl,bl 
mov ah,2
int 21h
mov ah,4Ch
int 21H

main ENDP
end main