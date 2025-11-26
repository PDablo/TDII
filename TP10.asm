;TP10 DANGELO-SILVESTRE

;===========================================
; Función del programa:
;	Control de intensidad de LED con PWM
;	El circuito consta de un display de 7 segmentos, 4 pulsadores y un LED de alto brillo
;	Los 4 pulsadores (D2-D4; A0) configuran el valor de intensidad (0-F)
;	Display muestra el valor actual en hexadecimal
;	LED varía su intensidad mediante PWM según el valor
;
;	CONEXIONES:
;	- Display 7 seg: PB0-PB5 (a-f), PD7 (g)
;	- Pulsadores: PD2 (BIT0), PD3 (BIT1), PD4 (BIT2), A0 (BIT3)
;	- LED PWM: PD6 (OC0A)
;-------------------------------------------
.ifndef F_CPU
.set F_CPU = 16000000
.endif

;===========================================
.dseg
dato: .byte 1
datoAnt: .byte 1
;===========================================
; Code Segment
.cseg
.org RWW_START_ADDR
	rjmp Reset

.org INT0addr				; memory location of External Interrupt Request 0
	rjmp isr_INT0_handler	; go here if a External Interrupt 0 occurs 

.org INT1addr				; memory location of External Interrupt Request 1
	rjmp isr_INT1_handler	; go here if a External Interrupt 1 occurs 

.org PCI0addr				; memory location of Pin Change Interrupt Request 0
	rjmp isr_PCI0_handler	; go here if a Pin Change Interrupt 0 occurs 

.org PCI1addr				; memory location of Pin Change Interrupt Request 1
	rjmp isr_PCI1_handler	; go here if a Pin Change Interrupt 1 occurs 

.org PCI2addr				; memory location of Pin Change Interrupt Request 2
	rjmp isr_PCI2_handler	; go here if a Pin Change Interrupt 2 occurs 

;===========================================

; interrupt service routines  

;2
isr_INT0_handler:			
	lds r18,dato
	ldi r20,0b00000001
	eor r18,r20
	sts dato, r18
	reti

;3
isr_INT1_handler:			
	lds r18,dato
	ldi r20,0b00000010
	eor r18, r20
	sts dato, r18
	reti

isr_PCI0_handler:
	reti					; Pin Change Interrupt 0 

;A0
isr_PCI1_handler:			; Cambia 
	inc r19					;Utilizamos r19 como antirrebote para evitar que
	cpi r19,0x02			;entre dos veces a la rutina de interrupción
	breq CambiaB4
	lds r18,dato
	ldi r20,0b00000100
	eor r18,r20
	sts dato,r18
	reti
CambiaB4:
	clr r19
	reti

;D4
isr_PCI2_handler:			
	inc r19	
	cpi r19,0x02			
	breq CambiaB3
	lds r18,dato
	ldi r20,0b00001000
	eor r18,r20
	sts dato,r18
	reti
CambiaB3:
	clr r19
	reti

;===========================================
; Tabla de conversión Hexadecimal a 7 segmentos
HexTo7Seg:	
.db 0xC0,0xF9,0xA4,0xB0,0x99,0x92,0x82,0xF8
.db 0x80,0x90,0x88,0x83,0xC6,0xA1,0x86,0x8E

;===========================================
; Main body of program:
Reset:
	; Inicializar Stack Pointer
	ldi r16, LOW(RAMEND)
	out SPL, r16
	ldi r16, HIGH(RAMEND)
	out SPH, r16

	ldi r16,0x06
	sts PCICR, r16

	ldi r16, 0x10
	sts PCMSK2, r16		;habilitamos PCINT20 (pin4 -D4)
	
	ldi r16, 0x01
	sts PCMSK1, r16		;habilitamos PCINT8 (A0)

	eor r16, r16
	ldi r17, 0x0A
	sts EICRA, r17		;habilitamos las interrupciones INT0 e INT1 que se generen
						;con un flanco descendente
	sei					;habilitamos las interrupciones globales
	sbi EIMSK, INT0
	sbi EIMSK, INT1
	
	; Configurar puertos
	call Init_Port
	
	; Configurar PWM
	call Init_PWM

	; Inicializar variables
	clr r16
	clr r17
	clr r18
	
	ldi r16,0x0
	sts dato, r16
	ldi r16, 0x0
	sts datoAnt, r16
;===========================================
; Loop principal
;PIN:	D7 D8 D9 D10 D11 D12 D13
;7SEG:	G  A  B   C   D   E   F
Main:
	; Actualizar PWM según el valor leído
	call UpdatePWM

	; Mostrar en display según el valor leído
	call HexTo7Segment

	rjmp Main

;===========================================
; Init_Port
; Configura los puertos de entrada y salida
Init_Port:
	; PORTB (PB0-PB5): segmentos a-f del display - SALIDA
	ldi r16, 0x3F			; Bits 0-5 como salida
	out DDRB, r16
	ldi r16, 0xFF
	out PORTB, r16			; Apagar segmentos (ánodo común)

	; PORTD: 
	; PD7 = segmento g (salida)
	; PD6 = PWM (salida)
	; PD4-PD2 = pulsadores (entrada con pull-up)
	; PD1-PD0 = no usados
	ldi r16, 0xC0			; Bits 6 y 7 como salida
	out DDRD, r16
	ldi r16, 0x3C			; Habilitar pull-up en PD2-PD5
	out PORTD, r16

	ret

;===========================================
; Init_PWM
; Configura Timer0 para generar PWM en OC0A (Pin 6/PD6)
Init_PWM:
    ; Modo invertido: COM0A1:0 = 11
    ldi r16, (1<<COM0A1)|(1<<COM0A0)|(1<<WGM01)|(1<<WGM00)
    out TCCR0A, r16
    
    ldi r16, (1<<CS01)|(1<<CS00)
    out TCCR0B, r16
    
    ldi r16, 255        ; Iniciar apagado (255 = 0% en modo invertido)
    out OCR0A, r16
    ret

;===========================================
; UpdatePWM
; Actualiza el valor PWM según el valor en r16 (0-15)
; Mapea 0-15 a 0-240 (incrementos de 16)
UpdatePWM:
    push r17
    push r18
    
    mov r17, r16
    andi r17, 0x0F
    
    ; Multiplicar por 16
    lsl r17
    lsl r17
    lsl r17
    lsl r17
    
    ; INVERTIR para modo invertido
    ldi r18, 255
    sub r18, r17        ; 255 - valor
    
    out OCR0A, r18
    
    pop r18
    pop r17
    ret

;===========================================
; HexTo7Segment
; Convierte el valor en r16 (0-15) a representación en display
; Conexiones:
; Segmentos a-f: PB0-PB5
; Segmento g: PD7
HexTo7Segment:
	push r17
	push r18
	push r19
	push ZH
	push ZL
	
	mov r17, r16
	andi r17, 0x0F			; Asegurar rango 0-15

	; Obtener patrón de tabla
	ldi ZH, HIGH(2*HexTo7Seg)
	ldi ZL, LOW(2*HexTo7Seg)
	add ZL, r17
	adc ZH, r1				; Sumar carry si existe
	lpm r17, Z

	; Invertir para ánodo común
	com r17

	; Segmentos a-f en PORTB (bits 0-5)
	lds r16, dato
	mov r18, r17
	andi r18, 0x3F
	out PORTB, r18

	; Segmento g en PORTD bit 7
	; IMPORTANTE: Preservar PD6 (PWM) y pull-ups de PD2-PD5
	mov r18, r17
	andi r18, 0x40			; Aislar bit 6 (segmento g)
	lsl r18					; Mover a bit 7
	
	in r19, PORTD			; Leer estado actual de PORTD
	andi r19, 0x7F			; Limpiar bit 7 (segmento g)
	or r19, r18				; Combinar con nuevo valor
	out PORTD, r19			; Escribir de vuelta

	pop ZL
	pop ZH
	pop r19
	pop r18
	pop r17
	ret