#!/bin/bash

# Definir archivos a incluir (Añade aquí tus rutas de .md y Exodus)
ARCHIVOS_A_SALVAR=(
    "/mnt/datos/Documents/personal/Finanzas/wallets"
    "$HOME/.config/Exodus/"
)

DESTINO="/mnt/datos/backup/seguro"
NOMBRE_FINAL="vault_$(date +%Y%m%d).tar.gz.gpg"

# Crear el paquete cifrado directamente
# Usamos --batch para que no pida confirmaciones si lo automatizas
tar -cz "${ARCHIVOS_A_SALVAR[@]}" | gpg --symmetric --cipher-algo AES256 -o "$DESTINO/$NOMBRE_FINAL"

echo "¡Listo! Todos tus secretos están en $DESTINO/$NOMBRE_FINAL"
