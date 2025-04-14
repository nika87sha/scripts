#!/bin/bash

# CONFIGURACIÓN
VM_NAME="$1"
VDI_PATH="$2"
RAM_MB=4096
VCPUS=2
OS_TYPE="linux"      # o "windows"
OS_VARIANT="generic" # podés usar `osinfo-query os` para ver opciones
QCOW2_PATH="$HOME/${VM_NAME}.qcow2"

# VALIDACIÓN
if [[ -z "$VM_NAME" || -z "$VDI_PATH" ]]; then
	echo "Uso: $0 <nombre_vm> <ruta_al_vdi>"
	exit 1
fi

# CONVERSIÓN DEL DISCO
echo "Convirtiendo $VDI_PATH a $QCOW2_PATH..."
qemu-img convert -O qcow2 "$VDI_PATH" "$QCOW2_PATH"

# CREACIÓN DE LA VM
echo "Creando la VM '$VM_NAME'..."
virt-install \
	--name "$VM_NAME" \
	--ram "$RAM_MB" \
	--vcpus "$VCPUS" \
	--os-type "$OS_TYPE" \
	--os-variant "$OS_VARIANT" \
	--disk path="$QCOW2_PATH",format=qcow2,bus=sata \
	--import \
	--graphics spice \
	--noautoconsole

echo "✅ VM '$VM_NAME' creada correctamente."
