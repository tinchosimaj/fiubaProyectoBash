#!/bin/bash
ARCHIVO="alumnos.txt"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


# Al ejecutar "bash interfaz.sh d":
if [ "$1" = 'd' ]; then
  #Caso 1: Directorio vacío + consolidar.sh inactivo
  if [ $(ls $HOME/EPNro1 | wc -l) -eq 0 ]; then
    echo "No se encontraron archivos por eliminar o finalizar"
    exit
  else
    #Caso 2: Existe al menos 1 archivo en directorio + consolidar.sh en ejecución
    if pgrep -f "consolidar.sh" > /dev/null; then
      echo "Borrando contenidos dentro de EPNro1 y terminando procesos"
      killall "consolidar.sh"
      rm -r -f "$HOME/EPNro1"
      mkdir "$HOME/EPNro1"
      exit
    else 
      #Caso 3: Existe al menos 1 archivo en directorio + consolidar.sh inactivo
      echo "Borrando contenidos dentro de EPNro1"
      rm -r -f "$HOME/EPNro1"
      mkdir "$HOME/EPNro1"
      exit
    fi
  fi  
fi

correr_proceso() {
  local identificadorDelProceso="$HOME/EPNro1/.consolidar.pid"
  local rutaDelScript="$HOME/EPNro1/consolidar.sh"

  if [ ! -d "$HOME/EPNro1" ]; then
    echo "Primero tenés que crear el entorno (opción 1)."
    return
  fi

  if [ ! -f "$rutaDelScript" ]; then
    echo "No se encontró consolidar.sh en EPNro1. Volvé a ejecutar la opción 1."
    return
  fi

  if [ -z "$FILENAME" ]; then
    echo "La variable de entorno FILENAME no está definida."
    return
  fi

  if [ -f "$identificadorDelProceso" ]; then
    pid_guardado=$(cat "$identificadorDelProceso")
    if kill -0 "$identificadorDelProceso_guardado" 2>/dev/null; then
      echo "El proceso ya está corriendo (PID $identificadorDelProceso_guardado)."
      return
    fi
  fi

  export FILENAME
  chmod +x "$rutaDelScript"
  nohup "$rutaDelScript" >/dev/null 2>&1 &
  echo $! > "$identificadorDelProceso"

  echo "Proceso lanzado en background (PID $!)."
}

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
    1)
      mkdir -p "$HOME/EPNro1/entrada" "$HOME/EPNro1/salida" "$HOME/EPNro1/procesado" 
      cp "$SCRIPT_DIR/consolidar.sh" "$HOME/EPNro1/consolidar.sh"
      chmod +x "$HOME/EPNro1/consolidar.sh"
      echo "Entorno creado en $HOME/EPNro1"
      ;;
    2) correr_proceso ;;
    3)
      if [ -z "$FILENAME" ]; then
        echo "La variable de entorno FILENAME no está definida."
      else
        ARCHIVO="$HOME/EPNro1/salida/$FILENAME.txt"
        if [ -f "$ARCHIVO" ]; then
          sort -n -k1,1 "$ARCHIVO"
        else
          echo "Error: El archivo de salida '$ARCHIVO' no existe."
        fi
      fi
      ;;
    4)
      if [ -z "$FILENAME" ]; then
        echo "La variable de entorno FILENAME no está definida."
      else
        ARCHIVO="$HOME/EPNro1/salida/$FILENAME.txt"
        if [ -f "$ARCHIVO" ]; then
          awk '{print $NF"\t"$0}' "$ARCHIVO" | sort -n -k1,1 -r | cut -f2- | head -n 10
        else
          echo "Error: El archivo de salida '$ARCHIVO' no existe."
        fi
      fi
      ;;
    5) 
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
fi;;



    6) echo "Elegiste la opción 6" ;;
      cat $HOME/EPNro1/procesado.log
    7) echo "Saliendo del menú" ;;
    *) echo "Opción inválida. Ingrese un número del 1 al 7." ;;
  esac
done

echo "Se termino proceso, saliendo."
