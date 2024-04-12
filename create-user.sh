#!/bin/bash
#!/bin/bash
#title          create-users.sh
#description    Script para añadir un nuevo usuario a la lilsta de superuser
#author         Verónica Durán
#date           20240412
#version        0.1
#


# Crear un usuario

user=newuser
password=newpassword

useradd -m $user
echo "$user:$password" | chpasswd

# Agregar el grupo sudo
usermod -aG sudo $user
