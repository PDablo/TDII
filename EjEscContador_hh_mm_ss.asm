;********************************************************************
;Técnicas Digitales II
;Ejercitación: 
;Implementar un contador BCD en la variable CTN.
;Ing. Maggiolo Gustavo
;********************************************************************

;******************************************************************************
;	Definición de Etiquetas
;******************************************************************************
.define
	BootAddr		0000h
	AddrIntRST1		0008h
	AddrIntRST2		0010h
	AddrIntRST3		0018h
	AddrIntRST4		0020h
	AddrIntTRAP		0024h
	AddrIntRST5		0028h
	AddrIntRST55	002Ch
	AddrIntRST6		0030h
	AddrIntRST65	0034h
	AddrIntRST7		0038h
	AddrIntRST75	003Ch

	STACK_ADDR		FFFFh

	IniDataROM		0540h
	IniDataRAM		2000h

	MaskSetEn		8
	M75			4
	M65			2
	M55			1


	Keyboard		03h
	KEYPRESS		01h

	AddrDISP15S		00h
	AddrDISP07S		10h

	sega			0200h
	segb			0400h
	segc			4000h
	segd			2000h
	sege			1000h
	segf			0100h
	segg			0800h
	segh			0002h
	segi			0004h
	segj			0010h
	segk			0080h
	segl			0040h
	segm			0020h
	segn			0008h
	sego			0001h
	ptop			8000h

	DIG0			0
	DIG1			2
	DIG2			4
	DIG3			6
	DIG4			8
	DIG5			10
	DIG6			12
	DIG7			14
	
;******************************************************************************
;	Definición de Datos en RAM (Variables)
;******************************************************************************
.data	IniDataRAM
CNT:			dB		0,0,0,0,0,0
		
Texto:		dB	'C','a','d','e','n','a',0

;******************************************************************************
;	Definición de Datos en ROM (Constantes)
;******************************************************************************
.data	IniDataROM	
CteWord:		dW	03E8h
CteByte:		dB	64h
		
;Digitos para los display

Dig8SegSPto:	DB 77h, 44h, 3Eh, 6Eh, 4Dh, 6Bh, 7Bh, 46h, 7Fh, 4Fh		;digitos sin punto
Dig8SegCPto:	DB F7h, C4h, BEh, EEh, CDh, EBh, FBh, C6h, FFh, CFh		;digitos con punto

Numero0:		dW sega|segb|segc|segd|sege|segf
Numero1:		dW segb|segc
Numero2:		dW sega|segb|segg|sege|segd
Numero3:		dW sega|segb|segc|segd|segg
Numero4:		dW segf|segg|segb|segc
Numero5:		dW sega|segf|segg|segc|segd
Numero6:		dW segf|sege|segd|segc|segg
Numero7:		dW sega|segb|segc
Numero8:		dW sega|segb|segc|segd|sege|segf|segg
Numero9:		dW sega|segb|segc|segg|segf

PtoDec:			dW ptop

Letra_A:		dW sege|segf|sega|segb|segc|segg
Letra_b:		dW segc|segd|sege|segf|segg
Letra_c:		dW segd|sege|segg
Letra_C:		dW segd|sege|segf|sega
Letra_d:		dW segb|segc|segd|sege|segg
Letra_e:		dW sega|segb|segd|sege|segf|segg
Letra_E:		dW sega|segd|sege|segf|segn
Letra_F:		dW sega|sege|segf|segn
Letra_G:		dW sega|segc|segd|segf|sege|segj
Letra_H:		dW segb|segc|sege|segf|segg
Letra_h:		dW segc|sege|segf|segg
Letra_I:		dW sega|segd|segh|segl
Letra_J:		dW segb|segc|segd|sege
Letra_K:		dW sege|segf|segi|segn|segk
Letra_L:		dW sege|segf|segd
Letra_M:		dW segb|segc|sege|segf|sego|segi
Letra_N:		dW segb|segc|sege|segf|sego|segk
Letra_o:		dW segc|segd|sege|segg
Letra_O:		dW sega|segb|segc|segd|sege|segf
Letra_Q:		dW sega|segb|segc|segd|sege|segf|segk
Letra_P:		dW sega|segb|sege|segf|segg
Letra_R:		dW sega|segb|sege|segf|segg|segk
Letra_r:		dW sege|segg
Letra_s:		dW sega|segf|segg|segd|segc
Letra_t:		dW sega|segh|segl
Letra_u:		dW segc|segd|sege
Letra_U:		dW segb|segc|segd|sege|segf
Letra_W:		dW segb|segc|segk|segm|sege|segf
Letra_X:		dW segi|segm|sego|segk
Letra_Y:		dW sego|segi|segl
Letra_Z:		dW sega|segd|segi|segm

Simbol_*:		dW sego|segh|segi|segk|segl|segm|segg
Simbol_/:		dW segm|segi
Simbol_\:		dW sego|segk
Simbol_(:		dW segi|segk
Simbol_):		dW sego|segm
Simbol_^:		dW segm|segk
Simbol_mas:		dW segh|segl|segn|segj
Simbol_men:		dW segg
Simbol_equ:		dW segg|segd
Simbol_may:		dW sege|segf|sego|segm
Simbol_min:		dW segb|segc|segk|segi
Simbol_spa:		dW 0
Simbol_13:		dW segd
Simbol_14:		dW segf|segb
Simbol_15:		dW segh
Simbol_16:		dW sego
Simbol_17:		dW ptop


;		a		a: 0200h	
;	-------------	b: 0400h
;	|\	|    /|	c: 4000h	 
;	| \	|h  /	|	d: 2000h
;    f|  \	|  /	|b	e: 1000h
;	|  o\	| /i	|	f: 0100h
;	| n  \|/  j	|	g: 0800h
;	------g------	h: 0002h
;	|    /|\    |	i: 0004h
;	|  m/	| \k 	|	j: 0010h
;    e|  /	|  \	|c	k: 0080h
;	| / 	|l  \	|	l: 0040h
;	|/    |    \| p	m: 0020h
;	------------- .	n: 0008h
;		d		o: 0001h	
;				p: 8000h

	


	

;********************************************************************
;	Sector de Arranque del 8085
;********************************************************************

	.org	BootAddr
		JMP	Boot

;********************************************************************
;	Sector del Vector de Interrupciones
;********************************************************************
	.org	AddrIntRST1
		JMP	IntRST1
	.org	AddrIntRST2
		JMP	IntRST2
	.org	AddrIntRST3
		JMP	IntRST3
	.org	AddrIntRST4
		JMP	IntRST4
	.org	AddrIntTRAP
		JMP	IntTRAP
	.org	AddrIntRST5
		JMP	IntRST5
	.org	AddrIntRST55
		JMP	IntRST55
	.org	AddrIntRST6
		JMP	IntRST6
	.org	AddrIntRST65
		JMP	IntRST65
	.org	AddrIntRST7
		JMP	IntRST7
	.org	AddrIntRST75
		JMP	IntRST75

;********************************************************************
;	Sector de las Interrupciones
;********************************************************************
IntRST1:
		;Acá va el código de la Interrupción RST1
		EI
		RET
IntRST2:
		;Acá va el código de la Interrupción RST2
		EI
		RET
IntRST3:
		;Acá va el código de la Interrupción RST3
		EI
		RET
IntRST4:
		;Acá va el código de la Interrupción RST4
		EI
		RET
IntTRAP:
		;Acá va el código de la Interrupción TRAP
		EI
		RET
IntRST5:
		;Acá va el código de la Interrupción RST5
		EI
		RET
IntRST55:
		;Acá va el código de la Interrupción RST5.5
		EI
		RET
IntRST6:
		;Acá va el código de la Interrupción RST6
		EI
		RET
IntRST65:
		;Acá va el código de la Interrupción RST6.5
		EI
		RET
IntRST7:
		;Acá va el código de la Interrupción RST7
		EI
		RET
IntRST75:
		;Acá va el código de la Interrupción RST7.5
		EI
		RET


;********************************************************************
;	Sector del Programa Principal
;********************************************************************
Boot:
		LXI	SP,STACK_ADDR	;Inicializo el Puntero de Pila		
Main:
			
		CALL IncCont
				
		JMP	Main
		
		HLT

;******************************************************************************
;	Función: IncCont
;	Función: Incrementa un contador de 8 digitos, con dirección base en CNT. 
;******************************************************************************
IncCont:
		PUSH PSW
		
		CALL IncCont0
		CC IncCont1
		CC IncCont2
		CC IncCont3
		CC IncCont4
		CC IncCont5
		
		POP PSW
		RET

IncCont0:
		LDA	CNT
		ADI	1
		DAA
		STA CNT
		RET
		
IncCont1:
		LDA	CNT+1
		ADI	1
		DAA
		STA CNT+1
		RET
		
IncCont2:
		LDA	CNT+2
		ADI	1
		DAA
		STA CNT+2
		RET
		
IncCont3:
		LDA	CNT+3
		ADI	1
		DAA
		STA CNT+3
		RET

IncCont4:
		LDA	CNT+4
		ADI	1
		DAA
		STA CNT+4
		RET

IncCont5:
		LDA	CNT+5
		ADI	1
		DAA
		STA CNT+5
		RET
