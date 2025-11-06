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

    if [ $? -eq 0 ]; then
      echo "✅ $(basename "$DIR_REPOS"): Actualización completada"
    else
      echo " $(basename "$DIR_REPOS"): ERROR al hacer pull. Revisa tu trabajo local"
    fi
    # Volvemos al directorio raiz para ejecutar la siguiente iteración
    cd "$DIR_REPOS"
  fi
done
