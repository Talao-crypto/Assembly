.model small 
.stack 100h

soma MACRO
    mov al,matriz[si]
    add bl,al
ENDM

vetor  MACRO linha,coluna
    mov al,matriz[linha+coluna]
ENDM


.data
msg1 db 13,10, 'Soma:  $'
matriz db 16 dup (0)
somatoria db 2 dup (0)
.code

main proc
mov ax,@data
mov ds,ax

call ler
call somar
call imprimir

mov ah,4ch 
int 21h
main endp

ler proc 
xor si,si
mov cx,16 ;sao 4 linhas

    loop1:
    mov ah,1
    int 21h
    and al,0fh
    mov matriz[si], al
    inc si
    loop loop1

ret
ler endp

somar proc 
xor bx,bx
xor si,si

mov cx,16
    loop2:
    soma ;macro
    inc si
    loop loop2

    mov ah,9
    lea dx,msg1
    int 21h

    mov ax,bx
    xor cx,cx
    mov dx,0

    convertendo:
    xor dx,dx
    mov bx,10
    div bx
    push dx
    inc cx
    test ax,ax
    jnz convertendo

    mov di,0
    loop3:
    pop dx
    add  dl,30h

    add somatoria[di],dl
    inc di
    loop loop3

    mov somatoria[di],'$'
    mov ah,9
    lea dx,somatoria
    int 21h

ret
somar endp

imprimir proc
xor si,si
xor bx,bx
    mov dl,10
    mov ah,2
    int 21h
    mov cx,16
    aaaaa:

    vetor si,bx
    mov dl,al
    add dl,30h
    mov ah,2
    int 21h

    inc si
    cmp si,4

    jne volta

    add bx,4
    xor si,si
    mov ah,2
    mov dl,10
    int 21h
    
    volta:
    loop aaaaa

ret
imprimir endp

end main