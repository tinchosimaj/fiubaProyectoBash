#!/bin/bash

if [[ -z "$FILENAME" ]]; then
    echo "Error: la variable de entorno FILENAME no esta definida."
else
    archivo_5="salida/$FILENAME.txt"
    if [[ ! -f "$archivo_5" ]]; then
        echo "Error: El archivo '$archivo_5' no existe."
    else
        echo -n "Ingrese el numero de padron: "
        read padron

        encontrado=0

        while read -r linea
        do
            p_numero=$(echo "$linea" | grep -oE '^[0-9]+')
            email=$(echo "$linea" | grep -oE '[^ ]+@[^ ]+')
            nota=$(echo "$linea" | grep -oE '[0-9]+$')
            nombre=$(echo "$linea" | sed -E "s/^[0-9]+ //" | sed "s/ $email//" | sed -E "s/ [0-9]+$//")

            if [[ "$p_numero" == "$padron" ]]; then
                echo "Padron: $p_numero"
                echo "Nombre y Apellido: $nombre"
                echo "Email: $email"
                echo "Nota: $nota"
                encontrado=1
            fi
        done < "$archivo_5"

        if [[ "$encontrado" -eq 0 ]]; then
            echo "No se encontro ningun alumno con ese padron"
        fi
    fi
fi

