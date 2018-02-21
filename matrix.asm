.model tiny


.data
column 	db 80 DUP(0)
tmp 	dw ?
seed 	dw ?

.code
org 	0100h

main:
; clear screen
mov 	ah, 00h
mov 	al, 03h
int 	10h


mainLoop:

; one times in main loop
; program generate a new column >> column[bx] != 0
; after generate program print all rain drop 1 line
; then delay and (press any key)? exit program : go mainloop;  

call 	startcolumn
mov 	bx, 0
call	printRain
call	delay

mov     ah, 0Bh         ;Press any key to exit
int     21h
cmp     al, 00h
jz      mainLoop
jmp		exit

;-------------------------------------- FUNCTION -------------------------------------
incBX:
	inc 	bx
printRain:
	cmp 	bx, 80			; cmp, is this the end column
	je 		endprintRain	; yes, end print rain
	cmp 	column[bx], 0	; column[bx] > 0 is rain matrix
	je 		incBX			; inc bx if that column doesn't rain matrix
	mov 	tmp, bx			; collect bx(column) to tmp. tmp will set column in setPos
	call 	print			; print 1 rain matrix
	jmp 	incBX			; go back until the end of column

endprintRain:
ret

startcolumn:
	call	newcolumn		; random find new column
	cmp		column[bx], 0	; if that column doesn't have rain that the new rain column
	jne		startcolumn
	inc		column[bx]		; this tell new rain has generate :: rain matrix --> column[bx] > 0
ret

newcolumn:
	mul 	seed
	mov 	dx, 0
	mov 	cx, 80
	div 	cx
	mov 	tmp, dx		; tmp store only value 0 - 79
	mov 	bx, tmp		; bx is new random column from random
ret

rand:
	mov		ax, seed
	mov		dx, 0
	mov		cx, 94
	div		cx			;div ax, cx -- dx contain remainder
	add		dl, 33		;dl store number 33 to 126
	mov		al, dl
	mov		seed, ax  	;manage seed to next random -- ax is result [div ax, cx]
ret	

setpos:
	mov 	bx, tmp
	mov 	dx, tmp
	mov		ah, 02h
	mov		bh, 0
	mov		dh, column[bx]
	int		10h
	dec		column[bx]
ret

printc:
	; al store ascii from random function {rand}
	; bl set color. set color in print function below
	mov	ah, 09h
	mov	cx, 1
	mov	bh, 0 
	int 	10h
ret

delay:
	mov	al, 0
	mov 	ah, 86h
	mov 	cx, 2
	mov 	dx, 0
	int 	15h
ret

print:
; rain length is 8

	CALL 	setpos
	CALL 	RAND
	MOV     bl, 0fh  	; Set color : White
	CALL 	printc
	CALL 	setpos
	CALL 	RAND
	MOV     bl, 0fh 
	CALL 	printc
	
	CALL 	setpos
	CALL 	RAND
	MOV     bl, 0ah  	; Set color : Bright Green
	CALL 	printc
	CALL 	setpos 
	CALL 	RAND
	MOV     bl, 0ah 
	CALL 	printc
	CALL 	setpos 
	CALL 	RAND
	MOV     bl, 0ah 
	CALL 	printc
	CALL 	setpos 
	CALL 	RAND
	MOV     bl, 0ah
	CALL	printc
	
	CALL 	setpos 
	CALL 	RAND
	MOV     bl, 02h  	; Set color : Dark Green
	CALL 	printc
	CALL 	setpos 
	CALL	RAND
	MOV     bl, 02h 
	CALL 	printc

	mov		al, ' '		; delete last character
	call 	printc

	mov		bx, tmp 
	add 	column[bx], 9 		; 9 is len(rain) + 1
	cmp		column[bx], 33		; -----------------------------------
	JNE		b					; reposition if last rain is on below
	mov		column[bx], 0		; -----------------------------------
b:	  
ret

exit:

ret
end main