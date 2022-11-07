# Seleccionador de autos

; Dado un archivo en formato BINARIO que contiene informacion sobre autos llamado listado.dat
; donde cada REGISTRO del archivo representa informacion de un auto con los campos: 
;   marca:							10 caracteres
;   año de fabricacion:				4 caracteres
;   patente:						7 caracteres
;	  precio							4 bytes en bpf s/s
; El programa filtra los autos leidos del archivo cuya fecha de fabricacion este entre 2020 y 2022 inclusive y cuyo precio sea inferior a $5.000.000 y los escribe en un ; otro archivo "listado.dat".
; El programa validara que los siguientes datos se cumplan en cada registro (caso contrario el registro sera descartado):
;   Marca (que sea Fiat, Ford, Chevrolet o Peugeot)
;   Año (que sea un valor numérico y que cumpla la condicion indicada del rango) 
;   Precio que cumpla con el limite indicado.
