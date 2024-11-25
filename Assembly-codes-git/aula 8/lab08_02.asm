title ex1
.model small
.DATA
.CODE
main proc
mov ax,@DATA
mov ds,ax 

mov ah,1
int 21h
sub al,'0'
mov bl,al

mov ah,2 ;para aparecer na tela

mov cx,16 ;limita para 16 o loop
converte:

shl bx,1 ;anda por bx

jc num_um ;se tiver um numero pula

mov dl,'0'
int 21h

jmp fim 


num_um:
mov dl,'1' ;e imprime um
int 21h

fim:
loop converte


main endp
end main 