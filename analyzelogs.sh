#!/bin/bash

# -- Sección 1: Configuración de Variables --

# LOG_DIRECTORY: Define la ruta completa (absoluta) al directorio donde se encuentran tus archivos de registro
LOG_DIRECTORY="/var/logs"

# ERROR_PATTERNS: Este es un "array" o lista de palabras clave (patrones) que el script buscará

ERROR_PATTERNS=(
	"ERROR"
	"FATAL"
	"CRITICAL"
	"EXCEPTION"
	"TIMEOUT"
)

# -- Sección 2: Mensajes iniciales e identificación de archivos recientes --
echo "Analizando archivos de registro"
echo "-------------------------------" # Separador visual

# Muestra un encabezado claro para la lista de archivos que se van a procesar
# El flag "-e" en "echo" es importante porque permite que se interpreten secuencias de escape "\n"
# \n inserta un salto de linea, haciendo la salida mas ordenada

echo -e "\nLista de archivos de registro actualizados en las últimas 24h"
