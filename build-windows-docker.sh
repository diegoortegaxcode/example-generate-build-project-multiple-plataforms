#!/bin/bash

echo "🚀 Construyendo instalador de Windows usando Docker..."

# Verificar que Docker esté corriendo
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker no está corriendo. Por favor inicia Docker Desktop."
    exit 1
fi

# Crear directorio de salida
mkdir -p ./windows-installers

echo "📦 Construyendo imagen Docker de Windows..."
docker build -f Dockerfile.windows -t tauri-windows-builder .

if [ $? -ne 0 ]; then
    echo "❌ Error construyendo la imagen Docker"
    exit 1
fi

echo "🏗️  Ejecutando contenedor para extraer instaladores..."
docker run --rm -v "$(pwd)/windows-installers:/host-output" tauri-windows-builder powershell -Command "Copy-Item 'C:\output\*' '/host-output/' -Recurse -Force"

if [ $? -eq 0 ]; then
    echo "✅ Instaladores de Windows generados exitosamente!"
    echo "📁 Los instaladores están en: ./windows-installers/"
    ls -la ./windows-installers/
else
    echo "❌ Error extrayendo los instaladores"
fi

# Limpiar imagen Docker (opcional)
read -p "¿Deseas eliminar la imagen Docker para liberar espacio? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    docker rmi tauri-windows-builder
    echo "🧹 Imagen Docker eliminada"
fi
