#!/usr/bin/env sh
# Script interactivo para selecionar un host ssh definitivo en ~/.ssh/config

# Extrae todos los hosts definidios (evita comodines como "Host *")
# También descompone múltiples alias en una sola linea (Host dev1 dev2)

host=$(awk '/^Host / { for (i=2; i<=NF; i++) if ($i != "*") print $i }' ~/.ssh/config |
	fzf --prompt="SSH Hosts > " \
		--preview='grep -A 5 -w "Host {}" ~/.ssh/config' \
		--height=40% --layout=reverse --border)

# Si se seleccionó un host, lanza la conexión
[ -n "$host" ] && ssh "$host"
