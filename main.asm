.model small
.stack 100h
.data
a db ?
b db ?
c db ?
bpower db ?
a4c db ?
sqroot db ?
x2real db 0
x12a db ?
x22a db ?
x1 db ?
x2 db ?
.code

mov ax,@data
mov ds, ax

lea bx, a
in al,1
mov [bx],al

cmp al,0
jz failed

lea bx, b
in al,1
mov [bx],al

lea bx, c
in al,1
mov [bx],al

call power
call ac4

lea bx,bpower
mov ch,[bx]
lea bx,a4c 
sub ch,[bx]
js failed
call sqrt
call plusminus
call division

lea bx,x1
mov al,[bx]
out 2,al

lea bx,x2real
cmp [bx],0
je endprogram
lea bx,x2
mov al,[bx]
out 2,al

jmp endprogram


failed:
mov al, 'F'
mov ah, 14
int 10h
mov al, 'a'
mov ah, 14
int 10h
mov al, 'i'
mov ah, 14
int 10h
mov al, 'l'
mov ah, 14
int 10h
mov al, 'e'
mov ah, 14
int 10h
mov al, 'd'
mov ah, 14
int 10h
endprogram:


mov ah,4ch
mov al,0
int 21h

power:
lea bx,b
mov al,[bx]
mul al
lea bx,bpower
mov [bx],al
ret

ac4:
lea bx,a
mov al,[bx]
mov dl,4
mul dl
lea bx,c
mov dl,[bx]
mul dl
lea bx,a4c
mov [bx],al
ret

sqrt:
xor ah,ah
mov dl,ch
inc dl
mov dh,1
startofsqrtloop:
cmp dh,dl
jae sofff
sub ch,dh 
inc ah
cmp ch,0
js sofff
jz sofff
inc dh 
inc dh 
jmp startofsqrtloop
sofff: 
lea bx,sqroot
mov [bx],ah
ret

plusminus:
xor al,al
lea bx,b
sub al,[bx] 
lea bx,sqroot
add al,[bx]
lea bx,x12a
mov [bx],al
lea bx,sqroot
cmp [bx],0
jz onex
xor al,al
lea bx,b
sub al,[bx]
lea bx,sqroot
sub al,[bx]
lea bx,x22a
mov [bx],al
lea bx,x2real
mov [bx],1
onex:
ret

division:
lea bx,x12a
mov cl,[bx]


againforx2:

mov ax, 2
mul a
mov ch,al


xor dh,dh

cmp ch,0
jns a2pos
inc dh
not ch
inc ch


a2pos:
cmp cl,0
jns x1topos
inc dh
not cl
inc cl

x1topos:
xor ax,ax
mov al,cl
div ch

lea bx,x2real
cmp [bx],3
jne forx1
lea bx,x2
jmp forallx
forx1:
lea bx,x1
forallx:
cmp dh,1
je makenegx1
mov [bx],al
jmp donex1
makenegx1:
not al
inc al
mov [bx],al

donex1:
lea bx,x2real
cmp [bx],1
jne donex2
mov [bx],3
lea bx,x22a
mov cl,[bx]
jmp againforx2

donex2:
ret

end
