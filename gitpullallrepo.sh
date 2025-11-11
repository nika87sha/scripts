#!/bin/bash
# =====================================================================
# 🌀 Actualizador de repositorios Git (recursivo)
# Busca todos los repos dentro de una carpeta y ejecuta git pull
# =====================================================================

DIR_REPOS="$HOME/Projects/git-cbk" # Ruta raíz de tus proyectos

# Colores para la salida
GREEN="\033[1;32m"
RED="\033[1;31m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
NC="\033[0m" # Sin color

echo -e "\n${BLUE}🔍 Buscando repositorios Git dentro de:${NC} $DIR_REPOS"
echo "=============================================================="

# Buscar todos los .git y recorrerlos
find "$DIR_REPOS" -type d -name ".git" | while read -r gitdir; do
  repo=$(dirname "$gitdir")
  repo_name=$(basename "$repo")

  echo -e "\n${YELLOW}📁 Actualizando repositorio:${NC} $repo_name"
  echo -e "📂 Ruta: $repo"

  cd "$repo" || { echo -e "${RED}⚠️ No se pudo entrar en el directorio${NC}"; continue; }

  # Ejecutar git pull
  if git pull --quiet; then
    echo -e "${GREEN}✅ $repo_name: Actualización completada con éxito${NC}"
  else
    echo -e "${RED}❌ $repo_name: ERROR al hacer git pull. Revisa tu trabajo local${NC}"
  fi
done

echo -e "\n${BLUE}🏁 Proceso completado.${NC}\n"
