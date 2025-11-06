#!/bin/bash
DIR_REPOS="$HOME/Projects" # Ruta proyectos

for repo in "$DIR_REPOS"/*/; do
  # Comprobar que sea un directorio
  if [ -d "$repo" ]; then
    # Entramos en el directorio
    cd "$repo" || continue # Sale del bucle si falla el cd

    if [ -d ".git" ]; then
      echo "Actualizando $(basename "$repo")" # 'basename' solo muestra el nombre de la carpeta
      git pull # ejecutamos el comando git
    fi
    # Volvemos al directorio raiz para ejecutar la siguiente iteración
    cd "$DIR_REPOS"
  fi
done
