;   Trabajo Práctico Sopa de letras
;   Integrantes:
;               Vargas,     Ignacio
;               Paez,       Roberto
;               Saczkowski, Mariano

name "SopaDeLetras"

ORG 100h

JMP INICIO_JUEGO


;Definicion de bytes y palabras
    ;Limite de pantalla
    
    ;OK EMU8086
        ;Limites en X
    limMin_X    EQU  1         ;pos 0 de matriz mas uno de pared
    limMax_X    EQU  20        ;pos 1 pared y pos 21 de pared. limMin_X + 19
        ;Limites en Y
    limMin_Y    EQU  4         ;pos 4 de menu mas 0 de comienzo de matriz
    limMax_Y    EQU  18        ;pos 4 de menu mas 14 del alto de la matriz. limMin_Y + 14
    
    txtJugador DB "Jugador: ", '$'
    
    txtInfo    DB "Para moverse por la sopa usar las teclas", 13, 10
               DB " W", 13, 10
               DB "ASD", 13, 10, 13, 10, 13, 10
               DB "Ranking:", 13, 10
               DB "Aciertos", 9, "Jugador", 13, 10, '$'

    menu		DB "           ######   #######  ########     ###            " ,10,13
                DB "          ##    ## ##     ## ##     ##   ## ##           " ,10,13
                DB "          ##       ##     ## ##     ##  ##   ##          " ,10,13
                DB "           ######  ##     ## ########  ##     ##         " ,10,13
                DB "                ## ##     ## ##        #########         " ,10,13
                DB "          ##    ## ##     ## ##        ##     ##         " ,10,13
                DB "           ######   #######  ##        ##     ##         " ,10,13
 ;               DB "                                                         " ,10,13
                DB "                   ########  ########                    " ,10,13
                DB "                   ##     ## ##                          " ,10,13
                DB "                   ##     ## ##                          " ,10,13
                DB "                   ##     ## ######                      " ,10,13
                DB "                   ##     ## ##                          " ,10,13
                DB "                   ##     ## ##                          " ,10,13
                DB "                   ########  ########                    " ,10,13
;                DB "                                                         " ,10,13
                DB " ##       ######## ######## ########     ###     ######  " ,10,13
                DB " ##       ##          ##    ##     ##   ## ##   ##    ## " ,10,13
                DB " ##       ##          ##    ##     ##  ##   ##  ##       " ,10,13
                DB " ##       ######      ##    ########  ##     ##  ######  " ,10,13
                DB " ##       ##          ##    ##   ##   #########       ## " ,10,13
                DB " ##       ##          ##    ##    ##  ##     ## ##    ## " ,10,13
                DB " ######## ########    ##    ##     ## ##     ##  ######  " ,10,13
				DB "---------------------------------------------------------" ,10,13
				DB "  Presione Enter para continuar o I para informacion...  " ,'$'
				
				

     info        DB  "ACA VA LA INFO",'$'
    
    final_texto DB "RESPUESTAS CORRECTAS         ",'$'

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
    referencias DB    " :Correcto;  :Incorrecta;  :Pregunta actual",'$' 

    ; Las posiciones de las soluciones tomando como base limM??_?
    ; Entonces primera posicion comienza en 0, porque DL (4) - limMin_X(4) = 0
    solucionesX  DB 11 + limMin_X, 01 + limMin_X, 05 + limMin_X, 00 + limMin_X, 09 + limMin_X, 01 + limMin_X, 10 + limMin_X, 02 + limMin_X, 00 + limMin_X, 12 + limMin_X
    solucionesY  DB 00 + limMin_Y, 01 + limMin_Y, 03 + limMin_Y, 05 + limMin_Y, 06 + limMin_Y, 08 + limMin_Y, 09 + limMin_Y, 11 + limMin_Y, 13 + limMin_Y, 14 + limMin_Y
    solucionesFinX  DB 11 + 8 + limMin_X, 01 + 6 + limMin_X, 05 + 10 + limMin_X, 00 + 3 + limMin_X, 09 + 6 + limMin_X, 01 + 6 + limMin_X, 10 + 7 + limMin_X, 02 + 11 + limMin_X, 00 + 4 + limMin_X, 12 + 3 + limMin_X
    solucionesFinY  DB 00 + limMin_Y, 01 + limMin_Y, 03 + limMin_Y, 05 + limMin_Y, 06 + limMin_Y, 08 + limMin_Y, 09 + limMin_Y, 11 + limMin_Y, 13 + limMin_Y, 14 + limMin_Y

    ; Posicion inicial de las preguntas
    posPreguntasX DB limMax_X + 2    ; Son dos por la pared
    posPreguntasY DB limMin_Y + 2    ; Son dos por los renglones en blanco
    
    
	;Seccion manejo de archivos
	
	archivo     DB "sopa.txt" , 0   ;Ubicacion del archivo a utilizar
	archivoRanking DB "ranking.txt", 0 ; Ubicacion archivo de ranking
    ;archivo2    DB "c:\tp\preguntas2.txt" , 0  ;Ubicacion del archivo a utilizar
    ID_Archivo  DW  ? ;HANDLE de archivo
    
    ;Respuestas a leer
    ;COMPUERTA%HARVARD%COMPUTADORA%CISC%MENTIRA%BINARIO%PIPELINE%ARQUITECTURA%ASCII%RISC$-   85 caracteres
    bytesRta    DW	0FFFFh
    rtaLeidas   DB  600 dup ('$')
    ranking   DB  600 dup ('$')
    ;Inicio errores
    
    msgErrorApertura    DB  10,13,"Se produjo un error al intentar ABRIR el archivo",'$'
    msgErrorLectura     DB  10,13,"Se produjo un error al intentar LEER el archivo (respuestas)",'$'
    
    ;Fin errores
    ;Fin Seccion manejo de archivos
          
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
    
    time  DB ?
    resto DB 26
	letra DB ?
	copia DB ?
	jugador DB 20 DUP('$')
	jugadorCaracteres DW 0
	colorFondo DB 0 ; Color para pintar letras       
	estadoDelJuego DB 0 ; estado 0 es juego no inicio, estado 1 es juegoIniciado Sin letra seleccionada, estado 2 es juegoIniciado con palabra Seleccionada.
    inicioX DB 0    ; Posicion X inicio de palabra
    inicioY DB 0    ; Posicion Y inicio de palabra
    finX    DB 0    ; Posicion X final de palabra
    idxPregunta DB 0 ; Empieza en la pregunta 1, indice 0 (obvio)
    respuestasOk DB 0  ; Respuestas que contesta correctamente
	cantidadDePreguntas DB 10
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
                    
; Guarda en AH la posicion Y
getPosicionPreguntaY MACRO
    MOV AH, posPreguntasY  ; Poscion Y pregunta actual
    ADD AH, idxPregunta
ENDM


;Escribe letra en color
putLetra MACRO color
    MOV AH,09H
    MOV AL,letra     ;AL misma letra. Tal vez se pueda omitir esta instruccion
    MOV BH,0
    MOV BL, color          ;Color BIOS BH y BL. Rojo 0100, Verde 0010, amarillo 1110
    MOV CX,01H          ;Un solo caracter repetido
    INT 10H    
ENDM

colorPregunta MACRO color
    getPosicionPreguntaY    ; En AH la posicion Y
    setCursor posPreguntasX, AH
    CALL setLetraDelCursor   ;Guarda en letra el caracter
    putLetra color
ENDM


;Fin de macros
;¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
;-------------------------Definicion de procedimientos----------------------
;___________________________________________________________________________  
; Solicita el nombre hasta ingresar una letra fuera del rango a-z
; Ojo son minusculas
leerNombre PROC
  leerNombreJMP:
    MOV AH,01h
    INT 21h
    CMP AL, 97          ;Letra a
    JB leerNombreFin
    CMP AL, 122          ;Letra z
    JA leerNombreFin
  agregarLetraNombre:   ; Entre a y z
    LEA SI, jugador
    ADD SI, jugadorCaracteres
    MOV [SI], AL 
    INC jugadorCaracteres
    JMP leerNombreJMP
  leerNombreFin:
    RET
ENDP

clearScreen PROC 
        mov AH, 6H 
        mov AL, 0    
        mov BH, 7         ;clear screen 
        mov CX, 0
        mov DL, 79
        mov DH, 24
        int 10H
        setCursor 0, 0   
        RET
ENDP
    
pintarPalabra PROC
    MOV CL, idxPregunta
    MOV CH, 0
    MOV SI, CX
    MOV CL, solucionesFinX[SI]
    MOV finX, CL
    setCursor solucionesX[SI], solucionesY[SI]
    pintarLetraPalabra:    
        CALL setLetraDelCursor   ;Guarda en letra el caracter
        putLetra colorFondo
        CALL getCursorPosition  ; DL es posicion X
        INC DL
        setCursor DL, DH
        CMP DL, finX
        JNA pintarLetraPalabra
    RET
ENDP

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
    ;MOV AH,0  
    ;INT 16h
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
        INC SI
        MOV CH, pantalla[SI]                                  ;
        CMP CH,'&'                    ;
        JE  VERIFICAR                           ;
        
        CMP CH,'r'                    ;
        JE GENERAR_LETRA                        ;
        
        CMP CH,'p'
        JE VERIFICAR
                
        CMP CH,'$'                    ;
        JNE bucle                               ;
    RET
ENDP

;Fin  de procedimientos


;------------------------------SALTOS------------------------------
GENERAR_LETRA:
;genera las letras que van en la matriz haciendo un calculo
	    ;XOR AX,AX
	    ;ADD CL, copia
	    ;MOV copia, CL
	    MOV AH,2ch                   	 
	    INT 21h                 	;inicializa el reloj
	    ;ADD DL,26               	;
	    ;MOV time, DL               	;guarda las centesimas del reloj  
	    MOV AL, DL
	    ADD AL, copia
	    MOV copia, AL
	    XOR AH,AH               	;reiniciamos ah
	    DIV resto               	;dividimos el nro de la centesimas x 26 y obtengo el esto                    	 
	    
	    ADD AH,65               	;se le suma 65 a ah
        
        ;MOV AH,'0'
	    MOV pantalla[SI], AH
	    JMP bucle           

incPosBp:
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
    CALL clearScreen
    CALL limpiarRegistros   
    
    abrirArchivo archivo                    ;abrirArchivo recibe la ubicaion del archivo - 
                                            ;lo abre y retorna su id en ID_Archivo
    leerRta ID_Archivo,bytesRta,rtaLeidas   ;leerRta recibe el id del archivo y los bytes a leer - 
                                            ;lo lee y retorna esa seccion en rtaLeidas
    cerrarArchivo ID_Archivo                ;cerrarArchivos recibe el id del archivo y lo cierra

    abrirArchivo archivoRanking                    ;abrirArchivo recibe la ubicaion del archivo - 
                                            ;lo abre y retorna su id en ID_Archivo
    leerRta ID_Archivo,bytesRta,ranking   ;leerRta recibe el id del archivo y los bytes a leer - 
                                            ;lo lee y retorna esa seccion en rtaLeidas
    cerrarArchivo ID_Archivo                ;cerrarArchivos recibe el id del archivo y lo cierra
    
    CALL limpiarRegistros                   ;
    
    CALL cargarPantalla  
	print menu

	MOV BH,0
	MOV estadoDelJuego,BH   
    CALL iniciarCursor 
	JMP DETECTAR_TECLA
	 
		 
INICIO_SOPA:
    CALL clearScreen
    setCursor 0, 0
    print pantalla
    setCursor 5, 22
    print txtJugador
    CALL leerNombre      ; Guarda en variable nombre
    setCursor 24,5 
    print referencias 
    setCursor 24,5
    putLetra 10100000b ; Seteamos putLetra en Verde;
    setCursor 36,5
    putLetra 01000000b ; Seteamos putLetra en Rojo;
    setCursor 50,5
    putLetra 11100000b ; Seteamos putLetra en Amarillo; 
    setCursor posInicialCursor_X,posInicialCursor_Y
    
    MOV BH,1
	MOV estadoDelJuego,BH              
                  
		
		
		

INICIALIZAR_CURSOR:        
    setCursor posPreguntasX, posPreguntasY  ; Color amarillo pregunta actual
    CALL setLetraDelCursor   ;Guarda en letra el caracter
    putLetra 11100000b ;Sobrescribe el caracter con el anterior pero con color amarillo
    ;inicializo el cursor para que quede en espera de una tecla.
    CALL iniciarCursor 
    JMP DETECTAR_TECLA


    

DETECTAR_TECLA:  ;cuando aprete (a,s,d,w) le da la direccion al cursor para donde tiene que ir    
        MOV AH,0
        INT 16h
        CMP AL,'w'
        JE MOVER_ARRIBA        
        CMP AL,'s'
        JE MOVER_ABAJO        
        CMP AL,'a'
        JE MOVER_IZQUIERDA        
        CMP AL,'d'
        JE MOVER_DERECHA
                
        CMP AL,13               ;SI TOCA ENTER elige la  letra   
        JE EVALUAR_ENTER  
        
        
        
        ;CMP AL,27
        ;JE RESPUESTA_FIN
        
        CMP AL,'i'
        JE MOSTRAR_NFORMACION
        CMP AL,'I'
        JE MOSTRAR_NFORMACION
        CMP AL,'q'
        JE fin
        JNE DETECTAR_TECLA
            
            
            
        
MOVER_DERECHA: ;mueve el cursor hacia derecha 1 pos
        
        CMP DL,limMax_X             ;Esta en la ultima columna? si
        JE primeraColumna           ; si estoy en la columna 19 y toco tecla voy a la 0
        INC DL
        MOV BH,0
        MOV AH,2        
        INT 10h
        ;MOV AH,0
        ;INT 16h  
        JMP DETECTAR_TECLA        
                              
MOVER_ARRIBA:  ;mueve el cursor hacia arriba 1 pos
        CMP DH,limMin_Y     ;0 Esta en la primera fila? si
        JE  ultimaFila   ;  Cuando esta en la primer fila y toca tecla va a la ultima
        DEC DH
        MOV BH,0
        MOV AH,2        
        INT 10h
        ;MOV AH,0
        ;INT 16h
        JMP DETECTAR_TECLA
        
MOVER_ABAJO:  ;mueve el cursor hacia abajo 1 pos 
        CMP DH,limMax_Y       ; Esta en la ultima fila? si
        JE primeraFila        ; toca tecla va a la primera
        INC DH
        MOV BH,0
        MOV AH,2        
        INT 10h
        ;MOV AH,0
        ;INT 16h
        JMP DETECTAR_TECLA
             

                        
MOVER_IZQUIERDA: ;mueve el cursor hacia izquierda 1 pos
        CMP DL,limMin_X         ;Esta en la primera columna? si
        JE ultimaCulumna        ;toco izq y voy a la ultima 
        DEC DL
        MOV AH,2        
        MOV BH,0
        INT 10h
        ;MOV AH,0
        ;INT 16h
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
        
        ;MOV AH,0
        ;INT 16h
        JMP DETECTAR_TECLA
                      
primeraFila:  ;cuando este en la fila 10 y se vaya hacia arriba,
        ;aparecera de en la fila mas alta
        MOV AH,2
        MOV BH,0
        MOV DH,limMin_Y        ;0
        INT 10h
        
        ;MOV AH,0
        ;INT 16h
        JMP DETECTAR_TECLA
                      
ultimaCulumna: ;cuando este en la columna 0 y se vaya hacia la derecha,
           ;aparecera en la ultima columna
        
        MOV AH,2
        MOV BH,0        
        MOV DL,limMax_X   ;cantidad de columnas menos uno por empezar en cero  19
        ;DEC DH            ;cuando esta en el ultima columna y toca 'd'
        INT 10h           ; aparece en la primera columna pero la fila anterior
        
        ;MOV AH,0
        ;INT 16h
        JMP DETECTAR_TECLA
            
primeraColumna:  ;cuando este en la columna 30 y se vaya hacia la derecha,
                    ;aparecera en la primera columasegunda fila
        ;Posicionar cursor
        MOV AH,02h
        MOV BH,00h
        MOV DL,limMin_X ; 0        
        ;INC DH          ;cuando esta en el ultima columna y toca 'd'
        INT 10h         ; aparece enl la primera columna pero la fila siguiente
        
        
        ;MOV AH,0
        ;INT 16h
        JMP DETECTAR_TECLA


RESPUESTA_INICIO:
    CALL setLetraDelCursor ;Guarda en letra el caracter
    CALL getCursorPosition
    MOV inicioX, DL     ; Guarda posicion X de inicio de palabra
    MOV inicioY, DH     ; Guarda posicion Y de inicio de palabra
    putLetra 10010000b ;Sobrescribe el caracter con el anterior pero con color       
    MOV BH,2                      
    MOV estadoDelJuego,BH
    JMP DETECTAR_TECLA    
        
        
RESPUESTA_FIN:
    CALL setLetraDelCursor ;Guarda en letra el caracter        
    putLetra 10110000b ;Sobrescribe el caracter con el anterior pero con color        
    MOV BH,1                     
    MOV estadoDelJuego,BH
    JMP DETECTAR_RESPUESTA ; Solo se detecta al seleccionar el final de la palabra
        
; Compara las posiciones del cursor en los enter con los valores en Soluciones
DETECTAR_RESPUESTA:
    MOV AL, idxPregunta     ; Puntero a indice de pregunta
    XOR AH, AH
    MOV SI, AX
    MOV AL, inicioX
    CMP AL, solucionesX[SI] ; Compara inicioX con SolucionesX[idxPregunta]
    JNE RESPUESTA_INCORRECTA
    MOV AL, inicioY
    CMP AL, solucionesY[SI] ; Compara inicioY con SolucionesY[idxPregunta]
    JNE RESPUESTA_INCORRECTA
    CALL getCursorPosition  ; Guarda en DL y DH la posicion del cursor
    CMP DL, solucionesFinX[SI] ; Compara pos X con SolucionesFinX[idxPregunta]
    JNE RESPUESTA_INCORRECTA
    CMP DH, solucionesFinY[SI] ; Compara pos Y con SolucionesFinY[idxPregunta]
    JNE RESPUESTA_INCORRECTA
    JMP RESPUESTA_CORRECTA      ; Solo llega a la respuesta correcta si paso todas las validaciones

; Pinta de verde la respuesta correcta
RESPUESTA_CORRECTA:
    MOV colorFondo, 10100000b
    CALL pintarPalabra ; Pinta la palabra de Verde       
    INC respuestasOk            ; Incrementa las respuestas correctas 
    colorPregunta 10100000b ; Sobrescribe el caracter con el anterior pero con color verde
    JMP SIGUIENTE_PREGUNTA
                                                
; Pinta de rojo la respuesta incorrecta
RESPUESTA_INCORRECTA:
    MOV colorFondo, 01000000b
    CALL pintarPalabra ; Pinta la palabra de rojo
    colorPregunta 01000000b ; Sobrescribe el caracter con el anterior pero con color rojo
    JMP SIGUIENTE_PREGUNTA
               
; Pasa a la siguiente pregunta. Sino hay mas preguntas salta a mostrar el resultado
SIGUIENTE_PREGUNTA:
    MOV AH,idxPregunta     ; Pasa a la siguiente pregunta
    INC AH
    CMP AH, cantidadDePreguntas              ; Se acabaron las preguntas
    JE  FIN_SOPA
    MOV idxPregunta, AH
    getPosicionPreguntaY    ; En AH la posicion Y
    setCursor posPreguntasX, AH
    CALL setLetraDelCursor   ;Guarda en letra el caracter
    putLetra 11100000b ;Sobrescribe el caracter con el anterior pero con color amarillo
    setCursor limMin_X, limMin_Y
    JMP DETECTAR_TECLA

; Muestra informacion y ranking solo antes de comenzar el juego
MOSTRAR_NFORMACION:
    MOV BH,estadoDelJuego
    CMP BH,0  ;Revisa si ya se inicio el juego.
    JNE DETECTAR_TECLA
    CALL clearScreen
    print txtInfo
    JMP DETECTAR_TECLA

error:
    JMP fin    

FIN_SOPA: 
    setCursor 2, 24
    MOV AL, 48
    MOV AH, respuestasOk
    CMP AH, 10
    JB DIGITOUNIDAD
    MOV AL, 49
    mov AH,0
    DIGITOUNIDAD:
    ADD AH, 48
    MOV SI, 22
    MOV final_texto[SI], AL
    INC SI
    MOV final_texto[SI], AH
    print final_texto
    CALL iniciarCursor
    ;Presione una tecla para salir
    MOV AH,0                
    INT 16h
    
    JMP fin
    

;Final de 
fin:
    CALL clearScreen
    MOV AH,00H
    INT 21h
    RET