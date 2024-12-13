.model small
.stack 100h

.data
nome db 10 dup (0) 
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

    L1:
        mov ah,1
        int 21h
        mov nome[si],al
        inc si
    loop L1
ret
leitura endp

contagem proc
xor si,si
xor bl,bl
mov cx,10
    L2: 
        mov al,nome[si]
        cmp  nome[si],'a'
        je contar
        cmp nome[si],'e'
        je contar
        cmp nome[si],'i'
        je contar
        cmp nome[si],'o'
        je contar
        cmp nome[si],'u'
        je contar
        jmp next

        contar:
        inc bl
        next:
        inc si
         loop L2
   
ret
contagem endp

imprimir proc

add bl,'0'
mov dl,bl
mov ah,2
int 21h

imprimir endp
end main
