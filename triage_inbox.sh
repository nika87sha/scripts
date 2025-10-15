#!/usr/bin/env bash
# ~/scripts/triage_inbox.sh

TDO_CMD="$HOME/.local/bin/tdo" # Ajusta la ruta a tu script tdo
NOTES_DIR="$HOME/notes" # Ajusta la ruta a tu carpeta de notas

INBOX_DIR="$NOTES_DIR/0-inbox"
AREAS_DIR="$NOTES_DIR/2-areas"
RESOURCES_DIR="$NOTES_DIR/3-recursos"
ARCHIVE_DIR="$NOTES_DIR/4-archivo"

# 1. Selecciona la nota a procesar usando fzf
NOTE_PATH=$(find "$INBOX_DIR" -maxdepth 1 -type f -name "*.md" | fzf --prompt="📥 Selecciona nota para Triage: " --reverse --no-sort)

if [ -z "$NOTE_PATH" ]; then
    notify-send "✅ Triage OK" "Bandeja de entrada despejada o cancelada."
    exit 0
fi

# 2. Abre el editor para refinar la nota (opcional, usa tu editor por defecto)
$EDITOR "$NOTE_PATH"

# 3. Pregunta al usuario dónde moverla usando fzf (incluye subcarpetas de 2-areas)
# Opciones base
DEST_OPTIONS=$(echo -e "3-recursos\n4-archivo")

# Opciones de 2-areas: Añadir todas las subcarpetas de 2-areas (máximo 1 nivel)
AREA_OPTIONS=$(find "$AREAS_DIR" -maxdepth 1 -mindepth 1 -type d -printf "2-areas/%f\n")

# Combina las opciones
ALL_OPTIONS=$(echo -e "$AREA_OPTIONS\n$DEST_OPTIONS")

DEST=$(echo -e "$ALL_OPTIONS" | fzf --prompt="➡️ ¿Mover a?: " --reverse --no-sort)

if [[ "$DEST" == "2-areas/"* ]]; then
    # Si la opción empieza con 2-areas/, usa la ruta completa
    DEST_DIR="$NOTES_DIR/$DEST" 
elif [ "$DEST" == "3-recursos" ]; then
    DEST_DIR="$RESOURCES_DIR"
elif [ "$DEST" == "4-archivo" ]; then
    DEST_DIR="$ARCHIVE_DIR"
else
    notify-send "❌ Triage Cancelado" "Movimiento omitido." && exit 1
fi

# 4. Mueve la nota
mv "$NOTE_PATH" "$DEST_DIR/"

notify-send "📂 Movido" "$(basename "$NOTE_PATH") movido a $(basename "$DEST_DIR")"
