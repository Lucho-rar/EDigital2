LIST	    P=16F887
#INCLUDE    <P16F887.INC>
    

__CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _PWRTE_OFF & _MCLRE_OFF & _CP_OFF & _CPD_OFF & _BOREN_OFF & _IESO_OFF & _FCMEN_OFF & _LVP_OFF
; CONFIG2
; __config 0x3FFF
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF
CUENTA	    EQU	    0x31
CUENTA_2    EQU	    0x32
CONTADOR    EQU	    0x33
AUXILIO	    EQU	    0x34
DIEZ_SEG    EQU	    0x35

	ORG 0
	GOTO	 INICIO
	ORG 4
	GOTO	 INTER
	
INICIO
	BANKSEL	AUXILIO
	CLRF	AUXILIO
	BANKSEL	SPBRG
	MOVLW	.25
	MOVWF	SPBRG
	
	BANKSEL TXSTA
	BCF	TXSTA,4; ASINCRIONO
	BSF	TXSTA,2; HIGH SPEED
	BCF	TXSTA,6;8 BITS
	BSF	TXSTA,5;HABILITA TX
	
	BANKSEL	TRISD
	CLRF	TRISD
	
	BANKSEL	RCSTA
	BSF	RCSTA,7;
	BSF	RCSTA,4;
	BCF	RCSTA,6;
	
	
	BANKSEL	PIR1
	BCF	PIR1,RCIF;
	
	
	BANKSEL INTCON
	MOVLW	b'01010000'
	MOVWF	INTCON
	BANKSEL	PIE1
	BCF	PIE1,RCIE
	BCF	PIE1,TXIE
	
	BANKSEL	TRISB
	MOVLW	B'00000001'
	MOVWF	TRISB
	BANKSEL	PORTD
	CLRF	PORTD
	GOTO	ESPERA

INTER
	BANKSEL	PIE1
	BSF	PIE1,TXIE
	RETFIE
	
ESPERA
	BSF	PORTD,0
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	;GOTO	ESPERA
	GOTO	START
START
	;                   RUTINA QUE ENVIA SENTENCIA DE CAMBIO DE MINIMO             ;
	;MOVLW	.2		; LE AVISO AL RECEPTOR QUE VOY A ENVIAR LA RUT. MINIMO
	;MOVWF	TXREG
	;BANKSEL	PORTD
	;BSF	PORTD,0
	;CALL	Retardo_20ms
	;BCF	PORTD,0
	;CALL	Retardo_20ms
	MOVLW	.1		;  LE ENVIO LA UNIDAD
	MOVWF	TXREG
	BANKSEL	PORTD
	BSF	PORTD,0
	CALL	Retardo_20ms
	BCF	PORTD,0
	CALL	Retardo_20ms
	MOVLW	.1		;  LE ENVIO LA DECENA
	MOVWF	TXREG
	BANKSEL	PORTD
	BSF	PORTD,0
	CALL	Retardo_20ms
	BCF	PORTD,0
	CALL	Retardo_20ms
	
	CALL	Retardo_400ms	    ; ESPACIO LIBRE ENTRE QUE CAMBIO LOS MINIMOS
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	
	
	MOVLW	.0		;  LE ENVIO LA UNIDAD
	MOVWF	TXREG
	BANKSEL	PORTD
	BSF	PORTD,0
	CALL	Retardo_20ms
	BCF	PORTD,0
	CALL	Retardo_20ms
	MOVLW	.0		;  LE ENVIO LA DECENA
	MOVWF	TXREG
	BANKSEL	PORTD
	BSF	PORTD,0
	CALL	Retardo_20ms
	BCF	PORTD,0
	CALL	Retardo_20ms
	
	CALL	Retardo_400ms	    ; ESPACIO LIBRE ENTRE QUE CAMBIO LOS MINIMOS
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	
	
	
	
	MOVLW	.2		;  LE ENVIO LA UNIDAD
	MOVWF	TXREG
	BANKSEL	PORTD
	BSF	PORTD,0
	CALL	Retardo_20ms
	BCF	PORTD,0
	CALL	Retardo_20ms
	MOVLW	.2		;  LE ENVIO LA DECENA
	MOVWF	TXREG
	BANKSEL	PORTD
	BSF	PORTD,0
	CALL	Retardo_20ms
	BCF	PORTD,0
	CALL	Retardo_20ms
	
	CALL	Retardo_400ms	    ; ESPACIO LIBRE ENTRE QUE CAMBIO LOS MINIMOS
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	
	
	MOVLW	.0		;  LE ENVIO LA UNIDAD
	MOVWF	TXREG
	BANKSEL	PORTD
	BSF	PORTD,0
	CALL	Retardo_20ms
	BCF	PORTD,0
	CALL	Retardo_20ms
	MOVLW	.0		;  LE ENVIO LA DECENA
	MOVWF	TXREG
	BANKSEL	PORTD
	BSF	PORTD,0
	CALL	Retardo_20ms
	BCF	PORTD,0
	CALL	Retardo_20ms
	
	CALL	Retardo_400ms	    ; ESPACIO LIBRE ENTRE QUE CAMBIO LOS MINIMOS
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	
	MOVLW	.9		;  LE ENVIO LA UNIDAD
	MOVWF	TXREG
	BANKSEL	PORTD
	BSF	PORTD,0
	CALL	Retardo_20ms
	BCF	PORTD,0
	CALL	Retardo_20ms
	
	
	MOVLW	.1		;  LE ENVIO LA UNIDAD
	MOVWF	TXREG
	BANKSEL	PORTD
	BSF	PORTD,0
	CALL	Retardo_20ms
	BCF	PORTD,0
	CALL	Retardo_20ms
	MOVLW	.1		;  LE ENVIO LA DECENA
	MOVWF	TXREG
	BANKSEL	PORTD
	BSF	PORTD,0
	CALL	Retardo_20ms
	BCF	PORTD,0
	CALL	Retardo_20ms
	
	CALL	Retardo_400ms	    ; ESPACIO LIBRE ENTRE QUE CAMBIO LOS MINIMOS
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	
	
	MOVLW	.9		;  LE ENVIO LA UNIDAD
	MOVWF	TXREG
	BANKSEL	PORTD
	BSF	PORTD,0
	CALL	Retardo_20ms
	BCF	PORTD,0
	CALL	Retardo_20ms
	MOVLW	.9		;  LE ENVIO LA DECENA
	MOVWF	TXREG
	BANKSEL	PORTD
	BSF	PORTD,0
	CALL	Retardo_20ms
	BCF	PORTD,0
	CALL	Retardo_20ms
	
	CALL	Retardo_400ms	    ; ESPACIO LIBRE ENTRE QUE CAMBIO LOS MINIMOS
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	CALL	Retardo_400ms
	GOTO	POST
	
	
	
	;MOVLW	.1
	;MOVWF	TXREG
	;BCF	PIR1,RCIF
	;BANKSEL	PORTD
	;BSF	PORTD,0
	;CALL	Retardo_400ms
	;CALL	Retardo_400ms
	;CALL	Retardo_20ms
	;BCF	PORTD,0
	;CALL	Retardo_400ms
	;CALL	Retardo_400ms
	;CALL	Retardo_20ms
	;GOTO	POST
	
	
	
	;MOVLW	'2'
	;MOVWF	TXREG
	;BCF	PIR1,RCIF
	;BANKSEL	PORTD
	;BSF	PORTD,1
	;CALL	Retardo_400ms
	;CALL	Retardo_400ms
	;CALL	Retardo_400ms
	;BCF	PORTD,1
	;CALL	Retardo_400ms
	;CALL	Retardo_400ms
	;CALL	Retardo_400ms
	;GOTO	START
	
POST
	BANKSEL	PORTD
	BCF	PORTD,2
	GOTO POST
	
Retardo_400ms 
    CALL    Retardo_20ms
    CALL    Retardo_20ms
    CALL    Retardo_20ms
    CALL    Retardo_20ms
    CALL    Retardo_20ms
    CALL    Retardo_20ms
    CALL    Retardo_20ms
    CALL    Retardo_20ms
    CALL    Retardo_20ms
    CALL    Retardo_20ms 
    CALL    Retardo_20ms
    CALL    Retardo_20ms
    CALL    Retardo_20ms
    CALL    Retardo_20ms
    CALL    Retardo_20ms
    CALL    Retardo_20ms
    CALL    Retardo_20ms
    CALL    Retardo_20ms
    CALL    Retardo_20ms
    CALL    Retardo_20ms 
    Return
 
; 5ms 
Retardo_20ms
    MOVLW   D'200'; 1cy -> k
    GOTO    Retardos_ms ; 2cy 
 
; 5ms 
Retardo_5ms
    MOVLW   D'50'; 1cy -> k
    GOTO    Retardos_ms ; 2cy
Retardos_ms  
    MOVWF   CUENTA_2; cy
Retardo_Milis
    MOVLW   D'180' ; kcy -> x
    MOVWF   CUENTA ;kcy
BUCLE_milis
    NOP
    DECFSZ  CUENTA,F; kcy(x-1) + 2cy
    GOTO    BUCLE   ; 2kcy(x-1)
    DECFSZ  CUENTA_2,F ;cy(k-1) + 2cy 
    GOTO    Retardo_Milis ;2cy(k-1)
    RETURN  ;2cy   
    
    
    
; 1ms = 1000us
Retardo_1ms
    NOP
    NOP
    NOP
    MOVLW   D'10'; 1cy -> k
    GOTO    Retardos ; 2cy

Retardo_200us
    MOVLW   D'3'; 1cy -> k
    GOTO    Retardos ; 2cy    
   
Retardo_300us
    MOVLW   D'3'; 1cy -> k
    GOTO    Retardos ; 2cy
    
;500us 
Retardo_500us
    MOVLW   D'5'; 1cy -> k
Retardos  
    MOVWF   CUENTA_2; cy
Retardo_Micros
    MOVLW   D'165' ; kcy -> x
    MOVWF   CUENTA ;kcy
BUCLE
    DECFSZ  CUENTA,F; kcy(x-1) + 2cy
    GOTO    BUCLE   ; 2kcy(x-1)
    DECFSZ  CUENTA_2,F ;cy(k-1) + 2cy 
    GOTO    Retardo_Micros ;2cy(k-1)
    RETURN  ;2cy   

    
    
;100us
Retardo_100us; 8CY + 3XCY
    MOVLW   D'164'
    NOP
    GOTO    Retardo_micros

;50us
Retardo_50us	    ;7cy + 3xcy  
    MOVLW   D'81'
    GOTO    Retardo_micros
    
;20us 
Retardo_20us;7CY + 3XCY	    
    MOVLW   D'31'
    GOTO    Retardo_micros

;10us 
Retardo_10us;8CY + 3XCY
    MOVLW   D'14'
    NOP
    GOTO    Retardo_micros  
    
;5us    
Retardo_5us;7CY + 3XCY
    MOVLW   D'6'
    GOTO    Retardo_micros
Retardo_micros
    MOVWF   CUENTA
Bucle
    DECFSZ  CUENTA,F
    GOTO    Bucle
    RETURN 
    
;1us
Retardo_1us
    NOP
    RETURN

    END
	
	
	
	
	
	
	
	
	
	
	
