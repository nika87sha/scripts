#!/bin/bash
#title          :backupsystem.sh
#description    :Copia de seguridad sistema completo
#author         :Verónica Durán
#date           :20240613
#version        :1
#usage          :./backupsystem.sh
#notes          :
#============================================================================

# complet sistema de còpia de seguretat

# Destinació de la còpia de seguretat
backdest=/opt/còpia de seguretat

# Les etiquetes de nom de còpia de seguretat
#PC=${NOM}
pc=pavelló
distribució=arc
tipus=complet
data=$(date "+%F")
backupfile="$backdest/$distro-$tipus$date.tar.gz"

# Excloure la ubicació del fitxer
prog=${0##*/} # Programa nom del fitxer
excdir="/home/<usuari>/.bin/root/còpia de seguretat"
exclude_file="$excdir/$prog-exc.txt"

# Comprovar si chrooted indicatiu.
echo-n "Primer chroot des d'un LiveCD. Esteu a punt de fer còpies de seguretat? (y/n): "
llegir executeback

# Comprovar si excloure el fitxer ja existeix
if [ ! -f $exclude_file ]; then
 echo-n "No exclou el fitxer existeix, continuar? (y/n): "
 llegir continuar
 if [ $continue == "n" ]; then exit; fi
fi

if [ $executeback = "y" ]; then
 # -p, --les acl i --xattrs emmagatzemar tots els permisos, les acl i atributs extesos.
 # Sense tant d'aquests, molts programes de deixar de treballar!
 # És segur per eliminar la verbose (-v) la bandera. Si esteu utilitzant un
 # terminal lent, aquest pot molt accelerar el procés de còpia de seguretat.
 # D'utilitzar bsdtar GNU tar perquè no preservar atributs extesos.
 bsdtar --exclude-from="$exclude_file" --les acl --xattrs -cpvaf "$backupfile" /
fi
