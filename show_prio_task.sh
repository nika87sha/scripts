#!/bin/bash
TODO_BASE="$HOME/notes/todos"
YEAR=$(date +%Y)
MONTH=$(date +%m)
DAY=$(date +%Y-%m-%d)
TODO_FILE="$TODO_BASE/$YEAR/$MONTH/$DAY.md"

if [[ ! -f "$TODO_FILE" ]]; then
    echo "⚠️ No existe archivo TODO para hoy: $TODO_FILE"
    exit 0
fi

# Extraer bloque completo de "Prioridades Urgentes"
BLOCK=$(sed -n '/Prioridades Urgentes/,/^##/p' "$TODO_FILE" | sed '$d')

case "$1" in
    bar) # modo compacto (para tmux status bar)
        echo "$BLOCK" | grep "\- \[ \]" | head -n 1 | cut -c5-
        ;;
    all) # mostrar todo el bloque con cowsay (para zsh)
        if [[ -n "$BLOCK" ]]; then
            echo "🔥 Prioridades del día:"
            echo "$BLOCK" | cowsay
        else
            echo "✨ No hay prioridades urgentes definidas ✨"
        fi
        ;;
    notify) # notificación de pomodoro
        TASK=$(echo "$BLOCK" | grep "\- \[ \]" | head -n 1 | cut -c5-)
        if [[ -n "$TASK" ]]; then
            notify-send "⏳ Pomodoro terminado" "🔥 Prioridad: $TASK"
        fi
        ;;
    *)
        echo "Uso: $0 {bar|all|notify}"
        ;;
esac

