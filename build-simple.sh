#!/bin/bash

echo "🚀 Generando binarios usando Docker (método simple)..."

# Verificar que Docker esté corriendo
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker no está corriendo. Por favor inicia Docker Desktop."
    exit 1
fi

# Crear directorio de salida
mkdir -p ./output

echo "📦 Construyendo imagen Docker simple..."
docker build -f Dockerfile.simple -t tauri-simple-build .

if [ $? -ne 0 ]; then
    echo "❌ Error construyendo la imagen Docker"
    exit 1
fi

echo "🏗️  Ejecutando build..."
docker run --rm -v "$(pwd)/output:/host-output" tauri-simple-build sh -c "
    pnpm run build:web
    cd backend
    pnpm run build
    pnpm run prisma:generate 
    pnpm run pkg:windows
    pnpm run copy:windows
    
    echo 'Copiando archivos de salida...'
    cp -r dist-bin/* /host-output/ 2>/dev/null || true
    cp ../src-tauri/binaries/my-backend-x86_64-pc-windows-msvc.exe /host-output/ 2>/dev/null || true
    
    echo 'Archivos generados:'
    ls -la /host-output/
"

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Build completado!"
    echo "📁 Los binarios están en ./output/"
    ls -la ./output/
    
    echo ""
    echo "📋 Archivos generados:"
    echo "   - main-win.exe: Ejecutable del backend para Windows"
    echo "   - my-backend-x86_64-pc-windows-msvc.exe: Backend para Tauri"
    
    echo ""
    echo "🎯 Para completar el instalador de Windows:"
    echo "1. Transfiere estos archivos a una PC con Windows"
    echo "2. Coloca my-backend-x86_64-pc-windows-msvc.exe en src-tauri/binaries/"
    echo "3. Ejecuta: cargo tauri build --target x86_64-pc-windows-msvc"
else
    echo "❌ Error en el build"
fi

echo ""
echo "🧹 Limpiando imagen Docker..."
docker rmi tauri-simple-build
