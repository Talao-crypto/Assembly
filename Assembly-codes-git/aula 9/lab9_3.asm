.model small 

.data 
vetor db 7 DUP(0) 
msg1 db 'Digite 7 numeros (0-9): $'
msg2 db 13,10, 'Vetor invertido:  $'
.CODE

main proc  
mov ax,@DATA
mov ds,ax              

mov ah,9
lea dx,msg1
int 21H

xor SI,SI
mov cx,7

mov ah,1
leitura:
int 21H
sub al,'0'
mov vetor[SI], al
inc SI
loop leitura

xor SI,SI
mov DI, 6 

invertido:
cmp SI,DI
jge Fim

mov al,vetor[SI]
mov bl,vetor[DI]
mov vetor[SI],bl
mov vetor[DI],al

inc SI
dec DI
jmp invertido

Fim:
mov ah,9
lea dx,msg2
int 21H

xor SI,SI
mov cx,7  

;imprimir o vetor invertido
printloop:
mov dl,vetor[SI]
add dl,'0'
mov ah,2
int 21H
inc SI
loop printloop

mov ah,4ch 
int 21H



main endp 
end main 