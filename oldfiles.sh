#!/bin/bash
#title          oldfiles.sh
#description    Mueve archivos antiguos a otro directorio
#author         Verónica Durán
#date           20240412
#version        0.1
#============================================================================


OLD_DAYS="30" # Número de días para considerar un archivo como antiguo
SOURCE="/ruta/origen" # Ruta de la carpeta de origen
NDIR="/ruta/destino" # Ruta de la carpeta de destino

# Comprueba si la carpeta de destino existe, si no existe la creara
if [ ! -d "$NDIR" ]; then
    echo "El directorio de destino no existe, creando..."
    mkdir -p "$NDIR"
fi

# Busca los archivos más antiguos en la carpeta de origen y los mueve a la carpeta destino
find "$SOURCE" -type f -mtime +$OLD_DAYS -exec mv -t "$NDIR" {} +

echo "Proceso finalizado" | mail -s "Proceso finalizado" monitor@example.cat

