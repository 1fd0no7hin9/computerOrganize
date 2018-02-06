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
		cmp direct, 1 ; check print [left to right][right to left]
		je odd
		jmp even
		
	odd: 			; direction = 1
		add y, 1	; check print [left to right][right to left]
		cmp y, bndrgh
		jle inner
		mov y, bndrgh
		jmp esc_inner

	even: ; direction = 0
		sub y, 1	; print right to left in line
		cmp y, bndlft
		jge inner
		mov y, bndlft
		jmp esc_inner
		
esc_inner:
	xor direct, 1		; direct = 1: print left to right
				; direct = 0: print right to left
	cmp hasChanged, 0	; to check form 0 or 1
	je notChange
	jmp changedForm

	notChange:
		inc x		; print top to down
		cmp x, 25	; check if in last line
		je change
		jmp outter
	
	changedForm:
		dec x		; print down to top
		cmp x, 0	; check if in 1st line
		jl exit
		jmp outter
change:
; 1st form print top to down
; 2nd form print down to top
	mov x, 24
	mov hasChanged, 1	; form has Changed
	jmp begin

;--- exit program ----
exit:

; set cursor to end 79,24
mov 	ah,	02h
mov	dh, 24 	;row
mov 	dl, 79 	;column
int 	10h

;pause >> press any key to continue
mov ah, 07h
int 21h

ret

END MAIN