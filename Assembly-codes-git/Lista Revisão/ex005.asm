.model small
.stack 100h

.data
vetor db 0,1,2,1,1,1,0,0
.code

main proc
mov ax,@data
mov ds,ax

    call contagem
    call imprimir

mov ah,4ch 
int 21h
main endp

contagem proc

xor si,si
xor bx,bx
mov cx,8
contando:
mov al,vetor[si]
add bl,al 
inc  si
loop contando
ret
contagem endp

imprimir proc

add bl,'0'
mov dl,bl
mov ah,2
int 21h

ret
imprimir endp
end main
