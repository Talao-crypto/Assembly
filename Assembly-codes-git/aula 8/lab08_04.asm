title hexadecimal
.model small
.stack 100h
.data
    msg_input db 10,13, "digite um numero hexadecimal de 4 digitos : $"
    msg_output db 10,13, "o numero : $"

    tabela_conv db 30h, 31h, 32h, 33h, 34h, 35h, 36h, 37h, 38h, 39h       ; tabela de conversao numeros
                db 41h, 42h, 43h, 44h, 45h, 46h                           ; tabela de conversao letra maiuscula

.code
main proc
    mov ax, @data
    mov ds, ax

; ler um número
    mov ah, 9
    lea dx, msg_input
    int 21h

    xor bx, bx
    mov ah, 1
input_loop:
    int 21h                     ; recebe um caractere
    cmp al, 0dh                 ; compara input com cr
    jz saida_loop               ; se cr --> sair do loop
    shl bx, 4                   ; desloca para o próximo dígito hexadecimal
    cmp al, 39h                 ; compara input com '9'
    jg letra_verifica           ; se input for maior que '9', assume-se que é uma letra maiuscula
    and al, 0fh                 ; converte de caractere numerico para um numero
    jmp soma_valor
letra_verifica:
    sub al, 37h                 ; converte de letra maiuscula para seu valor em hexadecimal
soma_valor:
    or bl, al                   ; soma em bx o número recém convertido
    loop input_loop

; imprime o número digitado
saida_loop:
    mov ah, 9
    lea dx, msg_output
    int 21h

    mov cx, 4                   ; loop roda 4 vezes (4 digitos hexa em uma palavra de 16-bits)
    mov ah, 2

output_loop:
    mov dl, bh                  
    shr dl, 4                   ; desloca o dígito hexadecimal para a direita (resta apenas um dígito em dl) (dígito restante era o mais significativo em bx)

    push bx                     ; guarda valor de bx na pilha
    lea bx, tabela_conv          ; coloca offset do endereço em bx
    xchg al, dl                 ; troca conteúdo de al e dl (envia o caractere a ser convertido para al)
    xlat                        ; converte conteúdo de al para caractere
    xchg al, dl                 ; troca conteúdo de al e dl
    pop bx                      ; retorna valor de bx da pilha
imprime_caractere:
    shl bx, 4                   ; desloca bx 4 bits para a esquerda
    int 21h                     ; imprime caractere armazenado em dl
    loop output_loop

    mov ah, 4ch
    int 21h

main endp
end main

