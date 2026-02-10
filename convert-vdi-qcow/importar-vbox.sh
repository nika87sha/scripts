#!/bin/bash

# ====================================================================
# SCRIPT CORREGIDO PARA IMPORTAR VDI A KVM
# ====================================================================

VM_NAME="$1"
VDI_PATH="$2"

# Configuración mejorada
RAM_MB=4096
VCPUS=2
OS_VARIANT="ubuntu24.04" 
# Ruta estándar para evitar problemas de permisos
STORAGE_PATH="/var/lib/libvirt/images"
QCOW2_PATH="${STORAGE_PATH}/${VM_NAME}.qcow2"

if [[ -z "$VM_NAME" || -z "$VDI_PATH" ]]; then
    echo "❌ ERROR: Uso: $0 <nombre_vm> <ruta_al_vdi>"
    exit 1
fi

# 1. CONVERSIÓN (Necesita sudo para escribir en /var/lib/libvirt/images)
echo "Convirtiendo disco..."
sudo qemu-img convert -O qcow2 "$VDI_PATH" "$QCOW2_PATH"

# 2. AJUSTE DE PERMISOS (Vital para que KVM pueda leerlo)
sudo chown libvirt-qemu:kvm "$QCOW2_PATH"

# 3. CREACIÓN DE LA VM (Usando qemu:///system para mayor estabilidad)
echo "Creando la VM '$VM_NAME'..."

sudo virt-install \
    --connect qemu:///system \
    --name "$VM_NAME" \
    --ram "$RAM_MB" \
    --vcpus "$VCPUS" \
    --os-variant "$OS_VARIANT" \
    --disk path="$QCOW2_PATH",format=qcow2,bus=virtio \
    --import \
    --graphics vnc,listen=127.0.0.1 \
    --video vga \
    --network default \
    --noautoconsole

if [ $? -eq 0 ]; then
    echo "✅ VM '$VM_NAME' creada correctamente."
    echo "🚀 Iniciar con: virt-viewer --connect qemu:///system $VM_NAME"
else
    echo "❌ ERROR: La creación falló."
fi
