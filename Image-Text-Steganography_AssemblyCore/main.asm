; embeding a char inside 3 pils.adjusting only the first bit of every color
INCLUDE Irvine32.inc
INCLUDE Macros.inc
.data
andConst EQU 11111110B
orConst EQU 00000001B
Massage BYTE 1000 DUP(?)
Massage_length DWORD ?
SNUM BYTE 3 DUP(?)

;#region FileRead Data
	BUFFER_SIZE EQU 500000
	BUFFER_LENGTH DWORD ?
	FilePath BYTE "C:\Users\Abdelrhman_Hassan\Desktop\New Text Document.txt",0
	FileHandler HANDLE ?
	INPUT_BUFFER BYTE BUFFER_SIZE DUP(?)
	INVALIDE_HANDLER_MESSAGE BYTE "Invalid Handler for input file...",0
;#endregion



.code
;=========================Encode Character Procedure ========================
;INTTOSTRING PROC USES EAX ECX EBX EDX
    ;MOV ESI, SNUM
	;
;
	;RET
;INTTOSTRING ENDP
;
;=========================Encode Character Procedure =========================
; EDX Contains offset of colors 8 count array
;
;
;
;
Encode_Char PROC USES ECX ESI EBX EAX EDX
	
	MOV EDI , OFFSET Massage 
	MOV ECX , Massage_length;Number of bits
	MOV EDX , OFFSET INPUT_BUFFER
	MOV ESI, OFFSET INPUT_BUFFER

@ENCODE_MASSLOOP:
     PUSH ECX
	 MOV EAX , 0
	  
	 MOV BL ,[EDI]
	 MOV ECX , 8
@ENCODE_CHARLOOP:
     PUSH ECX 
	 MOV ECX ,3
	 CALL ParseDecimal32
	SHL BL, 1         ; transfer MSB in carry once
	JC @encORING
	; clearnig
	AND AL , andConst
	JMP @ecFinal

@encORING:
	OR AL , orConst
@ecFinal:
    CALL WRITEDEC 
	CALL CRLF
;=================================
	PUSH EDX
	PUSH EBX
	;PUSH ECX 
	;PUSH EAX
	MOV ECX , 3
	MOV EBX , 10
	TOSTRING:
	    MOV EDX , 0
		DIV EBX 
		ADD EDX , 48
		PUSH EDX
	LOOP TOSTRING
	MOV ECX , 3
	TOSTRING1:
		POP EDX
		MOV [ESI] ,EDX 
		INC ESI
	LOOP TOSTRING1
;
	;POP EAX
	;POP ECX
	POP EBX 
	POP EDX
;================================
	ADD EDX , 4
	POP ECX 
LOOP @ENCODE_CHARLOOP
	INC EDI
    CALL CRLF 
	POP ECX 
LOOP @ENCODE_MASSLOOP
RET
Encode_Char ENDP

;=========================Decode Character Procedure =========================
;
;
;EDX = OFFSET pixelsArray
;
;EAX = Decoded Character
Decode_Char PROC USES ECX ESI EAX EDX
	
	MOV ECX , BUFFER_LENGTH
	SHR ECX ,5
	MOV EDX ,OFFSET INPUT_BUFFER
	MOV EAX ,0
	MOV EBX ,0
@decCode_LOOP:
	 PUSH ECX 
	 MOV EBX , 0
	 MOV ECX , 8  
@decBegin:
    PUSH ECX 
	MOV ECX , 3
    CALL ParseDecimal32
	AND AL, orConst
	ADD BL, AL
	POP ECX 
	CMP ECX,1
	JE @decIgnore
@decShift:
	SHL BL,1
@decIgnore: 
	ADD EDX,4
	LOOP @decBegin
	MOV AL ,BL
	CALL WriteChar
	POP ECX 
	LOOP @decCode_LOOP
	
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
	MOV BUFFER_LENGTH, EAX 
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
	;MOV EDX,OFFSET INPUT_BUFFER
	;CALL WriteString
@TERMINATE:
	RET
OpenFileForReading ENDP

main PROC

	CALL OpenFileForReading

;#region Encode Testing
;COMMENT @
MOV EDX , OFFSET Massage 
MOV ECX , LENGTHOF Massage 
call READString
MOV Massage_length , EAX
CALL Encode_Char
MOV EDX , OFFSET INPUT_BUFFER
CALL WRITESTRING 
;CALL Decode_Char
call WaitMsg
CALL Crlf
exit
main ENDP
END main