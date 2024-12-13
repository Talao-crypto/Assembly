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

call imprimir

mov ah,4ch
int 21h
main endp

imprimir proc
xor si,si
xor bx,bx

mov al, matriz[si]
call print_numero

add si,4 ;vai andando pelos numeros
mov al,matriz[si]
call print_numero

add si,4 ;vai andando pelos numeros
mov al,matriz[si]
call print_numero

ret
imprimir endp

print_numero proc

add al,'0'
mov dl,al
mov ah,2
int 21h
ret

print_numero endp
end main

