#!/bin/bash

# ====================================================================
# SCRIPT PARA IMPORTAR DISCOS VIRTUALES VDI (VirtualBox) a KVM (QEMU)
# ====================================================================

# CONFIGURACIÓN
VM_NAME="$1"
VDI_PATH="$2"

# Parámetros de la Máquina Virtual (ajustar si es necesario)
RAM_MB=4096
VCPUS=2

# Corregido: Usamos un valor genérico para satisfacer el requisito de --os-variant
# Puedes consultar 'virt-install --osinfo list' para valores más específicos.
OS_VARIANT="linux2020" 

# Rutas
QCOW2_PATH="$HOME/${VM_NAME}.qcow2"

# ====================================================================
# VALIDACIÓN DE ENTRADA
# ====================================================================
if [[ -z "$VM_NAME" || -z "$VDI_PATH" ]]; then
    echo "❌ ERROR: Faltan argumentos."
    echo "Uso: $0 <nombre_vm> <ruta_al_vdi>"
    exit 1
fi

# ====================================================================
# 1. CONVERSIÓN DEL DISCO
# ====================================================================
echo "Convirtiendo $VDI_PATH a $QCOW2_PATH..."
if ! qemu-img convert -O qcow2 "$VDI_PATH" "$QCOW2_PATH"; then
    echo "❌ ERROR: La conversión del disco falló."
    exit 1
fi

# ====================================================================
# 2. CREACIÓN DE LA VM
# ====================================================================
echo "Creando la VM '$VM_NAME'..."

# Aseguramos que la VM no exista para evitar conflictos
virsh --connect qemu:///session undefine "$VM_NAME" 2>/dev/null

# Comando virt-install con correcciones:
# 1. Se eliminó --os-type (obsoleto).
# 2. Se incluyó --os-variant (obligatorio).
# 3. Se cambió --graphics spice por --graphics vnc (soluciona el error de "unsupported configuration").
if virt-install \
    --name "$VM_NAME" \
    --ram "$RAM_MB" \
    --vcpus "$VCPUS" \
    --os-variant "$OS_VARIANT" \
    --disk path="$QCOW2_PATH",format=qcow2,bus=sata \
    --import \
    --graphics vnc \
    --noautoconsole; then
    
    echo "✅ VM '$VM_NAME' creada correctamente."
    echo "🚀 Puede iniciarla ahora con: virsh --connect qemu:///session start $VM_NAME"
else
    echo "❌ ERROR: La creación de la VM '$VM_NAME' falló."
    exit 1
fi
