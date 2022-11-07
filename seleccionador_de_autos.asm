global main
extern fopen
extern puts
extern printf
extern fopen
extern fclose
extern fread
extern sscanf
extern fwrite

section .data
    archivo_listado  db  "listado.dat", 0
    modo_lectura_listado    db  "rb", 0 
    mensaje_error_apertura_listado db  "Ha habido un error en la apertura del archivo listado", 0
    id_listado  dq 0

    archivo_seleccion  db  "seleccion.dat", 0
    modo_lectura_seleccion    db  "wb", 0 
    mensaje_error_apertura_seleccion db  "Ha habido un error en la apertura del archivo seleccion", 0
    id_seleccion dq 0

    registro_listado    times 0 db ""
        marca   times   10  db  ' '
        anio    times   4   db  ' '
        patente times   7   db  ' '
        precio  times   4   db  ' '    

    registro_seleccionado    times 0 db ""
        patente_seleccionado times   7   db  ' '
        precio_seleccionado  times   4   db  ' ' 

    vector_marcas    db  "Fiat      Ford      Chevrolet Peugeot   "  
    iterador_vector_marca dq 0 

    formato_anio db "%i", 0
    string_anio db "****"
    anio_num    dw 0

section .bss
    registro_valido     resb 1
    dato_valido         resb 1

section .text
main:
abrir_archivos: 
    mov rcx, archivo_listado    
    mov rdx, modo_lectura_listado  
    sub rsp, 32
    call fopen
    add rsp, 32

    cmp rax, 0  
    jle error_apertura_listado
    mov [id_listado], rax

    mov rcx, archivo_seleccion
    mov rdx, modo_lectura_seleccion
    sub rsp, 32
    call fopen
    add rsp, 32

    cmp rax, 0
    jle error_apertura_seleccion
    mov [id_seleccion], rax

leer_listado:
    mov rcx, registro_listado   
    mov rdx, 25         
    mov r8, 1           
    mov r9, [id_listado]  
    sub rsp, 32
    call fread
    add rsp, 32
    cmp rax, 0
    jle cerrar_archivo_seleccion

    call validar_registro_leido
    cmp  byte[registro_valido], 'N'
    je   leer_listado

    mov rcx, 7
    mov rsi, patente
    mov rdi, patente_seleccionado
    rep movsb

    mov rcx, 4
    mov rsi, precio
    mov rdi, precio_seleccionado
    rep movsb

    mov rcx, registro_seleccionado
    mov rdx, 11
    mov r8,  1
    mov r9, [id_seleccion]
    sub rsp, 32
    call fwrite
    add rsp, 32

    jmp leer_listado

error_apertura_listado:
    mov rcx, mensaje_error_apertura_listado
    sub rsp, 32
    call puts
    add rsp, 32
    jmp fin_programa

error_apertura_seleccion:
    mov rcx, mensaje_error_apertura_seleccion
    sub rsp, 32
    call puts
    add rsp, 32
    jmp cerrar_archivo_listado

cerrar_archivo_seleccion:
    mov rcx, [id_seleccion]
    sub rsp, 32
    call fclose
    add rsp, 32

cerrar_archivo_listado:
    mov rcx, [id_listado]
    sub rsp, 32
    call fclose
    add rsp, 32

fin_programa:
ret 

;---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

;SUBRUTINAS
;SETEA "REGISTRO_VALIDO" EN "S" EN CASO DE QUE SEA VALIDO O EN "N" EN CASO DE INVALIDO
validar_registro_leido:
    mov byte[registro_valido], 'N'

    call validar_marca
    cmp byte[dato_valido], 'N'
    je  fin_validacion

    call validar_anio
    cmp byte[dato_valido], 'N'
    je  fin_validacion

    call validar_precio
    cmp byte[dato_valido], 'N'
    je  fin_validacion

    mov byte[registro_valido], 'S'
fin_validacion:
ret


;VALIDACION DE MARCA: SETEA "DATO_VALIDO" EN N EN CASO DE MARCA INVALIDA O EN "S" EN CASO DE MARCA VALIDA
validar_marca:
    mov byte[dato_valido], 'S'
    mov rbx, 0  
    mov rcx, 4  

recorrer_vector_marcas:
    mov qword[iterador_vector_marca], rcx

    mov rcx, 10             
    lea rsi, [marca]
    lea	rdi,[vector_marcas + rbx]
    repe cmpsb
    je  fin_validacion_marca

    mov rcx, qword[iterador_vector_marca]
    add rbx, 10
    loop recorrer_vector_marcas

    mov byte[dato_valido], 'N'
fin_validacion_marca:
ret

;VALIDACION DE AÑO: SETEA "DATO_VALIDO" EN N EN CASO DE AÑO INVALIDO O EN "S" EN CASO CONTRARIO
validar_anio:
    mov byte[dato_valido], 'S'

    mov rcx, 4
    lea rsi, [anio]
    lea rdi, [string_anio]
    rep movsb

    mov rcx, string_anio
    mov rdx, formato_anio
    mov r8, anio_num
    sub rsp, 32
    call sscanf
    add rsp, 32

    cmp rax, 1
    jne anio_invalido

    mov rcx, 2020
    cmp cx, word[anio_num]
    jg anio_invalido

    mov rcx, 2022
    cmp cx, word[anio_num]
    jl anio_invalido

    jmp fin_validacion_anio
anio_invalido:
    mov byte[dato_valido], 'N'
    
fin_validacion_anio:
ret

;VALIDACION DE PRECIO: SETEA "DATO_VALIDO" EN "N" EN CASO DE PRECIO INVALIDO O EN "S" EN CASO CONTRARIO
validar_precio:
    mov byte[dato_valido], 'S'

    cmp	dword[precio], 5000000
    jg  precio_invalido
    jmp fin_validacion_precio

precio_invalido:
    mov byte[dato_valido], 'N'

fin_validacion_precio:
ret



