; embeding a char inside 3 pixels.adjusting only the first bit of every color
INCLUDE Irvine32.inc
.data
colors byte  100, 1, 2, 3, 4, 5, 6, 7
andConst EQU 11111110b
orConst EQU 00000001b
.code
;=========================Encode Character Procedure =========================
;
;
;
;
;
Encode_Char PROC USES ECX ESI EBX EAX 
	MOV ECX, 8 ;Number of bits
	MOV ESI, OFFSET colors

@ENCODE_CHARLOOP:

	SHL BYTE PTR EBX, 1; transfer MSB in carry once
	JC @encORING
	; clearnig
	AND BYTE PTR[ESI], andConst
	JMP @ecFinal

@encORING:
	OR BYTE PTR[ESI], orConst

@ecFinal:
	MOV EAX , 0
	MOV EAX, [ESI]
	INC ESI

	LOOP @ENCODE_CHARLOOP

RET
Encode_Char ENDP

main PROC

MOV EBX, 'A'

CALL Encode_Char

mov ecx, 8
mov ESI, offset colors
l2:
mov eax, 0
MOV al, [ESI]
call WriteDec

mov al, ' '
call WriteChar
INC ESI
loop l2

call WaitMsg
exit
main ENDP
END main