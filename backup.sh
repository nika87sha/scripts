#!/bin/bash
source_dir="/ruta/fuente"
backup_dir="/ruta/copia_de_seguridad"

timestamp=$(date +%Y%m%d%H%M%S)
backup_file="backup_$timestamp.tar.gz"
tar -czvf "backup_dir/$backup_file" "source_dir"
