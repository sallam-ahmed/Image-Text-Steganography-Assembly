; embeding a char inside 3 pixels.adjusting only the first bit of every color
INCLUDE Irvine32.inc
INCLUDE Macros.inc
.data
colors byte  100, 1, 2, 3, 4, 5, 6, 7
andConst EQU 11111110b
orConst EQU 00000001b

;#region FileRead Data
	BUFFER_SIZE EQU 5000

	FilePath BYTE "E:\input.txt",0
	FileHandler HANDLE ?
	INPUT_BUFFER BYTE BUFFER_SIZE DUP(?)

	INVALIDE_HANDLER_MESSAGE BYTE "Invalid Handler for input file...",0
;#endregion



.code
;=========================Encode Character Procedure =========================
; EDX Contains offset of colors 8 count array
;
;
;
;
Encode_Char PROC USES ECX ESI EBX EAX EDX
	MOV ECX, 8 ;Number of bits
	MOV ESI, EDX

@ENCODE_CHARLOOP:

	SHL BL, 1; transfer MSB in carry once
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

;=========================Decode Character Procedure =========================
;
;
;EDX = OFFSET pixelsArray
;
;EAX = Decoded Character
Decode_Char PROC USES ECX ESI EAX EDX
	MOV ECX, 8
	MOV ESI,EDX
	MOV EAX,0
@decBegin:
	AND BYTE PTR [ESI], 00000001b
	ADD AL, BYTE PTR[ESI]
	CMP ECX,1
	JE @decIgnore
@decShift:
	SHL AL,1
	INC ESI
@decIgnore:
	LOOP @decBegin
	CALL WriteChar
RET
Decode_Char ENDP

OpenFileForReading PROC USES EDX ECX EAX
	
	MOV EDX,OFFSET FilePath
	MOV ECX, LENGTHOF FilePath
	
	CALL OpenInputFile

	MOV FileHandler, EAX
	CMP EAX, INVALID_HANDLE_VALUE
	JE @INVALID_FILE
	MOV EDX, OFFSET INPUT_BUFFER
	MOV ECX, BUFFER_SIZE
	CALL ReadFromFile
	JNC @CHECK_BUFFER_SIZE; error reading ?
	mWrite "Error reading file. "; yes: show error message
	CALL WriteWindowsMsg
	JMP @TERMINATE
@CHECK_BUFFER_SIZE:
	CMP EAX, BUFFER_SIZE; buffer large enough ?
	JB @OK_BUF_SIZE; yes
	mWrite <"Error: Buffer too small for the file", 0dh, 0ah>
	JMP @TERMINATE; and quit
@OK_BUF_SIZE:
	MOV INPUT_BUFFER[EAX], 0; insert null terminator
	mWrite "File size: "
	CALL WriteDec; display file size
	CALL Crlf
	JMP @READ_FINAL
@INVALID_FILE:
	MOV EDX, OFFSET INVALIDE_HANDLER_MESSAGE
	CALL WriteString
	CALL Crlf
	CALL WaitMsg
@READ_FINAL:
	MOV EDX,OFFSET INPUT_BUFFER
	CALL WriteString
@TERMINATE:
	RET
OpenFileForReading ENDP

main PROC

	;CALL OpenFileForReading

;#region Encode Testing
;COMMENT @
MOV BL, 'b'
MOV EDX, OFFSET colors
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
;@
;#endregion
call WaitMsg
CALL Crlf
CALL Decode_Char
CALL Crlf
CALL WaitMsg
exit
main ENDP
END main