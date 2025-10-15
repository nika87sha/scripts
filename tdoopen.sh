#!/usr/bin/env bash

# --- CONFIGURACIÓN ---
TDO="$HOME/.local/bin/tdo"
NOTES_DIR="$HOME/notes"
SESSION="Work"
WINDOW="rofi-tdo"

# Exportamos las variables CRÍTICAS para que Tmux y tdo las vean.
export NOTES_DIR
export NEXT_ACTION_FILE="$NOTES_DIR/todos/.next_action"
export ACTIVE_TODOS_FILE="$NOTES_DIR/todos/todo_ACTIVO.md"

TRIAGE_SCRIPT="$HOME/.local/bin/scripts/triage_inbox.sh"
PANIC_SCRIPT="$HOME/.local/bin/scripts/panic_button.sh"
# ---

## FUNCIONES DE SOPORTE

# run_in_work_tmux: Ejecuta un comando en la sesión Work de Tmux
run_in_work_tmux() {
    local CMD="$1"

    # Si no existe la sesión Work, crearla
    tmux has-session -t "$SESSION" 2>/dev/null || tmux new-session -d -s "$SESSION" -n main

    # Si la ventana rofi-tdo no existe, crearla
    tmux list-windows -t "$SESSION" | grep -q "$WINDOW" || tmux new-window -t "$SESSION" -n "$WINDOW"

    # Enviar el comando al panel
    tmux send-keys -t "$SESSION:$WINDOW" "clear && cd $NOTES_DIR && $CMD" C-m

    # Si estás fuera de tmux, adjúntate a la sesión Work
    if [ -z "$TMUX" ]; then
        tmux attach -t "$SESSION"
    else
        # Si ya estás dentro, simplemente enfoca esa ventana
        tmux select-window -t "$SESSION:$WINDOW"
    fi
}

# commit_and_push: Ejecuta add, commit (usando tdo) y push
commit_and_push() {
    local NOTES_ROOT="$NOTES_DIR" 

    if [ -d "$NOTES_ROOT/.git" ]; then
        # Enviamos los comandos a la ventana de Tmux para visualización
        tmux send-keys -t "$SESSION:$WINDOW" "clear" C-m
        tmux send-keys -t "$SESSION:$WINDOW" "echo 'Sincronizando notas con Git...'" C-m
        
        # 1. Ejecutar el commit del script tdo (solo hace add/commit)
        # Usamos TDO c que ya tiene la lógica de timestamp.
        tmux send-keys -t "$SESSION:$WINDOW" "$TDO c" C-m
        
        # 2. Navegar al directorio y hacer el push
        tmux send-keys -t "$SESSION:$WINDOW" "cd $NOTES_ROOT && git push" C-m
        
        # Enfocar la ventana de Tmux para ver el resultado del push
        tmux select-window -t "$SESSION:$WINDOW"
        notify-send "✅ Git Synced" "Notas guardadas y subidas a GitHub."
    else
        notify-send -u critical "❌ Error Git" "El directorio $NOTES_ROOT no es un repositorio Git."
    fi
}

# ---
## LÓGICA DE INTERFAZ (ROFI)
# ---

select_tdo_action() {
    ACTION_CODE_TEXT=$(echo -e "🎯  Foco/Pomodoro\nnew_t | ➕  Crear nueva tarea (TD)\nlist_t | ✅  Ver tareas pendientes\nnew_note | 📝  Crear Nota Estructurada\ndraft | 💡  Volcado Rápido (Inbox)\ne | 📅  Entrada diaria\ntriage | 🧹  Triage Inbox\ncommit | 💾  Guardar y Sincronizar (Git)\nf | 🔍  Buscar en notas\ngoto | 📂  Ir a nota existente\npanic | 🚨  BOTÓN DE PÁNICO\nexit | ❌  Salir" |
        rofi -dmenu -p "¿Qué quieres hacer?")

    [ -z "$ACTION_CODE_TEXT" ] && exit 0
    ACTION=$(echo "$ACTION_CODE_TEXT" | awk -F ' | ' '{print $1}')
    [ "$ACTION" = "exit" ] && exit 0
    echo "$ACTION"
}

run_tdo_action() {
    local ACTION="$1"
    case "$ACTION" in
        foco)
            TASK=$(cat "$NEXT_ACTION_FILE" 2>/dev/null || echo "Ninguna Tarea")
            SUB_ACTION_TEXT=$(echo -e "1 | ✏️  Editar Foco Actual\n2 | 🚀 Iniciar Pomodoro (Monk Mode)\nexit | ❌ Salir" | rofi -dmenu -p "🎯 Foco: $TASK")
            
            SUB_ACTION=$(echo "$SUB_ACTION_TEXT" | awk -F ' | ' '{print $1}')

            case "$SUB_ACTION" in
                1) run_in_work_tmux "$EDITOR '$NEXT_ACTION_FILE'" ;;
                2) run_in_work_tmux "start_monk" ;;
            esac
            ;;
        
        new_t)
            TASK_TITLE=$(rofi -dmenu -p "➕ Título de la Nueva Tarea:")
            if [ -n "$TASK_TITLE" ]; then
                run_in_work_tmux "$TDO t '$TASK_TITLE'"
                run_in_work_tmux "echo '$TASK_TITLE' > '$NEXT_ACTION_FILE' && notify-send '🎯 Foco' 'Tarea establecida: $TASK_TITLE'"
            fi
            ;;

        list_t)
            TASK_LIST=$( "$TDO" t ) 
            TASK=$( echo "$TASK_LIST" | rofi -dmenu -p "✅ Tareas Pendientes:" )
            
            if [ -n "$TASK" ]; then
                TASK_TEXT=$(echo "$TASK" | cut -d ' ' -f 2- | sed 's/^[[:space:]]*//')
                run_in_work_tmux "echo '$TASK_TEXT' > '$NEXT_ACTION_FILE' && notify-send '🎯 Foco' 'Tarea seleccionada como foco.'"
            fi
            ;;

        new_note)
            NOTE_TITLE=$(rofi -dmenu -p "📓 Título de la Nota Estructurada:")
            if [ -n "$NOTE_TITLE" ]; then
                # tdo n crea la nota en 0-inbox con plantilla y la abre
                run_in_work_tmux "$TDO n '$NOTE_TITLE'"
            fi
            ;;
        
        draft)
            NOTE_CONTENT=$(rofi -dmenu -p "💡 Captura la idea:")
            if [ -n "$NOTE_CONTENT" ]; then
                local TIMESTAMP=$(date +%Y-%m-%d_%H%M%S)
                local FILENAME="$TIMESTAMP-volcado-rapido.md"
                local FILE_PATH="$NOTES_DIR/0-inbox/$FILENAME"
                
                mkdir -p "$(dirname "$FILE_PATH")"
                echo "$NOTE_CONTENT" > "$FILE_PATH"
                
                if [ -f "$FILE_PATH" ]; then
                    notify-send "💡 Capturado y Abierto" "Nota enviada a Inbox y abierta."
                    run_in_work_tmux "$EDITOR '$FILE_PATH'"
                else
                    notify-send -u critical "❌ Error de Guardado" "No se pudo crear el archivo. Revisa permisos."
                fi
            fi
            ;;
        
        e)
            run_in_work_tmux "$TDO e"
            ;;
            
        triage)
            "$TRIAGE_SCRIPT"
            ;;
        
        commit)
            commit_and_push
            ;;
            
        f)
            SEARCH_TERM=$(rofi -dmenu -p "🔍 Buscar término:")
            [ -n "$SEARCH_TERM" ] && run_in_work_tmux "$TDO f '$SEARCH_TERM'"
            ;;
        
        goto)
            NOTE=$(find "$NOTES_DIR" -type f -name "*.md" \
                | sed "s|$NOTES_DIR/||; s|\.md$||" \
                | rofi -dmenu -p "📂 Selecciona nota:")
            [ -n "$NOTE" ] && run_in_work_tmux "$TDO '$NOTE.md'"
            ;;
        
        panic)
            "$PANIC_SCRIPT"
            ;;
            
        *)
            echo "Error: Acción '$ACTION' no procesada." >&2
            exit 1
            ;;
    esac
}

# --- MAIN ---
ACTION=$(select_tdo_action) || exit 0
run_tdo_action "$ACTION"
