.model small
.stack 100h
.data
vetor db 7 DUP (0)
msg1 db 13,10, 'Vetor: (até 7 caracteres):  $'
msg2 db 13,10, 'Invertido:  $'
.CODE

main proc
    mov ax, @data 
    mov ds, ax

    call leitura
    call invertido
    call imprimir

    mov ah, 4ch
    int 21h
main endp

leitura proc
    mov ah, 9
    lea dx, msg1
    int 21h

    xor si, si ; índice do vetor
    mov cx, 7

    mov ah, 1
lendo:
    int 21h
    sub al, '0' ; transformar em número
    mov vetor[si], al
    inc si
    loop lendo 
    ret
leitura endp

invertido proc
    mov di, 6 ; Inicializa di para o último índice do vetor (6)
    xor si, si ; Inicializa si para o primeiro índice

invertendo:
    cmp si, di 
    jge fim ; Salta se si >= di

    
    mov al, vetor[si] ; armazena o valor do início
    mov bl, vetor[di] ; armazena o valor do final
    mov vetor[si], bl ; coloca o valor do final no início
    mov vetor[di], al ; coloca o valor do início no final

    inc si
    dec di
    jmp invertendo

fim:
  ret
invertido endp

imprimir proc
    mov ah,9
    lea dx,msg1
    int 21h

    xor si,si
    mov cx,7

    printloop:
    mov dl, vetor[si]
    add dl, '0'
    mov ah, 2
    int 21h
    inc si
    loop printloop 
    ret
imprimir endp

end main