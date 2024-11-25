title ex3
.model small 
.DATA
.code 
main proc 
mov ax,@data 
mov ds,ax 

mov ah,1
int 21h

cmp al,'9'
jle numero 

sub al,"A" ; Converte 'A'-'F' para 10-15
add al, 10 
jmp converte

numero: 
sub al,'0'

converte:

mov bl,al 
mov dl, bl 

add dl, '0'
mov ah,2 
int 21h

mov ah,4ch 
int 21h


main endp 
end main  