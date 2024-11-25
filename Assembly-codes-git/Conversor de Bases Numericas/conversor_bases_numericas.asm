
.model small
.stack 100h
salto_linha macro
    ; salva os registradores ax e dx na pilha antes de modificar
    push ax
    push dx
    
    ; imprime uma nova linha (lf e cr)
    mov ah, 2
    mov dl, 10
    int 21h
    mov dl, 13
    int 21h

    ; restaura os valores originais de ax e dx
    pop dx
    pop ax
endm

mostrar_pedir macro    ; exibe uma mensagem e aguarda a entrada de um caractere
    mov ah, 9           ; exibe a mensagem cuja posição está em dx
    int 21h

    salto_linha         ; pula para a próxima linha

    mov ah, 1           ; lê um caractere digitado pelo usuário
    int 21h
endm

.data
    mens1 db "escolha a base de entrada do número:",10,"1. binário",10,"2. decimal",10,"3. hexadecimal$"
    mens2 db "selecione a base de saída desejada:",10,"1. binário",10,"2. decimal",10,"3. hexadecimal$"

    tabela_hex db 30h, 31h, 32h, 33h, 34h, 35h, 36h, 37h, 38h, 39h ; tabela para conversão dos números 0-9
               db 41h, 42h, 43h, 44h, 45h, 46h                      ; tabela para conversão das letras A-F
.code
inicio proc
    ; inicializa o segmento de dados
    mov ax, @data
    mov ds, ax
    
    ; carrega o endereço da mensagem de entrada
    lea dx, mens1
    ; carrega o endereço da mensagem de saída
    lea si, mens2
    ; chama o procedimento para escolher a base de entrada e saída
    call escolha_bases

    ; termina o programa de forma limpa
    mov ah, 4ch
    int 21h
inicio endp

; procedimento para imprimir mensagens de escolha e chamar as rotinas apropriadas
escolha_bases proc
    push ax
    push bx
    push dx
    
    mostrar_pedir   ; imprime a mensagem de entrada e recebe a escolha do usuário

    salto_linha     ; pula para a próxima linha

    ; verifica se a escolha é para entrada em binário
    cmp al, 31h
    jz entrada_bin
    ; verifica se a escolha é para entrada em decimal
    cmp al, 32h
    jz entrada_dec

    entrada_hex:
    call recebe_hex ; chama o procedimento para ler entrada em hexadecimal
    jmp processar_saida ; vai para a parte de processamento da saída
    
    entrada_dec:
    call recebe_dec ; chama o procedimento para ler entrada em decimal
    jmp processar_saida
    
    entrada_bin:
    call recebe_bin ; chama o procedimento para ler entrada em binário

    processar_saida:
    salto_linha     ; pula para a próxima linha
    mov dx, si      ; carrega o endereço da mensagem de saída
    mostrar_pedir   ; imprime a mensagem de escolha de saída

    salto_linha     ; pula para a próxima linha

    ; verifica se a escolha é para saída em binário
    cmp al, 31h
    jz exibir_bin
    ; verifica se a escolha é para saída em decimal
    cmp al, 32h
    jz exibir_dec

    exibir_hex:
    call mostrar_hex ; chama o procedimento para imprimir em hexadecimal
    jmp fim_processo ; pula para o fim do processo
    
    exibir_dec:
    call mostrar_dec ; chama o procedimento para imprimir em decimal
    jmp fim_processo
    
    exibir_bin:
    call mostrar_bin ; chama o procedimento para imprimir em binário

    fim_processo:
    ; restaura os valores dos registradores
    pop dx
    pop bx
    pop ax
    ret
escolha_bases endp

; procedimento para receber número binário e armazená-lo em bx
recebe_bin proc
    push ax
    push cx
    xor bx, bx      ; limpa bx
    mov ah, 1
    mov cx, 16      ; lê até 16 bits

    le_bin:
        int 21h     ; recebe um caractere do usuário
        cmp al, 0dh ; verifica se é enter
        jz saida_bin ; sai do loop se for enter
        and al, 0fh ; converte o caractere para valor numérico
        shl bx, 1   ; desloca bx 1 bit à esquerda
        or bl, al   ; adiciona o bit lido em bx
        loop le_bin ; repete até cx ser zero
    saida_bin:
    pop cx
    pop ax
    ret
recebe_bin endp

; procedimento para exibir o conteúdo de bx em formato binário
mostrar_bin proc
    push ax
    push bx
    push cx
    push dx

    mov cx, 16      ; número de bits a exibir
    mov ah, 2
    exib_bins:
        shl bx, 1   ; desloca bx à esquerda
        jc bit_um   ; se houver carry, imprime '1'
        mov dl, 30h ; caso contrário, imprime '0'
        jmp imprimir_bins
        bit_um:
            mov dl, 31h
        imprimir_bins:
            int 21h ; imprime o caractere
        loop exib_bins ; repete até cx ser zero
    pop dx
    pop cx
    pop bx
    pop ax
    ret
mostrar_bin endp

; procedimento para receber número decimal e armazená-lo em bx
recebe_dec proc
    push ax
    xor bx, bx      ; limpa bx
    mov ah, 1

    le_dec:
        int 21h     ; recebe um caractere do usuário
        cmp al, 13  ; verifica se é enter
        jz saida_dec ; sai do loop se for enter
        push ax     ; guarda ax na pilha
        mov ax, 10
        mul bx      ; multiplica bx por 10
        mov bx, ax  ; resultado volta para bx
        pop ax      ; recupera ax da pilha
        and al, 0fh ; converte o caractere para valor numérico
        add bl, al  ; soma ao valor de bx
    jmp le_dec
    saida_dec:
    pop ax
    ret
recebe_dec endp

; procedimento para exibir o conteúdo de bx em formato decimal
mostrar_dec proc
    push ax
    push bx
    push cx
    push dx

    mov di, 10     ; divisor para conversão
    xor cx, cx     ; limpa cx (contador de dígitos)
    mov ax, bx     ; copia bx para ax
    xor dx, dx     ; limpa dx para divisão
    prepara_dec:
        div di     ; divide ax por 10, quociente em ax, resto em dx
        push dx    ; guarda o resto na pilha
        xor dx, dx ; limpa dx
        inc cx     ; incrementa contador de dígitos
        or ax, ax  ; verifica se ax é zero
        jnz prepara_dec ; repete até ax ser zero
    
    mov ah, 2      ; função para imprimir caracteres
    imprime_dec:
        pop dx     ; recupera o dígito da pilha
        or dl, 30h ; converte o dígito para caractere ASCII
        int 21h    ; imprime o caractere
        loop imprime_dec ; repete até cx ser zero

    pop dx
    pop cx
    pop bx
    pop ax
    ret
mostrar_dec endp

; procedimento para receber número hexadecimal e armazená-lo em bx
recebe_hex proc
    push ax
    push cx
    push dx

    xor bx, bx      ; limpa bx
    mov ah, 1
    mov cx, 4       ; espera até 4 dígitos hexadecimais
    le_hex:
        int 21h     ; recebe um caractere do usuário
        cmp al, 0dh ; verifica se é enter
        jz saida_hex ; sai do loop se for enter
        shl bx, 4   ; desloca bx 4 bits à esquerda para o próximo dígito
        cmp al, 39h ; compara se é maior que '9'
        jg conv_letra_hex ; se for maior, converte a letra
        and al, 0fh ; converte o caractere numérico para valor numérico
        jmp soma_hex
        conv_letra_hex:
            sub al, 37h ; converte letras A-F para seus valores numéricos
        soma_hex:
            or bl, al   ; adiciona o valor convertido em bx
        loop le_hex
    saida_hex:
    pop dx
    pop cx
    pop ax
    ret
recebe_hex endp

; procedimento para exibir o conteúdo de bx em formato hexadecimal
mostrar_hex proc
    push ax
    push bx
    push cx
    push dx

    mov ah, 2       ; função de impressão de caractere
    mov cx, 4       ; número de dígitos a exibir
    exib_hex:
        mov dl, bh  ; move o byte mais significativo de bx para dl
        shr dl, 4   ; desloca dl 4 bits para a direita
        push bx     ; guarda bx na pilha
        lea bx, tabela_hex ; carrega a tabela de conversão
        xchg al, dl ; troca al com dl
        xlat        ; converte dl para o caractere ASCII correspondente
        xchg al, dl ; troca de volta
        pop bx      ; recupera bx
        shl bx, 4   ; desloca bx para a próxima metade
        int 21h     ; imprime o caractere
        loop exib_hex ; repete até cx ser zero
    pop dx
    pop cx
    pop bx
    pop ax
    ret
mostrar_hex endp

end inicio
