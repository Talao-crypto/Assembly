.model small
.stack 100h
.data

vetor db 20 dup(0)
armazenar db 0

.code
main proc
mov ax,@data
mov ds,ax

call ler
call contar
call imprimir


mov ah,4ch
int 21h
main endp

ler proc
xor si,si

mov cx,20

leitura:
mov ah,1
int 21h
mov vetor[si],al
inc si
loop leitura
ret
ler endp

contar proc
xor si,si
xor bl,bl

mov cx,20
contagem:
cmp  vetor[si],'A'
jne skip 
inc bl
skip:
inc si
loop contagem



ret
contar endp

imprimir proc
add bl,'0'
mov dl,bl
mov ah,2
int 21h

ret
imprimir endp



end main