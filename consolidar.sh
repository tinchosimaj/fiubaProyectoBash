#!/bin/bash

BASE="$HOME/EPNro1"
ENTRADA="$BASE/entrada"
SALIDA="$BASE/salida"
PROCESADO="$BASE/procesado"
LOG="$BASE/procesado.log"

while true; do
  for archivo in "$ENTRADA"/*.txt; do
    [ -e "$archivo" ] || continue
    nombre_archivo=$(basename "$archivo")
    cat "$archivo" >> "$SALIDA/$FILENAME.txt"
    mv "$archivo" "$PROCESADO/"
    echo "$(date '+%d/%m/%Y %H:%M:%S') - Procesado archivo $nombre_archivo" >> "$LOG"
  done
  sleep 10
done