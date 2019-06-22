;   Trabajo Práctico Sopa de letras
;   Integrantes:
;               Vargas,     Ignacio
;               Paez,       Roberto
;               Saczkowski, Mariano

name "SopaDeLetras"

ORG 100h

JMP INICIO_JUEGO


;Definicion de bytes y palabras


    menu		DB "           ######   #######  ########     ###            " ,10,13
                DB "          ##    ## ##     ## ##     ##   ## ##           " ,10,13
                DB "          ##       ##     ## ##     ##  ##   ##          " ,10,13
                DB "           ######  ##     ## ########  ##     ##         " ,10,13
                DB "                ## ##     ## ##        #########         " ,10,13
                DB "          ##    ## ##     ## ##        ##     ##         " ,10,13
                DB "           ######   #######  ##        ##     ##         " ,10,13
                DB "                                                         " ,10,13
                DB "                   ########  ########                    " ,10,13
                DB "                   ##     ## ##                          " ,10,13
                DB "                   ##     ## ##                          " ,10,13
                DB "                   ##     ## ######                      " ,10,13
                DB "                   ##     ## ##                          " ,10,13
                DB "                   ##     ## ##                          " ,10,13
                DB "                   ########  ########                    " ,10,13
                DB "                                                         " ,10,13
                DB " ##       ######## ######## ########     ###     ######  " ,10,13
                DB " ##       ##          ##    ##     ##   ## ##   ##    ## " ,10,13
                DB " ##       ##          ##    ##     ##  ##   ##  ##       " ,10,13
                DB " ##       ######      ##    ########  ##     ##  ######  " ,10,13
                DB " ##       ##          ##    ##   ##   #########       ## " ,10,13
                DB " ##       ##          ##    ##    ##  ##     ## ##    ## " ,10,13
                DB " ######## ########    ##    ##     ## ##     ##  ######  " ,10,13
				DB "---------------------------------------------------------" ,10,13
				DB "  Presione Enter para continuar o I para informacion...  " ,10,13,'$'
				
				

     info        DB  "ACA VA LA INFO",'$'


    pantalla   	DB  201,20 dup(205),203,52 dup(205),                                                             187,10, 13
                DB  186,02 dup(032),'SOPA  DE  LETRAS',2 dup(32),186,21 dup(32),"PREGUNTAS!",21 dup(32),         186,10, 13
                DB  204,20 dup(203),206,52 dup(203),                                                             185,10, 13
				DB  204,20 dup(202),206,52 dup(202),                                                             185,10, 13
                DB  186,"rrrrrrrrrrr&&&&&&&&&",186,"                                                    "       ,186,10, 13
                DB  186,"r&&&&&&&rrrrrrrrrrrr",186,"                                                    "       ,186,10, 13
                DB  186,"rrrrrrrrrrrrrrrrrrrr",186,"1",16,"%pppppppppppppppppppppppppppppppppppppppppppppppp",42,186,10, 13
                DB  186,"rrrrr&&&&&&&&&&&rrrr",186,"2",16,"%pppppppppppppppppppppppppppppppppppppppppppppppp",42,186,10, 13
                DB  186,"rrrrrrrrrrrrrrrrrrrr",186,"3",16,"%pppppppppppppppppppppppppppppppppppppppppppppppp",42,186,10, 13
                DB  186,"&&&&rrrrrrrrrrrrrrrr",186,"4",16,"%pppppppppppppppppppppppppppppppppppppppppppppppp",42,186,10, 13
                DB  186,"rrrrrrrrr&&&&&&&rrrr",186,"5",16,"%pppppppppppppppppppppppppppppppppppppppppppppppp",42,186,10, 13
                DB  186,"rrrrrrrrrrrrrrrrrrrr",186,"6",16,"%pppppppppppppppppppppppppppppppppppppppppppppppp",42,186,10, 13
                DB  186,"r&&&&&&&rrrrrrrrrrrr",186,"7",16,"%pppppppppppppppppppppppppppppppppppppppppppppppp",42,186,10, 13
                DB  186,"rrrrrrrrrr&&&&&&&&rr",186,"8",16,"%pppppppppppppppppppppppppppppppppppppppppppppppp",42,186,10, 13
                DB  186,"rrrrrrrrrrrrrrrrrrrr",186,"9",16,"%pppppppppppppppppppppppppppppppppppppppppppppppp",42,186,10, 13
                DB  186,"rr&&&&&&&&&&&&rrrrrr",186,"A",16,"%pppppppppppppppppppppppppppppppppppppppppppppppp",42,186,10, 13
                DB  186,"rrrrrrrrrrrrrrrrrrrr",186,"                                                    "       ,186,10, 13
                DB  186,"&&&&&rrrrrrrrrrrrrrr",186,"                                                    "       ,186,10, 13
                DB  186,"rrrrrrrrrrrr&&&&rrrr",186,"                                                    "       ,186,10, 13
                DB  200,20 dup(205),202,52 dup(205),                                                             188,10,13,'$' 

                ;Para el posicionamiento de las respuestas comparo con signo &, en documento despues del $
                ;Para el posicionamiento de las preguntas comparo con signo %,  en documento antes del $
                ;Para el posicionamiento de las aleatorias comparo con r.
   
	;Seccion manejo de archivos
	
	archivo     DB "c:\tp\preguntasOK.txt" , 0   ;Ubicacion del archivo a utilizar
    ;archivo2    DB "c:\tp\preguntas2.txt" , 0  ;Ubicacion del archivo a utilizar
    ID_Archivo  DW  ? ;HANDLE de archivo
    
    ;Respuestas a leer
    ;COMPUERTA%HARVARD%COMPUTADORA%CISC%MENTIRA%BINARIO%PIPELINE%ARQUITECTURA%ASCII%RISC$-   85 caracteres
    bytesRta    DW	0FFFFh
    rtaLeidas   DB  600 dup ('$')
    ;Inicio errores
    
    msgErrorApertura    DB  10,13,"Se produjo un error al intentar ABRIR el archivo",'$'
    msgErrorLectura     DB  10,13,"Se produjo un error al intentar LEER el archivo (respuestas)",'$'
    
    ;Fin errores
    ;Fin Seccion manejo de archivos
    
    ;Limite de pantalla
    
    ;OK EMU8086
        ;Limites en X
    limMin_X    DB  0   + 1       ;pos 0 de matriz mas uno de pared
    limMax_X    DB  21  - 1       ;pos 21 de pared menos uno fin de matriz
        ;Limites en Y
    limMin_Y    DB  4 + 0       ;pos 4 de menu mas 0 de comienzo de matriz
    limMax_Y    DB  4 + 14      ;pos 4 de menu mas 14 del alto de la matriz (por alguna razon empieza en uno y no pongo el 15)
    
;    ;   OK EN DOSBOX .COM 
;    ;Limites en X
;    limMin_X    DB  0   + 1       ;pos 0 de matriz mas uno de pared
;    limMax_X    DB  21  - 1       ;pos 21 de pared menos uno fin de matriz
;    ;Limites en Y
;    limMin_Y    DB  6       ;pos 3 de menu mas 0 de comienzo de matriz
;    limMax_Y    DB  20      ;pos 3 de menu mas 14 del alto de la matriz (por alguna razon empieza en uno y no pongo el 15)
;    
;   
    
    ;Posiciones de cursor
    ;   Inicializo el cursor en el centro de la matriz
    posInicialCursor_X  DB  10 + 1 ;le sumo 1 por el recuadro
    posInicialCursor_Y  DB  7 + 3  ;
    
    
    resto DB 26
	letra DB ?
	copia DB ?       
	estadoDelJuego DB 0 ; estado 0 es juego no inicio, estado 1 es juegoIniciado Sin letra seleccionada, estado 2 es juegoIniciado con palabra Seleccionada.
    cordenadaRespF DB 14 dup(0)  ;Van a ser las cordenadas del Fin de las respuesta. 
    cordenadaRespI DB 14 dup(0)  ;Van a ser las cordenadas de Pantalla de Inicio de las respuesta.
    idxPregunta DW 0 ; Empieza en la pregunta 1, indice 0 (obvio)
    respuestasOk DW 0  ; Respuestas que contesta correctamente
	  
;Fin de definicion de bytes y palabras

;¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
;----------------------------Definicion de macros---------------------------
;___________________________________________________________________________

;Muestro por pantalla un elemento del tipo cadena
print MACRO txt
    MOV AH, 09h
    LEA DX, txt
    INT 21h
ENDM


abrirArchivo MACRO nombre   ;al llamar al macro pido la ubicacion del archivo
    MOV AH, 3Dh
    MOV AL, 0h         ;Lo abro en modo solo lectura
    LEA DX, nombre     ;Le paso el archivo a leer
    INT 21h
    
    JC errorApertura    ;Si carry = 1 salta muestra error de apertura
    
    ;Guardo en ID_Archivo el numero de 2 bytes que crea el OS para identificar el archivo
    MOV ID_Archivo,AX   
ENDM




leerRta MACRO id, bytes, salida
    MOV AH, 3Fh
    MOV BX, id       ;le paso el id del documento
    LEA DX, salida   ;le paso en donde guardar lo leido
    MOV CX, bytes
    INT 21h
    
    JC  errorLectura ;Si carry = 1 Muestra error de lectura
ENDM


cerrarArchivo MACRO nombre  ;al llamar al macro pido el id del archivo
    MOV AH, 3Eh
    MOV BX, nombre  ;Le paso el id del archivo a cerrar 
    INT 21h
ENDM

;Posiciona el cursor en un lugar determinado por (X,Y)
setCursor MACRO pos_X,pos_Y

    
    MOV DH,pos_Y        ;Fila       # X
    MOV DL,pos_X        ;Columna    # Y
    MOV BH,0            ;Pagina     # 0 o principal
    ;la funcion 02h de la interrupcion
    ;10h Asigna una posición al cursor 
    MOV AH,2
	INT 10h
ENDM


;Escribe letra en color
putLetra MACRO colorH, colorL
    MOV AH,09H
    MOV AL,letra     ;AL misma letra. Tal vez se pueda omitir esta instruccion
    MOV BH,colorH          ;Color BIOS BH y BL
    MOV BL,colorL          ;Rojo 0100, Verde 0010, amarillo 1110
    MOV CX,01H          ;Un solo caracter repetido
    INT 10H    
ENDM


;Fin de macros
;¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
;-------------------------Definicion de procedimientos----------------------
;___________________________________________________________________________
 
; Guarda en letra el caracter donde esta el cursor
setLetraDelCursor PROC
    ;leo caracter de la pagina 0
    MOV AH,08h
    MOV BH,00h         
    INT 10h
    MOV letra, AL  ;Leo el caracter y lo guardo en letra
    RET
ENDP

;Caracter la palabra que responde la pregunta.
limpiarRegistros PROC
    XOR AX,AX
	XOR BX,BX
	XOR CX,CX
	XOR DX,DX  	 
	XOR SI,SI
	XOR BP,BP
    RET
ENDP

;Inicializo y muestro el cursor
iniciarCursor PROC
    setCursor posInicialCursor_X,posInicialCursor_Y
    MOV AH,0  
    INT 16h
	RET
ENDP   
       
       
resetCursor PROC
    setCursor 0,0
    MOV AH,0  
    INT 16h
	RET
ENDP       
                      
; Posicion del cursor se guardan en DL(x), DH(y)
getCursorPosition PROC
    MOV AH, 3
    MOV BH, 0
    INT 10h
    RET    
ENDP       
       
cargarPantalla PROC
    ; use this code for compatibility with dos/cmd prompt full screen mode: 
    MOV AX, 1003h
    MOV BX, 0        ; disable blinking. 
    INT 10h
    bucle:
        INC SI                                  ;
        CMP pantalla[SI],'&'                    ;
        JE  VERIFICAR                           ;
        
        CMP pantalla[SI],'r'                    ;
        JE GENERAR_LETRA                        ;
        
        CMP pantalla[SI],'p'
        JE VERIFICAR
                
        CMP pantalla[SI],'$'                    ;
        JNE bucle                               ;
    RET
ENDP

;Fin  de procedimientos


;------------------------------SALTOS------------------------------
GENERAR_LETRA:
;genera las letras que van en la matriz haciendo un calculo
	    ;XOR AX,AX
	    MOV copia, CL                  	 
	    MOV AH,2ch                   	 
	    INT 21h                 	;inicializa el reloj
	    ADD DL,26               	;
	    MOV AL,DL               	;guarda las centesimas del reloj
	    MOV CL, copia           	;
	    XOR AH,AH               	;reiniciamos ah
	    DIV resto               	;dividimos el nro de la centesimax2                     	 
	    ADD AH,65               	;se le suma 65 a ah
        
        ;MOV AH,'0'
	    MOV pantalla[SI], AH
	    JMP bucle           

incPosBp:

    ;MOV cordenadaRespF[numDeResp],SI ; Cordenadas FINAL de respuesta
    ;INC numDeResp
    INC BP
    
    JMP VERIFICAR
    
VERIFICAR:
    CMP rtaLeidas[BP],'$'    
    JE  bucle
    CMP rtaLeidas[BP],'%' 
       
    JE  incPosBP
    
    JNE ingresarRta

ingresarRta:
        MOV DL,rtaLeidas[BP]
        MOV pantalla[SI],DL
        INC BP
    JMP bucle


errorApertura:
    print msgErrorApertura
    JMP fin
errorLectura:
    print msgErrorLectura
    JMP fin
	
;Fin de saltos

;¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
;-----------------------------INICIO DEL JUEGO------------------------------
;___________________________________________________________________________




INICIO_JUEGO:
 
;LIMPIO REGISTROS DE PROPOSITO GENERAL
        CALL limpiarRegistros   
        
        abrirArchivo archivo                    ;abrirArchivo recibe la ubicaion del archivo - 
                                                ;lo abre y retorna su id en ID_Archivo
        leerRta ID_Archivo,bytesRta,rtaLeidas   ;leerRta recibe el id del archivo y los bytes a leer - 
                                                ;lo lee y retorna esa seccion en rtaLeidas
        cerrarArchivo ID_Archivo                ;cerrarArchivos recibe el id del archivo y lo cierra

        CALL limpiarRegistros                   ;
        CALL cargarPantalla  
		print menu               
		
		MOV BH,0
		MOV estadoDelJuego,BH   
		JMP DETECTAR_TECLA
		 
		 
		 
		 
INICIO_SOPA:

        
        CALL resetCursor                    ;      		
        print pantalla 
        
        MOV BH,1
		MOV estadoDelJuego,BH              
                  
		
		
		

INICIALIZAR_CURSOR:        
        ;inicializo el cursor para que quede en espera de una tecla.
        CALL iniciarCursor 
        JMP DETECTAR_TECLA


    

DETECTAR_TECLA:  ;cuando aprete (a,s,d,w) le da la direccion al cursor para donde tiene que ir    
        
        CMP AL,'w'
        JE MOVER_ARRIBA        
        CMP AL,'s'
        JE MOVER_ABAJO        
        CMP AL,'a'
        JE MOVER_IZQUIERDA        
        CMP AL,'d'
        JE MOVER_DERECHA
                
        CMP AL,13               ;SI TOCA ENTER elige la  letra
       ; JE RESPUESTA_INICIO   
        
        JE EVALUAR_ENTER  
        
        
        
        ;CMP AL,27
        ;JE RESPUESTA_FIN
        
        CMP AL,'q'
        JE fin
        
        ;JNE DETECTAR_TECLA
            
            
            
        
MOVER_DERECHA: ;mueve el cursor hacia derecha 1 pos
        
        CMP DL,limMax_X             ;Esta en la ultima columna? si
        JE primeraColumna           ; si estoy en la columna 19 y toco tecla voy a la 0
        INC DL
        MOV BH,0
        MOV AH,2        
        INT 10h
        MOV AH,0
        INT 16h  
        JMP DETECTAR_TECLA        
                              
MOVER_ARRIBA:  ;mueve el cursor hacia arriba 1 pos
        CMP DH,limMin_Y     ;0 Esta en la primera fila? si
        JE  ultimaFila   ;  Cuando esta en la primer fila y toca tecla va a la ultima
        DEC DH
        MOV BH,0
        MOV AH,2        
        INT 10h
        MOV AH,0
        INT 16h
        JMP DETECTAR_TECLA
        
MOVER_ABAJO:  ;mueve el cursor hacia abajo 1 pos 
        CMP DH,limMax_Y       ; Esta en la ultima fila? si
        JE primeraFila        ; toca tecla va a la primera
        INC DH
        MOV BH,0
        MOV AH,2        
        INT 10h
        MOV AH,0
        INT 16h
        JMP DETECTAR_TECLA
             

                        
MOVER_IZQUIERDA: ;mueve el cursor hacia izquierda 1 pos
        CMP DL,limMin_X         ;Esta en la primera columna? si
        JE ultimaCulumna        ;toco izq y voy a la ultima 
        DEC DL
        MOV AH,2        
        MOV BH,0
        
        INT 10h
        MOV AH,0
        INT 16h
        JMP DETECTAR_TECLA
               
               
               
EVALUAR_ENTER: ;Controla en que momento del juego esta para determinar la accion del enter.
        MOV BH,estadoDelJuego
        CMP BH,0  ;Revisa si ya se inicio el juego.    
        JE  INICIO_SOPA
        CMP BH,1
        JE  RESPUESTA_INICIO
        CMP BH,2
        JE  RESPUESTA_FIN
        
; Extremos de cursor                    
ultimaFila: ;cuando este en la fila 0 y se vaya hacia arriba, aparecera en la fila mas baja
        MOV AH,2        
        MOV BH,0
        MOV DH,limMax_y         ;cantidad de filas menos una por empezar en cero   14
        INT 10h
        
        MOV AH,0
        INT 16h
        JMP DETECTAR_TECLA
                      
primeraFila:  ;cuando este en la fila 10 y se vaya hacia arriba,
        ;aparecera de en la fila mas alta
        MOV AH,2
        MOV BH,0
        MOV DH,limMin_Y        ;0
        INT 10h
        
        MOV AH,0
        INT 16h
        JMP DETECTAR_TECLA
                      
ultimaCulumna: ;cuando este en la columna 0 y se vaya hacia la derecha,
           ;aparecera en la ultima columna
        
        MOV AH,2
        MOV BH,0        
        MOV DL,limMax_X   ;cantidad de columnas menos uno por empezar en cero  19
        ;DEC DH            ;cuando esta en el ultima columna y toca 'd'
        INT 10h           ; aparece en la primera columna pero la fila anterior
        
        MOV AH,0
        INT 16h
        JMP DETECTAR_TECLA
            
primeraColumna:  ;cuando este en la columna 30 y se vaya hacia la derecha,
                    ;aparecera en la primera columasegunda fila
        ;Posicionar cursor
        MOV AH,02h
        MOV BH,00h
        MOV DL,limMin_X ; 0        
        ;INC DH          ;cuando esta en el ultima columna y toca 'd'
        INT 10h         ; aparece enl la primera columna pero la fila siguiente
        
        
        MOV AH,0
        INT 16h
        JMP DETECTAR_TECLA


RESPUESTA_INICIO:
            ; use this code for compatibility with dos/cmd prompt full screen mode: 
        MOV AX, 1003h
        MOV BX, 0   ; disable blinking. 
        INT 10h
        
        
        ;leo caracter de la pagina 0
        MOV AH,08h
        MOV BH,00h         
        INT 10h
        MOV letra, AL  ;Leo el caracter y lo guardo en letra
        
        ;Sobre-escribo el caracter con el anterior pero con color
        MOV AH,09H
        MOV AL,letra        ;Al presionar enter, cargo en esa
        MOV BH,10H          ;posicion el caracter
        MOV BL,00H    ;guardado en LETRa
        MOV CX,01H          ;con un fondo rojo
        INT 10H    
        
        
        MOV BH,2                      
        MOV estadoDelJuego,BH    
        
        
        JMP DETECTAR_TECLA    
        
        
RESPUESTA_FIN:
        CALL setLetraDelCursor ;Guarda en letra el caracter        
        putLetra 10H, 11H ;Sobrescribe el caracter con el anterior pero con color
        INT 10H    
        
        
        MOV BH,1                     
        MOV estadoDelJuego,BH    
        
        
        JMP DETECTAR_RESPUESTA ; Solo se detecta al seleccionar el final de la palabra
        
; Compara las posiciones del cursor en los enter con los valores en Soluciones
DETECTAR_RESPUESTA:
    CALL getCursorPosition
    MOV SI, idxPregunta    ; Puntero a indice de pregunta
    CMP DL, 0BH            ; TODO: Compara pos X con SolucionesX[idxPregunta]
    JE  RESPUESTA_CORRECTA
    JMP RESPUESTA_INCORRECTA

; Pasa a la siguiente pregunta. Sino hay mas preguntas salta a mostrar el resultado
SIGUIENTE_PREGUNTA:
    MOV AX,idxPregunta     ; Pasa a la siguiente pregunta
    INC AX
    MOV idxPregunta, AX
    ; TODO: Falta saltar a mostrar resultado cuando no hay mas preguntas
    JMP DETECTAR_TECLA

; Pinta de verde la respuesta correcta
RESPUESTA_CORRECTA:
    JMP SIGUIENTE_PREGUNTA
                                                
; Pinta de rojo la respuesta incorrecta
RESPUESTA_INCORRECTA:
    JMP SIGUIENTE_PREGUNTA


error:
    JMP fin    
    
;Final de 
fin:


    MOV AH,00H
    INT 21h
    RET

