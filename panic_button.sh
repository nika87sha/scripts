#!/usr/bin/env bash

# 1. Desactiva el bloqueo de red
$HOME/.config/hypr/UserScripts/monk_mode_toggle.sh

# 2. Cierra la sesión de enfoque de tmux
tmux kill-session -t Work 2>/dev/null

# 3. Notifica el cierre y redirige la atención
notify-send "🛑 Botón de Pánico" "Descanso forzado de 30 minutos. ¡No hay culpa!" -u critical
echo "Zzz. Tarea de baja carga: Moverse o beber agua." > $HOME/notes/todos/next_action

# 4. Limpia la cola de notificaciones
dunstctl close-all

# (Opcional) Puedes añadir un script de Hyprland aquí para cambiar a un Workspace de "descanso"
# hyprctl dispatch workspace 9
