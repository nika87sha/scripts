#!/usr/bin/env bash
# ~/scripts/monk_mode_toggle.sh

HOSTS_FILE="/etc/hosts"
BLOCK_FILE="$HOME/.local/bin/scripts/bloqueo_distraccion.txt"
BACKUP_FILE="$HOME/.local/bin/scripts/hosts.bak"

# 1. Bloqueo de HOSTS (Web)
if grep -q "### MONK MODE ACTIVADO ###" $HOSTS_FILE; then
    # Desactivar
    sudo cp $BACKUP_FILE $HOSTS_FILE
    
    notify-send "✅ Modo Monje DESACTIVADO" "Redes sociales restauradas. Pausa."
else
    # Activar
    sudo cp $HOSTS_FILE $BACKUP_FILE
    sudo cat $BLOCK_FILE | sudo tee -a $HOSTS_FILE > /dev/null
    echo -e "\n### MONK MODE ACTIVADO ###" | sudo tee -a $HOSTS_FILE > /dev/null
    
    notify-send "🔒 Modo Monje ACTIVADO" "Sitios web bloqueados. ¡A ENFOCARSE!" -u critical
fi
