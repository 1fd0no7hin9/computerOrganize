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
		
		cmp direct, 1 ; check print [top to down][down to top]
		je odd
		jmp even
		
	odd:			 ; direction = 0
		add x, 1	 ; print top to down
		cmp x, 24
		jle inner
		jmp esc_inner

	even:			 ; direction = 1
		sub x, 1	 ; print down to top
		cmp x, 0
		jge inner
		jmp esc_inner
		
esc_inner:
	xor direct, 1		; direct = 1: print left to right
				; direct = 0: print right to left
	cmp hasChanged, 0	; to check form 0 or 1
	je notChange
	jmp changeForm
	
	notChange :
		inc y		; print left to right
		cmp y, 80	; check if in last column
		jl outter
		jmp change
	changeForm:
		dec y		; print right to left
		cmp y, 0	; check if in 1st column
		jl exit
		jmp outter
change:				
; 1st form print left to right
; 2nd form print right to left
	mov hasChanged, 1 	; form has Changed
	mov y, 79
	jmp begin

;--- exit program ----
exit:

; set cursor to end 79,24
mov 	ah,	02h
mov	dh, 24 	;row
mov 	dl, 79 	;column
int 	10h

; pause >> press any key to continue
	mov ah, 07h
	int 21h

ret

END mAin