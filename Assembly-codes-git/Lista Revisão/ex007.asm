.model small
.stack 100h

.data
vetor db 10 dup (0)
par db 0
impar db 0
.code

main proc
mov ax,@data
mov ds,ax

call leitura
call contagem
call imprimir

mov ah,4ch
int 21h
main endp

leitura proc
xor si,si
mov cx,10
mov ah,1
lendo:
int 21h
mov vetor[si],al
inc si
loop lendo
ret
leitura endp

contagem proc
xor si,si
xor bl,bl
xor dl,dl
mov cx,10
contando:
mov al,vetor[si]
test al,1
jz paridade
inc bl 

jmp continua
paridade:
inc dl

continua:
inc si
loop  contando
mov par,dl
mov impar,bl

ret
contagem endp

imprimir proc

mov dl,par
add dl,'0'
mov ah,2
int 21h

mov dl,impar
add dl,'0'
mov ah,2
int 21h
ret
imprimir endp

end main