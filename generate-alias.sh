#!/usr/bin/env bash

# 📍 Ruta a los ficheros de alias
ALIAS_DIR="${HOME}/.config/zsh/plugins/aliases"
README_FILE="${ALIAS_DIR}/README.md"

# Encabezado del README
cat <<'EOF' >"$README_FILE"
# 🧩 Dotfiles Alias Reference

Este documento se genera automáticamente y documenta todos los alias activos en los ficheros ZSH de configuración.

> ⚠️ Edita los ficheros `.sh` en lugar de este README directamente.

| Alias | Comando |
|-------|---------|
EOF

# Buscar alias en todos los .sh del directorio
grep -hE '^alias ' "${ALIAS_DIR}"/*.sh 2>/dev/null |
	sed -E "s/^alias ([^=]+)='([^']+)'$/|\1|\2|/" |
	sed -E 's/^alias ([^=]+)="([^"]+)"$/|\1|\2|/' \
		>>"$README_FILE"

# Agregar nota al final
cat <<EOF >>"$README_FILE"

---

📅 Última actualización: $(date '+%Y-%m-%d %H:%M:%S')
EOF

echo "✅ README.md generado en: $README_FILE"
