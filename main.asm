LIST	    P=16F887
#INCLUDE    <P16F887.INC>
    
;set configuration bits
; PIC16F887 Configuration Bit Settings
; Assembly source line config statements
;#include "p16f887.inc"
; CONFIG1
; __config 0x20D4
 __CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _PWRTE_OFF & _MCLRE_OFF & _CP_OFF & _CPD_OFF & _BOREN_OFF & _IESO_OFF & _FCMEN_OFF & _LVP_OFF
; CONFIG2
; __config 0x3FFF
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF
    
;declaracion de variables
;auxiliares para salvar contexto
W_TEMP	    EQU	    0x20
STATUS_TEMP EQU	    0x21
;auxiliar para la recepcion
NUM_REC	    EQU	    0x22
;auxiliares para guardar maximos y minimos
DECENA_MAX  EQU	    0x23
UNIDAD_MAX  EQU	    0x24
DECENA_MIN  EQU	    0x25
UNIDAD_MIN  EQU	    0x26
;auxiliares para verificar sensor, max/min, dec/un
SEL_SENSOR  EQU	    0x27
SEL_MIN_MAX EQU	    0x28
SEL_UN_DEC  EQU	    0x29
;auxiliares para comparar los max y min
DECENA_COMP EQU	    0x2A
UNIDAD_COMP EQU	    0x2B
;auxiliares para los valores que entrega el ADC
DECENA	    EQU	    0x2C
UNIDAD	    EQU	    0x2D
;aux para delays    
AUX_DISP    EQU	    0x2E
MULT_TMR0   EQU	    0x2F
AUX_TIEMPO  EQU	    0x30
CUENTA	    EQU	    0x31
CUENTA_2    EQU	    0x32
CONTADOR    EQU	    0x33
  
  
;vectores de inicio e interrupcion
	ORG	0x00	
	GOTO	INICIO
	ORG	0x04
	GOTO	INTERRUPCION
	
INICIO
	BANKSEL	ANSEL
;mod canales analogicos/digitales
	MOVLW	b'01100000'
	MOVWF	ANSEL		;RE0 y RE1 entrada analogica
	CLRF	ANSELH		;resto digital

;mod para baudio 9600
	BSF	BAUDCTL,3	;BCRG16=1 para baudio 9600
	;MOVLW	b'00000111'
	;MOVWF	OPTION_REG	;hab gral pull-up, prescaler 256
	
;mod entradas/salidas	
	BANKSEL	TRISA
	CLRF	TRISA		;PORTA salida
	MOVLW	b'00000011'
	MOVWF	TRISB		;RB0 y RB1 entrada, resto salida
	CLRF	TRISC		;PORTC	salida
	;BSF	TRISC,7		;RC7 entrada
	CLRF	TRISD		;PORTD salida
	CLRF	TRISE		    
	BSF	TRISE,0		;RE0 entrada
	BSF	TRISE,1		;RE1 entrada	
	
;prescaler 256, res pull up	
	MOVLW	b'00000011'
	MOVWF	WPUB		;res pull up para RB0 y RB1
	MOVWF	IOCB
	BCF	IOCB,0		;int por cambio de estado RB1
	
;asincrono, low speed, 9600 baudio, habilitacion interrupcion por recepcion
	BCF	TXSTA,4		;SYNC=0 para asincrono
	BSF	TXSTA,2		;BRGH=1 para low speed
	MOVLW	.25
	MOVWF	SPBRG		;para baudio 9600
	CLRF	PIE1
	BSF	PIE1,RCIE	;habilitamos interrupcion por recepcion
	
;voltaje de referecian y justificacion ADC
	CLRF	ADCON1		;voltaje de ref 5V y masa
	BSF	ADCON1,7	;justificacion derecha

;8 bits recepcion, habilitacion de recepcion
	BANKSEL	PORTA
	BSF	RCSTA,4	    ;CREN=1 para habilitar el receptor
	BCF	RCSTA,6	    ;RX9=0 para receibir 8 bits
	BSF	RCSTA,7	    ;SPEN=1 para habilitar recepcion	
	
;setear variables
	CLRF	NUM_REC
	
	MOVLW	.9
	MOVWF	DECENA_MAX
	MOVWF	UNIDAD_MAX
	CLRF	DECENA_MIN
	CLRF	UNIDAD_MIN
	
	CLRF	SEL_SENSOR
	CLRF	SEL_MIN_MAX
	CLRF	SEL_UN_DEC
      
	MOVLW	.5
	MOVWF	DECENA_COMP
	MOVWF	UNIDAD_COMP
	
	CLRF	UNIDAD
	CLRF	DECENA
	
	MOVLW	.100
	MOVWF	MULT_TMR0 
	MOVLW	.61
	MOVWF	TMR0
	MOVLW	.10
	MOVWF	AUX_TIEMPO 
	MOVLW	.250
	MOVWF	AUX_DISP
	CLRF	PORTA
	BCF	PORTC,0
	BCF	PORTC,1
	BCF	PORTC,2
	;eleccion de entrada analogica al ADC, oscilador, y ADC on
	MOVLW	b'11010101'
	MOVWF	ADCON0
	BANKSEL	OPTION_REG
	MOVLW	b'00000111'
	MOVWF	OPTION_REG	;hab gral pull-up, prescaler 256
	CALL	DELAY_ADC
	
;comienza conversion y habilitacion general interrupciones
	BANKSEL	PORTA
	BSF	ADCON0,1	    ;inicia la conversion
	MOVLW	b'11011000'	    ;hab gral int, RB0, RB1 y perifericos
	MOVWF   INTCON
	GOTO	PRINCIPAL
;TABLAS
TABLA_HEXA
	    ADDWF   PCL,1
	    RETLW    00H
	    RETLW    01H
	    RETLW    02H
	    RETLW    03H
	    RETLW    04H
	    RETLW    05H
	    RETLW    06H
	    RETLW    07H
	    RETLW    08H
	    RETLW    09H
	    RETLW    10H
	    RETLW    11H
	    RETLW    12H
	    RETLW    13H
	    RETLW    14H
	    RETLW    15H
	    RETLW    16H
	    RETLW    17H
	    RETLW    18H
	    RETLW    19H
	    RETLW    20H		
	    RETLW    21H
	    RETLW    22H
	    RETLW    23H
	    RETLW    24H
	    RETLW    25H
	    RETLW    26H
	    RETLW    27H
	    RETLW    28H
	    RETLW    29H
	    RETLW    30H
	    RETLW    31H
	    RETLW    32H
	    RETLW    33H
	    RETLW    34H
	    RETLW    35H
	    RETLW    36H
	    RETLW    37H
	    RETLW    38H
	    RETLW    39H
	    RETLW    40H
	    RETLW    41H
	    RETLW    42H
	    RETLW    43H
	    RETLW    44H
	    RETLW    45H
	    RETLW    46H
	    RETLW    47H
	    RETLW    48H
	    RETLW    49H
	    RETLW    50H
	    RETLW    51H
	    RETLW    52H
	    RETLW    53H
	    RETLW    54H
	    RETLW    55H
	    RETLW    56H
	    RETLW    57H
	    RETLW    58H
	    RETLW    59H
	    RETLW    60H
	    RETLW    61H
	    RETLW    62H
	    RETLW    63H
	    RETLW    64H
	    RETLW    65H
	    RETLW    66H
	    RETLW    67H
	    RETLW    68H
	    RETLW    69H
	    RETLW    70H
	    RETLW    71H
	    RETLW    72H
	    RETLW    73H
	    RETLW    74H
	    RETLW    75H
	    RETLW    76H
	    RETLW    77H
	    RETLW    78H
	    RETLW    79H
	    RETLW    80H	 
	    RETLW    81H
	    RETLW    82H
	    RETLW    83H
	    RETLW    84H
	    RETLW    85H
	    RETLW    86H
	    RETLW    87H
	    RETLW    88H
	    RETLW    89H
	    RETLW    90H
	    RETLW    91H
	    RETLW    92H
	    RETLW    93H
	    RETLW    94H
	    RETLW    95H
	    RETLW    96H
	    RETLW    97H
	    RETLW    98H
	    RETLW    99H
	    
TABLA_DISPLAY
	    ADDWF   PCL,1	    ;sumo w con el pcl
	    RETLW   b'00111111'	    ;0
	    RETLW   b'00000110'	    ;1
	    RETLW   b'01011011'	    ;2
	    RETLW   b'01001111'	    ;3
	    RETLW   b'01100110'	    ;4
	    RETLW   b'01101101'	    ;5
	    RETLW   b'01111101'	    ;6
	    RETLW   b'00000111'	    ;4
	    RETLW   b'01111111'	    ;8
	    RETLW   b'01101111'	    ;9	    
	    	
PRINCIPAL
	CALL    HUM_TEMP	    ;led que indica que se esta sensando
	CALL    MAX_MIN	    ;led que indica si se ingresa max o min
	CALL    DEC_UN	    ;led que indica si se ingresa dec o un
	CALL	SUB_RECEPCION
	CALL	DISPLAY
        CALL    VER_DEC_UN	    ;verificamos los valores optimos
	BTFSS   ADCON0,GO
	CALL    INT_ADC
	GOTO    PRINCIPAL

;subrutinas de programa principal
SUB_RECEPCION
	    MOVF    NUM_REC,W
	    ANDLW   0x0F		    ;limpio el nibble sup
	    BTFSS   SEL_MIN_MAX,0
	    GOTO    MIN		    
	    GOTO    MAX
    MIN
	    BTFSS   SEL_UN_DEC,0
	    GOTO    CARGAR_UN_MIN
	    GOTO    CARGAR_DEC_MIN
    MAX
	    BTFSS   SEL_UN_DEC,0
	    GOTO    CARGAR_UN_MAX
	    GOTO    CARGAR_DEC_MAX
    CARGAR_UN_MIN
	    MOVWF   UNIDAD_MIN
	    INCF    SEL_UN_DEC,1
	    RETURN
    CARGAR_DEC_MIN
	    MOVWF   DECENA_MIN
	    INCF    SEL_UN_DEC,1
	    RETURN
    CARGAR_UN_MAX
	    MOVWF   UNIDAD_MAX
	    INCF    SEL_UN_DEC,1
	    RETURN
    CARGAR_DEC_MAX
	    MOVWF   DECENA_MAX
	    INCF    SEL_UN_DEC,1
	    RETURN
	
DISPLAY
	    MOVF    DECENA,W
	    CALL    TABLA_DISPLAY
	    MOVWF   DECENA
	    MOVF    UNIDAD,W
	    CALL    TABLA_DISPLAY
	    MOVWF   UNIDAD
	    BCF	    PORTA,0
	    BSF	    PORTA,1
	    MOVF    DECENA,W
	    MOVWF   PORTD
	    ;DECFSZ  AUX_DISP,1
	    ;GOTO    $-1
	    CALL    Retardo_20ms
	    BCF	    PORTA,1
	    BSF	    PORTA,0
	    MOVF    UNIDAD,W
	    MOVWF   PORTD
	    ;DECFSZ  AUX_DISP,1
	    ;GOTO    $-1
	    CALL    Retardo_20ms
	    ;MOVLW   .250
	    ;MOVWF   AUX_DISP
	    RETURN
	
HUM_TEMP    
	    BTFSS   SEL_SENSOR,0    ;si es par on led de temp y off led de hum
	    BSF	    PORTA,2	    ;led que indica que se mide temperatura
	    BTFSS   SEL_SENSOR,0
	    BCF	    PORTA,3	    ;led que indica que se mide humedad
	    
	    BTFSC   SEL_SENSOR,0    ;si es impar on led de hum y off led de hum
	    BSF	    PORTA,3	    ;led que indica que se mide humedad
	    BTFSC   SEL_SENSOR,0
	    BCF	    PORTA,2
	    RETURN
	    
MAX_MIN     
	    BTFSS   SEL_MIN_MAX,0   ;si es par on led de min y off led de max
	    BSF	    PORTA,4	    ;led que indica que se ingresa valor minimo 
	    BTFSS   SEL_MIN_MAX,0
	    BCF	    PORTA,5
	    
	    BTFSC   SEL_MIN_MAX,0   ;si es impar on led de max y off led de min
	    BSF	    PORTA,5	    ;led que indica que se ingresa maximo
	    BTFSC   SEL_MIN_MAX,0
	    BCF	    PORTA,4
	    RETURN
	    
DEC_UN	    
	    BTFSS   SEL_UN_DEC,0    ;si es par on led de min y off led de max
	    BSF	    PORTA,6	    ;led que indica que se ingresa unidad
	    BTFSS   SEL_UN_DEC,0
	    BCF	    PORTA,7	    
	    BTFSC   SEL_UN_DEC,0    ;si es impar on led de dec y off led de min
	    BSF	    PORTA,7	    ;led que indica que se ingresa decena
	    BTFSC   SEL_UN_DEC,0
	    BCF	    PORTA,6
	    RETURN
	   
VER_DEC_UN	
;verifico si el valor del adc es mayor el limite mayor
;NUM1-NUM2 ------> si Z=1 NUM1=NUM2 -------> si Z=0 ocurren dos cosas:
;SI C=1 NUM1 ES MAYOR A NUM2             SI C=0 NUM1 ES MENOR A NUM2 

    VER_DEC_MAYOR    	 
	    MOVF    DECENA_COMP,W   ;valor que entrega el ADC
	    SUBWF   DECENA_MAX,W    ;DECENA_MAX-DECENA_COMP
	    BTFSC   STATUS,Z	    ;MAX=COMP?
	    GOTO    VER_UN_MAYOR    ;SI entc comparamos unidad 
	    BTFSC   STATUS,C	    ;MAX¿?COMP?
	    GOTO    VER_DEC_MENOR   ;MAX>COMP, verifico valor minimo
	    GOTO    ACT_MAYOR	    ;MAX<COMP, activo VENTILADOR    (TODO OK)
    VER_UN_MAYOR
	    MOVF    UNIDAD_COMP,W
	    SUBWF   UNIDAD_MAX,W    ;UNIDAD_MAX-UNIDAD_COMP
	    BTFSC   STATUS,C	    ;MAX¿?COMP
	    GOTO    VER_DEC_MENOR   ;MAX>=COMP, verifico valor minimo
	    GOTO    ACT_MAYOR	    ;MAX<COMP, activo VENTILADOR   (TODO OK)
	    
    VER_DEC_MENOR	    
	    MOVF    DECENA_MIN,W
	    SUBWF   DECENA_COMP,W   ;DECENA_COMP-DECENA_MIN
	    BTFSC   STATUS,Z	    ;COMP=MIN?
	    GOTO    VER_UN_MENOR    ;IGUAL, comparamos unidad   
	    BTFSC   STATUS,C	    ;COMP¿?MIN
	    RETURN		    ;COMP>MIN, volvemos a rut principal
	    GOTO    ACT_MENOR	    ;COMP<MIN, activo BOMBA/LUZ 	    
    VER_UN_MENOR
	    MOVF    UNIDAD_MIN,W	
	    SUBWF   UNIDAD_COMP,W   ;UNIDAD_COMP-UNIDAD_MIN
	    BTFSS   STATUS,C	    ;COMP¿?MIN
	    GOTO    ACT_MENOR	    ;COMP<MIN, activo BOMBA/LUZ
	    RETURN		    ;COMP>=MIN, volvemos rutina principal	    
    
    ACT_MAYOR
	    BTFSS   SEL_SENSOR,0    ;si es par on temp y off hum
	    GOTO    VENTILADOR	    ;BSF	    PORTB,2	    ;enciendo VENTILADOR  
	    RETURN	    
	    
    ACT_MENOR
	    BTFSS   SEL_SENSOR,0    ;si es par on temp y off hum
	    GOTO    LUZ		    ;enciendo luz
	    GOTO    AGUA
	    
    LUZ
	    BCF	    PORTA,0
	    BCF	    PORTA,1
	    BSF	    PORTC,0			    ;puerto por donde sale la alimentacion para la lus
	    BCF	    PORTC,1			    ;puerto por donde se enciende la bomba
	    MOVLW   .61		
	    MOVWF   TMR0
	    BTFSS   INTCON,2
	    GOTO    $-1
	    MOVWF   TMR0
	    BCF	    INTCON,2
	    DECFSZ  MULT_TMR0,1
	    GOTO    LUZ
	    BCF	    PORTC,0		    ;puerto por donde se enciende la luz
	    MOVLW   .100
	    MOVWF   MULT_TMR0
	    RETURN
	    
    AGUA
	    BCF	    PORTA,0
	    BCF	    PORTA,1
	    BSF	    PORTC,1			    ;puerto por donde se enciende la bomba
	    BCF	    PORTC,0			    ;puerto por donde se enciende la luz
	    MOVLW   .61		
	    MOVWF   TMR0
	    BTFSS   INTCON,2
	    GOTO    $-1
	    BCF	    INTCON,2
	    DECFSZ  MULT_TMR0,1
	    GOTO    AGUA
	    BCF	    PORTC,1			    ;puerto por donde se enciende el agua
	    MOVLW   .100
	    MOVWF   MULT_TMR0
	    RETURN
	    
    VENTILADOR
	    BCF	    PORTA,0
	    BCF	    PORTA,1
	    BSF	    PORTC,2			    ;puerto por donde se enciende el ventilador
	    MOVLW   .61		    ;cargo el TMR0 (50mseg)
	    MOVWF   TMR0    
	    BTFSS   INTCON,2	    ;salto si se levanto la flag
	    GOTO    $-1		    
	    BCF	    INTCON,2	    ;limpio la flag
	    DECFSZ  MULT_TMR0,1	    ;decremento el multiplicador para los 10 seg
	    GOTO    VENTILADOR	    ;si no es cero vuelvo a chequear
	    BCF	    PORTC,2			    ;puerto por donde se enciende el ventilador
	    MOVLW   .100
	    MOVWF   MULT_TMR0
	    RETURN
	     
INT_ADC
	    BTFSS   SEL_SENSOR,1
	    GOTO    ADC_TEMP	
	    GOTO    ADC_HUM
	    
ADC_TEMP
	    BANKSEL ADRESL
	    RRF	    ADRESL,1
	    BCF	    ADRESL,7
	    MOVF    ADRESL,W
	    CALL    TABLA_HEXA
	    BANKSEL PORTA
	    MOVWF   DECENA
	    MOVWF   DECENA_COMP
	    MOVWF   UNIDAD
	    MOVWF   UNIDAD_COMP
	    SWAPF   DECENA,1
	    SWAPF   DECENA_COMP,1
	    MOVLW   b'00001111'
	    ANDWF   UNIDAD,1
	    ANDWF   DECENA,1
	    ANDWF   UNIDAD_COMP,1
	    ANDWF   DECENA_COMP,1
	    MOVLW   b'11010101'
	    MOVWF   ADCON0
	    CALL    DELAY_ADC
	    BSF	    ADCON0,1
	    RETURN
	    
ADC_HUM
	    BANKSEL ADRESL
	    COMF    ADRESL,W
	    CALL    TABLA_HEXA
	    BANKSEL PORTA
	    MOVWF   DECENA
	    MOVWF   DECENA_COMP
	    MOVWF   UNIDAD
	    MOVWF   UNIDAD_COMP
	    SWAPF   DECENA,1
	    SWAPF   DECENA_COMP,1
	    MOVLW   b'00001111'
	    ANDWF   UNIDAD,1
	    ANDWF   DECENA,1
	    ANDWF   UNIDAD_COMP,1
	    ANDWF   DECENA_COMP,1
	    MOVLW   b'11011001'
	    MOVWF   ADCON0
	    CALL    DELAY_ADC
	    BSF	    ADCON0,1
	    RETURN

DELAY_ADC
	    MOVLW    .10
	    MOVWF   AUX_TIEMPO
    LOOP    DECFSZ  AUX_TIEMPO,1
	    GOTO    LOOP
	    RETURN	    
	
;subrutinas de interrupcion	
	
INTERRUPCION
	    CALL    SALVAR_CONTEXTO
	    BTFSC   INTCON,0
	    GOTO    INT_RB1
	    BTFSC   INTCON,1
	    GOTO    INT_RB0
	    BTFSC   PIR1,RCIF
	    GOTO    RECEPCION
	    GOTO    FIN
FIN
	    CALL    DEVOLVER_CONTEXTO
	    BCF	    PIR1,RCIF
	    BCF	    INTCON,0
	    BCF	    INTCON,1
	    RETFIE
SALVAR_CONTEXTO
	    MOVWF   W_TEMP
	    SWAPF   STATUS,W
	    MOVWF   STATUS_TEMP
	    RETURN
DEVOLVER_CONTEXTO   
	    SWAPF   STATUS_TEMP,W
	    MOVWF   STATUS
	    SWAPF   W_TEMP,1
	    SWAPF   W_TEMP,0
	    RETURN	    	    

RECEPCION
	    MOVF    RCREG,W
	    MOVWF   NUM_REC
	    GOTO    FIN

INT_RB0
	    INCF    SEL_SENSOR,1
	    GOTO    FIN
INT_RB1
	    INCF    SEL_MIN_MAX,1
	    GOTO    FIN

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


