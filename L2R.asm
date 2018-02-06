.MODEL tiny

.DATA
x db 24
y db 0
direct db 0 ; 0:down2top | 1:top2down
hasChanged db 0

.CODE
org 0100h

main:

begin :
;cls
mov     ah, 	00h         
        mov     al, 03h
        int     10h 

outter:
	inner:
; ------------------gotoxy ---------------------
		mov 	ah,	02h
		mov	dh, x 	;row
		mov 	dl, y 	;column
		int 	10h

; --------------write char 'O' ----------------- 
		mov ah,0Ah
		mov al,'O'
		mov cx, 1
		int 10h

; --------------------delay-------------------

		mov cx, 8000
	delay:
		loop delay
		
; -------------- algorithm --------------------		
		
		cmp direct, 1
		je odd
		jmp even
		
	odd:			 ; direction = 0
		add x, 1
		cmp x, 25
		jl inner
		mov x, 24
		jmp esc_inner

	even:			 ; direction = 1
		sub x, 1
		cmp x, -1
		jg inner
		mov x, 0
		jmp esc_inner
		
esc_inner:
	xor direct, 1
	cmp hasChanged, 0
	je notChange
	jmp changeForm
	
	notChange :
		inc y
		cmp y, 80
		jl outter
		jmp change
	changeForm:
		dec y
		cmp y, 0
		jl exit
		jmp outter
change:
	mov hasChanged, 1 ; -- form has Changed
	mov y, 79
	jmp begin

;--- exit program ----
exit:

mov 	ah,	02h
mov	dh, 24 	;row
mov 	dl, 79 	;column
int 	10h

; pause
	mov ah, 07h
	int 21h

ret

END mAin