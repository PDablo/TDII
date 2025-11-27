;************************************
; Técnicas Digitales II 
; Autor: GM
; Fecha: 16-09-2016
; version: 0.1
; for AVR: atmega328p (Arduino UNO)
; clock frequency: 16MHz 
;************************************

;===========================================
; Función del programa

;
;-------------------------------------------
.nolist
.list
.ifndef F_CPU
.set F_CPU = 16000000
.endif
;===========================================
; Declarations for register
.def temp = r16
.def overflows  = r17
.def aux1 = r18
.def aux2 = r19
;===========================================
; Data Segment
.dseg
VAR1:.byte 1
VAR2:.byte 2
prev: .byte 1
BaseTime7ms:		.byte	1
BaseTime1s:			.byte	1
Flags0:				.byte	1 

;===========================================
; EEPROM Segment
.eseg
VAR_EEPROM:.db$AA

;===========================================
; Code Segment
.cseg
.org RWW_START_ADDR      ; memory (PC) location of reset handler
rjmp Reset           ; jmp costs 2 cpu cycles and rjmp costs only 1
                         ; so unless you need to jump more than 8k bytes
                         ; you only need rjmp. Some microcontrollers therefore only 
                         ; have rjmp and not jmp

.org INT0addr; memory location of External Interrupt Request 0
rjmp isr_INT0_handler; go here if a External Interrupt 0 occurs 

.org INT1addr; memory location of External Interrupt Request 1
rjmp isr_INT1_handler; go here if a External Interrupt 1 occurs 

.org PCI0addr; memory location of Pin Change Interrupt Request 0
rjmp isr_PCI0_handler; go here if a Pin Change Interrupt 0 occurs 

.org PCI1addr; memory location of Pin Change Interrupt Request 1
rjmp isr_PCI1_handler; go here if a Pin Change Interrupt 1 occurs 

.org PCI2addr; memory location of Pin Change Interrupt Request 2
rjmp isr_PCI2_handler; go here if a Pin Change Interrupt 2 occurs 

.org WDTaddr; memory location of Watchdog Time-out Interrupt
rjmp isr_WDT_handler; go here if a Watchdog Time-out Interrupt occurs 

.org OC2Aaddr; memory location of Timer/Counter2 Compare Match A Interrupt
rjmp isr_OC2A_handler; go here if a Timer/Counter2 Compare Match A Interrupt occurs 

.org OC2Baddr; memory location of Timer/Counter2 Compare Match B Interrupt
rjmp isr_OC2B_handler; go here if a Timer/Counter2 Compare Match B Interrupt occurs 

.org OVF2addr; memory location of Timer/Counter2 Overflow Interrupt
rjmp isr_OVF2_handler; go here if a Timer/Counter2 Overflow Interrupt occurs 

.org ICP1addr; memory location of Timer/Counter1 Capture Event Interrupt
rjmp isr_ICP1_handler; go here if a Timer/Counter1 Capture Event Interrupt occurs 

.org OC1Aaddr; memory location of Timer/Counter1 Compare Match A Interrupt
rjmp isr_OC1A_handler; go here if a Timer/Counter1 Compare Match A Interrupt occurs 

.org OC1Baddr; memory location of Timer/Counter1 Compare Match B Interrupt
rjmp isr_OC1B_handler; go here if a Timer/Counter1 Compare Match B Interrupt occurs 

.org OVF1addr; memory location of Timer/Counter1 Overflow Interrupt
rjmp isr_OVF1_handler; go here if a Timer/Counter1 Overflow Interrupt occurs 

.org OC0Aaddr; memory location of Timer/Counter0 Compare Match A Interrupt
rjmp isr_OC0A_handler; go here if a Timer/Counter0 Compare Match A Interrupt occurs 

.org OC0Baddr; memory location of Timer/Counter0 Compare Match B Interrupt
rjmp isr_OC0B_handler; go here if a Timer/Counter0 Compare Match B Interrupt occurs 

.org OVF0addr              ; memory location of Timer0 overflow handler
rjmp isr_OVF0_handler; go here if a timer0 overflow interrupt occurs 

.org SPIaddr              ; memory location of SPI Serial Transfer Complete handler
rjmp isr_SPI_handler; go here if a SPI Serial Transfer Complete interrupt occurs 

.org URXCaddr              ; memory location of USART Rx Complete handler
rjmp isr_URXC_handler; go here if a USART Rx Complete interrupt occurs 

.org UDREaddr              ; memory location of USART, Data Register Empty handler
rjmp isr_UDRE_handler; go here if a USART, Data Register Empty interrupt occurs 

.org UTXCaddr              ; memory location of USART Tx Complete handler
rjmp isr_UTXC_handler; go here if a USART Tx Complete interrupt occurs 

.org ADCCaddr              ; memory location of ADC Conversion Complete handler
rjmp isr_ADCC_handler; go here if a ADC Conversion Complete interrupt occurs 

.org ERDYaddr              ; memory location of EEPROM Ready handler
rjmp isr_ERDY_handler; go here if a EEPROM Ready interrupt occurs 

.org ACIaddr              ; memory location of Analog Comparator handler
rjmp isr_ACI_handler; go here if a Analog Comparator interrupt occurs 

.org TWIaddr              ; memory location of Two-wire Serial Interface handler
rjmp isr_TWI_handler; go here if a Two-wire Serial Interface interrupt occurs 

.org SPMRaddr              ; memory location of Store Program Memory Read handler
rjmp isr_SPMR_handler; go here if a Store Program Memory Read interrupt occurs 

; ==========================

; interrupt service routines  

isr_INT0_handler:

reti; External Interrupt 0

isr_INT1_handler:

reti; External Interrupt 1 

isr_PCI0_handler:

reti; Pin Change Interrupt 0 

isr_PCI1_handler:

reti; Pin Change Interrupt 1 

isr_PCI2_handler:

reti; Pin Change Interrupt 2 

isr_WDT_handler:

reti; Watchdog Time-out Interrupt  

isr_OC2A_handler:

reti; Timer/Counter2 Compare Match A Interrupt  

isr_OC2B_handler:

reti; Timer/Counter2 Compare Match B Interrupt  

isr_OVF2_handler:

reti; Timer/Counter2 Overflow Interrupt  

isr_ICP1_handler:

reti; Timer/Counter1 Capture Event Interrupt  

isr_OC1A_handler:

reti; Timer/Counter1 Compare Match A Interrupt  

isr_OC1B_handler:

reti; Timer/Counter1 Compare Match B Interrupt  

isr_OVF1_handler:

reti; Timer/Counter1 Overflow Interrupt  

isr_OC0A_handler:

reti; Timer/Counter0 Compare Match A Interrupt  

isr_OC0B_handler:

reti; Timer/Counter0 Compare Match B Interrupt  

isr_OVF0_handler:
	push temp
	push r17
	ldi	temp,100			; Inicializamos en 100 para que el modulo del contador sea de 156
	out TCNT0,temp
	lds temp, BaseTime7ms
	inc temp
	cpi temp,100
	brne notime
	lds r17,BaseTime1s		; Incrementamos en uno cuando haya pasado 1 segundo
	inc r17
	sts BaseTime1s,r17
	ldi temp,0
notime:
	sts BaseTime7ms, temp
	pop r17
	pop temp
	reti; Timer0 overflow interrupt  

isr_SPI_handler:

reti; SPI Serial Transfer Complete interrupt  

isr_URXC_handler:

reti; USART Rx Complete interrupt  

isr_UDRE_handler:

reti; USART, Data Register Empty interrupt  

isr_UTXC_handler:

reti; USART Tx Complete interrupt  

isr_ADCC_handler:

reti; ADC Conversion Complete interrupt  

isr_ERDY_handler:

reti; EEPROM Ready interrupt  

isr_ACI_handler:

reti; Analog Comparator interrupt  

isr_TWI_handler:

reti; Two-wire Serial Interface interrupt  

isr_SPMR_handler:

reti; Store Program Memory Read interrupt  

WelcomeMsg:
.db "Sistema iniciado", 0x0D, 0x0A, 0x00

KeyMsg:
.db "Tecla: ", 0x00
;======================
; Main body of program:
Reset:

	ldi R16, LOW(RAMEND)    ; Lower address byte RAM byte lo.
		out SPL, R16         ; Stack pointer initialise lo.
	ldi R16, HIGH(RAMEND)   ; Higher address of the RAM byte hi.
		out SPH, R16 ; Stack pointer initialise hi. 
; write your code here
	sts BaseTime7ms, r0
	sts BaseTime1s, r0
	sts Flags0, r0

	call init_ports
	call Init_USART
	ldi ZH, HIGH(2*WelcomeMsg)
	ldi ZL, LOW(2*WelcomeMsg)
	call USART_Transmit_String

	clr r21

Loop:
	in temp, PINC			;PINC	| RESET | PINC6 | PINC5 | PINC4 | PINC3 | PINC2 | PINC1 | PINC0 |
	mov aux2, temp
	;se comprueba si la primera columna tiene algun boton presionado
							
	;nop
	CBI PORTD, 2			;pone el B2 en 0 del PORTD
	SBI PORTD, 3
	SBI PORTD, 4
	nop
	in aux2, PINC
	com aux2
	andi aux2, 0x07
	cpi aux2, 0x01			;0000 0001
	breq es_uno
	cpi aux2, 0x02			;0000 0010
	breq es_cuatro
	cpi aux2, 0x04			;0000 0100
	breq es_siete

	SBI PORTD, 2
	CBI	PORTD, 3
	SBI PORTD, 4
	nop
	in aux2, PINC
	com aux2
	andi aux2, 0x07
	cpi aux2, 0x01
	breq es_dos
	cpi aux2, 0x02
	breq es_cinco
	cpi aux2, 0x04
	breq es_ocho

	SBI PORTD, 2
	SBI PORTD, 3
	CBI PORTD, 4
	nop
	in aux2, PINC
	com aux2
	andi aux2, 0x07
	cpi aux2, 0x01
	breq es_tres
	cpi aux2, 0x02
	breq es_seis
	cpi aux2, 0x03
	brne Loop
	rjmp es_nueve
	call clear_display
	jmp Loop
					; loop back to the start
;leer_teclado:
	;		|	X	|	X	|	13	|	12	|	11	|	10	|	9	|	8	|
	;PORTB	|PORTB7	|PORTB6	|PORTB5	|PORTB4	|PORTB3	|PORTB2	|PORTB1	|PORTB0	|

es_uno:
	ldi temp, '1'
	call Enviar_Formato_TD
	call mostrar_1
	clr r21
	jmp Loop
es_cuatro:
	ldi temp, '4'
	call Enviar_Formato_TD
	call Wait_Release
	clr r21
	jmp Loop
es_siete:
	ldi temp, '7'
	call Enviar_Formato_TD
	call Wait_Release
	clr r21
	jmp Loop
es_dos:
	ldi temp, '2'
	call Enviar_Formato_TD
	call Wait_Release
	clr r21
	jmp Loop
es_cinco:
	ldi temp, '5'
	call Enviar_Formato_TD
	call Wait_Release
	clr r21
	jmp Loop
es_ocho:
	ldi temp, '8'
	call Enviar_Formato_TD
	call Wait_Release
	clr r21
	jmp Loop
es_tres:
	ldi temp, '3'
	call Enviar_Formato_TD
	call Wait_Release
	clr r21
	jmp Loop
es_seis:
	ldi temp, '6'
	call Enviar_Formato_TD
	call Wait_Release
	clr r21
	jmp Loop
es_nueve:
	ldi temp, '9'
	call Enviar_Formato_TD
	call Wait_Release
	clr r21
	jmp Loop
mostrar_1:
	call Wait_Release
	ldi r20, 0b11000110
	out PORTB, r20
	CBI PORTD, 7
	clr r20
	ret
mostrar_2:
	ldi r20, 0b11011011
	out PORTB, r20
	SBI PORTD, 7
	clr r20
	ret
mostrar_3:
	ldi r20, 0b11000110
	out PORTB, r20
	CBI PORTD, 7
	clr r20
	ret
mostrar_4:
	ldi r20, 0b11000110
	out PORTB, r20
	CBI PORTD, 7
	clr r20
	ret
mostrar_5:
	ldi r20, 0b11000110
	out PORTB, r20
	CBI PORTD, 7
	clr r20
	ret
mostrar_6:
	ldi r20, 0b11000110
	out PORTB, r20
	CBI PORTD, 7
	clr r20
	ret
mostrar_7:
	ldi r20, 0b11000110
	out PORTB, r20
	CBI PORTD, 7
	clr r20
	ret
mostrar_8:
	ldi r20, 0b11000110
	out PORTB, r20
	CBI PORTD, 7
	clr r20
	ret
mostrar_9:
	ldi r20, 0b11000110
	out PORTB, r20
	CBI PORTD, 7
	clr r20
	ret
clear_display:
	;call Delay3s
	out PORTB, r0
	CBI PORTD, 7
	ret
;========================
; Enviar_Formato_TD
; Envía el string "$TD<boton>" por USART
; Entrada: temp (r16) = carácter del botón ('1', '4', '7', etc)
Enviar_Formato_TD:
	push r16
	push r17
	
	mov r17, r16            ; Guardar botón
	
	; Enviar '$'
	ldi r16, '$'
	call USART_Transmit
	
	; Enviar 'T'
	ldi r16, 'T'
	call USART_Transmit
	
	; Enviar 'D'
	ldi r16, 'D'
	call USART_Transmit
	
	; Enviar el botón
	mov r16, r17
	call USART_Transmit
	
	; Enviar nueva línea
	ldi r16, 0x0D
	call USART_Transmit
	ldi r16, 0x0A
	call USART_Transmit
	
	pop r17
	pop r16
	ret

;========================
; Wait_Release
; Espera a que se suelte el botón
Wait_Release:
	push r16
	push r17
	
	; Delay anti-rebote
	ldi r17, 100
WR_Outer:
	ldi r16, 255
WR_Inner:
	dec r16
	brne WR_Inner
	dec r17
	brne WR_Outer
	
	; Verificar que no hay tecla
WR_Check:
	CBI PORTD, 2
	nop
	nop
	in r16, PINC
	com r16
	andi r16, 0x07
	cpi r16, 0x00
	brne WR_Check           ; Si hay tecla, seguir esperando
	
	pop r17
	pop r16
	ret
;========================
; Example of a subroutine

init_ports:
;PC0 PC1 PC2 PC3 PC4 PC5 PC6
; A0  A1  A2  A3  A4  A5 RESET
    ldi temp, 0x00			; PORTC: PC0-PC2 como entrada (filas)
    out DDRC, temp
	;			F3		F2			F1
    ldi temp, (1<<PC2) | (1<<PC1) | (1<<PC0)
    out PORTC, temp          ; Activar pull-ups en las filas


;PB0 PB1 PB2  PB3  PB4 PB5
	ldi temp, 0xFF
	out DDRB, temp
	ldi temp, 0x0
	out PORTB, temp
; D8 ~D9 ~D10 ~D11 D12 D13

;		 PD7 PD6 PD5 PD4 PD3 PD2 PD1 PD0
;DDRD	|D7 |D6 |D5 |D4 |D3 |D2 |D1 |D0 |
	ldi temp, (1<<PD4) | (1<<PD3) | (1<<PD2)
	out DDRD, temp			; Activar las salidas D4-D3-D2
	ldi temp, 0x00
	out PORTD, temp			; Todo el puerto en HIGH
;D0  D1  D2  ~D3 D4  ~D5 ~D6  D7
	ret

;========================
; Init_USART
; Configura USART para comunicación serial
; Baudrate: 9600 @ 16MHz
; Formato: 8N1 (8 bits, sin paridad, 1 bit de stop)
Init_USART:
    push r16
    push r17
    
    ; Configurar baudrate (9600 @ 16MHz)
    ; UBRR = (F_CPU / (16 * BAUD)) - 1
    ; UBRR = (16000000 / (16 * 9600)) - 1 = 103
    ldi r16, HIGH(103)      ; Parte alta
    sts UBRR0H, r16
    ldi r16, LOW(103)       ; Parte baja (0x67 = 103)
    sts UBRR0L, r16
    
    ; Habilitar transmisor (y receptor si lo necesitas)
    ldi r16, (1<<TXEN0)     ; Habilitar TX
    ; ldi r16, (1<<TXEN0)|(1<<RXEN0)  ; Para TX y RX
    sts UCSR0B, r16
    
    ; Formato: 8N1 (8 bits, sin paridad, 1 stop bit)
    ldi r16, (1<<UCSZ01)|(1<<UCSZ00)
    sts UCSR0C, r16
    
    pop r17
    pop r16
    ret
;========================
; USART_Transmit
; Transmite un byte por USART
; Entrada: r16 = byte a transmitir
; Modifica: ninguno (preserva r16)
USART_Transmit:
    push r17
    
USART_Wait:
    ; Esperar a que el buffer esté vacío (UDRE0 = 1)
    lds r17, UCSR0A
    sbrs r17, UDRE0         ; Saltar si UDRE0 está en 1
    rjmp USART_Wait
    
    ; Transmitir dato
    sts UDR0, r16
    
    pop r17
    ret

;========================
; USART_Transmit_Hex
; Transmite un byte en formato hexadecimal (2 dígitos ASCII)
; Entrada: r16 = valor a transmitir (0x00-0xFF)
; Ejemplo: 0xA5 se envía como "A5"
USART_Transmit_Hex:
    push r16
    push r17
    push r18
    
    mov r18, r16            ; Guardar valor original
    
    ; Transmitir nibble alto (4 bits superiores)
    swap r16                ; Intercambiar nibbles
    andi r16, 0x0F          ; Mantener solo nibble bajo
    call Nibble_To_ASCII
    call USART_Transmit
    
    ; Transmitir nibble bajo (4 bits inferiores)
    mov r16, r18            ; Recuperar valor original
    andi r16, 0x0F          ; Mantener solo nibble bajo
    call Nibble_To_ASCII
    call USART_Transmit
    
    pop r18
    pop r17
    pop r16
    ret

;========================
; Nibble_To_ASCII
; Convierte un nibble (0-F) a su carácter ASCII
; Entrada: r16 = nibble (0x00-0x0F)
; Salida: r16 = carácter ASCII ('0'-'9' o 'A'-'F')
Nibble_To_ASCII:
    cpi r16, 0x0A
    brlo IsDigit            ; Si < 10, es dígito
    
    ; Es letra (A-F)
    subi r16, -('A' - 10)   ; Convertir 10-15 a 'A'-'F'
    ret
    
IsDigit:
    subi r16, -'0'          ; Convertir 0-9 a '0'-'9'
    ret

;========================
; USART_Transmit_String
; Transmite una cadena terminada en NULL desde program memory
; Entrada: Z (r31:r30) = puntero a la cadena en FLASH
USART_Transmit_String:
    push r16
    push ZH
    push ZL
    
USART_String_Loop:
    lpm r16, Z+             ; Leer byte de FLASH y avanzar puntero
    cpi r16, 0x00           ; ¿Es NULL (fin de cadena)?
    breq USART_String_End
    call USART_Transmit
    rjmp USART_String_Loop
    
USART_String_End:
    pop ZL
    pop ZH
    pop r16
    ret

;========================
; USART_Transmit_Decimal
; Transmite un byte como número decimal (0-255)
; Entrada: r16 = valor a transmitir
; Ejemplo: 123 se envía como "123"
USART_Transmit_Decimal:
    push r16
    push r17
    push r18
    push r19
    
    mov r19, r16            ; Guardar valor original
    
    ; Calcular centenas
    ldi r17, 0              ; Contador de centenas
Div100:
    cpi r16, 100
    brlo Print_Hundreds
    subi r16, 100
    inc r17
    rjmp Div100
    
Print_Hundreds:
    cpi r17, 0              ; Si es 0, no imprimir (excepto si todo es 0)
    breq Skip_Hundreds
    mov r18, r16
    mov r16, r17
    subi r16, -'0'
    call USART_Transmit
    mov r16, r18
    rjmp Print_Tens_Always
    
Skip_Hundreds:
    cpi r19, 100            ; ¿El número original era >= 100?
    brsh Print_Tens_Always
    
    ; Calcular decenas
    ldi r17, 0              ; Contador de decenas
Div10:
    cpi r16, 10
    brlo Print_Units
    subi r16, 10
    inc r17
    rjmp Div10
    
Print_Tens:
    cpi r17, 0
    breq Print_Units        ; Si es 0 y no hay centenas, no imprimir
    
Print_Tens_Always:
    ldi r17, 0
Div10_2:
    cpi r16, 10
    brlo Print_Tens_Digit
    subi r16, 10
    inc r17
    rjmp Div10_2
    
Print_Tens_Digit:
    push r16
    mov r16, r17
    subi r16, -'0'
    call USART_Transmit
    pop r16
    
Print_Units:
    subi r16, -'0'
    call USART_Transmit
    
    pop r19
    pop r18
    pop r17
    pop r16
    ret

;========================
; USART_NewLine
; Envía salto de línea (CR+LF)
USART_NewLine:
    push r16
    ldi r16, 0x0D           ; Carriage Return
    call USART_Transmit
    ldi r16, 0x0A           ; Line Feed
    call USART_Transmit
    pop r16
    ret

;===========================================
; Init_Timer0
; Inicia el Timer 0 para desborde cada 1 mseg
; Tovf = 2^n * Prescaler / Fio
; Mod = Tovf * Fio / Prescaler
Init_Timer0:
	;Set the Timer Mode to Normal
	;TCCR0A
	; COM0A1 | COM0A0 | COM0B1 | COM0B0 | - | - | WGM01 | WGM00
	;	0		 0		  0		   0				0		0
	in	temp,TCCR0A
	cbr	temp,1<<COM0A1
	cbr	temp,1<<COM0A0
	cbr	temp,1<<COM0B1
	cbr	temp,1<<COM0B1
	cbr	temp,1<<WGM00
	cbr	temp,1<<WGM01
	out TCCR0A,temp
	
	;TCCR0B
	; FOC0A	| FOC0B | - | - | WGM02 | CS02 | CS01 | CS00
	;	0		0				0		1	   0	  1
	in	temp,TCCR0B
	cbr	temp,1<<FOC0A
	cbr	temp,1<<FOC0B
	cbr	temp,1<<WGM02
	out TCCR0B,temp
	
	;Activate interrupt for Overflow
	;TIMSK0
	; -	| - | - | - | - | OCIE0B | OCIE0A | TOIE0
	;						0		 0		  1
	lds	temp,TIMSK0
	cbr	temp,1<<OCIE0B
	cbr	temp,1<<OCIE0A
	sbr	temp,1 << TOIE0
	sts TIMSK0,temp
	
	;Set TCNT0
	ldi	temp,100
	out TCNT0,temp
	
	;Start the Timer (prescaler %1024)
	in	temp,TCCR0B
	sbr	temp,1<<CS00
	cbr	temp,1<<CS01
	sbr	temp,1<<CS02
	out TCCR0B,temp
	ret
;Delay3s:
;	lds r16, BaseTime1s		;leer el valor del contador
;WaitLoop:
;	lds r17, BaseTime1s
;	subi r17, r16
;	cpi r17, 3
;	brlo WaitLoop
;	ret