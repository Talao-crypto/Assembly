.model small
.stack 100h 

.data
vetor db 7 dup (?)
msg1 db 13,10, 'invertido:  $'
.code

main proc
mov ax,@data
mov ds,ax

call leitura
call inverte
call imprimir

mov ah,4ch 
int 21h
main endp

leitura proc
xor si,si
mov cx,7
mov ah,1
lendo:
int 21h
mov vetor[si],al
inc si
loop lendo
ret
leitura endp

inverte proc
xor si,si
mov di,6
loop_invertendo:
cmp si,di
jge fim 

mov al,vetor[si]
mov bl,vetor[di]
mov vetor[si],bl
mov vetor[di],al

inc si
dec di

jmp loop_invertendo

fim:
ret
inverte endp

imprimir proc

mov ah,9
lea dx,msg1
int 21h

xor si,si
mov cx,7
imprimindo:

mov dl,vetor[si]

mov ah,2
int 21h
inc si
loop imprimindo
ret
imprimir endp
end main