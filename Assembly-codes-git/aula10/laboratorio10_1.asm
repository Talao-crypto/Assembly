.model small
.stack 100h
.data

vetor MACRO linha,coluna

    mov al,MATRIZ4X4[linha+coluna] ;move al
ENDM

MATRIZ4X4  db 1,2,3,4
        db 4,3,2,1
        db 5,6,7,8
        db 8,7,6,5
    msg1 db 13,10, '$'
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

    mov cx,16 ;sao 4 linhas
    loop1:
    vetor bx,si
    mov dl,al
    add dl,30h
    mov ah,2
    int 21h

    inc si ;proximo numero
    cmp si,4 ;verifica se acabou os numeros

    jne volta

    add bx,4 ;proxima linha
    xor si,si
    mov ah,2
    mov dl,10
    int 21h

    volta:
    loop loop1
    
ret
imprimir endp

end main
