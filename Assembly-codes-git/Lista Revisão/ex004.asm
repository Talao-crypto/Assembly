.model small
.stack 100h

.data

matriz  db 1,2,3
        db 1,2,3
        db 1,2,3
        

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

mov al,matriz[si]
call somando

add si,4
mov al,matriz[si]
call somando

add si,4
mov al,matriz[si]
call somando

ret
contagem endp

somando proc

add bl,al

ret
somando endp

imprimir proc

add bl,'0'
mov dl,bl
mov ah,2
int 21h
ret
imprimir endp
end main
