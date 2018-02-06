.MODEL tiny

.DATA
x db 0
y db 0
direct db 1
char equ 'O'
bndrgh equ 79 ; -- bound right
bndlft equ 0  ; -- bound left
hasChanged db 0

.CODE
org 0100h

MAIN:

begin:
;cls
mov     ah, 00h         
        mov     al, 03h
        int     10h 

outter:

	inner:

		;gotoxy
		mov 	ah,	02h
		mov	dh, x 	;row
		mov 	dl, y 	;column
		int 	10h
		
		;write char 'O' 
		mov ah,0Ah
		mov al,'O'
		mov cx, 1
		int 10h

; --------------------delay-------------------
	
		mov cx, 10000
	delay:
		nop
		loop delay
; --------------------------------------------
		cmp direct, 1
		je odd
		jmp even
		
	odd: ; direction = 1
		add y, 1
		cmp y, bndrgh
		jle inner
		mov y, bndrgh
		jmp esc_inner

	even: ; direction = 0
		sub y, 1
		cmp y, bndlft
		jge inner
		mov y, bndlft
		jmp esc_inner
		
esc_inner:
	cmp hasChanged, 0
	je notChange
	jmp changedForm

	notChange:
		xor direct, 1
		inc x
		cmp x, 25
		je change
		jmp outter
	
	changedForm:
		xor direct, 1
		dec x
		cmp x, 0
		jl exit
		jmp outter
change:
	mov x, 24
	mov hasChanged, 1
	jmp begin

;--- exit program ----
exit:

mov 	ah,	02h
mov	dh, 24 	;row
mov 	dl, 79 	;column
int 	10h

;pause
mov ah, 07h
int 21h

ret

END MAIN