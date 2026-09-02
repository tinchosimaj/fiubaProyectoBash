#!/bin/bash
ARCHIVO="alumnos.txt"

numero=""
echo "1) Crear entorno"
echo "2) Correr proceso de consolidar"
echo "3) Listado de alumnos por orden de padrón"
echo "4) Visualizar las 10 notas más altas"
echo "5) Solicitar datos por padrón"
echo "6) Visualizar logs"
echo "7) Salir"


until [ "$numero" = '7' ]; do

echo -n "Ingrese un número: "

read numero

case "$numero" in
	1) echo "Elegiste la opción 1"
		mkdir $HOME/EPNro1
		touch $HOME/EPNro1/entrada
		touch $HOME/EPNro1/salida
		touch $HOME/EPNro1/procesado;;
	2) echo "Elegiste la opción 2";;
    3) 
            if [ -f "$ARCHIVO" ]; then
                sort -n "$ARCHIVO"
            else
                echo "Error: El archivo de salida '$ARCHIVO' no existe."
            fi
            ;;
	4) echo "Elegiste la opción 4";;
	5) echo "Elegiste la opción 5";;
	6) echo "Elegiste la opción 6";;
	7) echo "Saliendo del menú" ;;

    *)
    echo "Opción inválida. Ingrese un número del 1 al 7.";;
    esac
done

echo "Se termino proceso, saliendo."
