#!/bin/bash

echo "🚀 Generando binarios de Windows usando cross-compilation..."

# Verificar que Docker esté corriendo
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker no está corriendo. Por favor inicia Docker Desktop."
    exit 1
fi

# Crear directorio de salida
mkdir -p ./windows-output

echo "📦 Construyendo imagen Docker para cross-compilation..."
docker build -f Dockerfile.cross-windows -t tauri-cross-windows .

if [ $? -ne 0 ]; then
    echo "❌ Error construyendo la imagen Docker"
    exit 1
fi

echo "🏗️  Ejecutando build de binarios de Windows..."
docker run --rm -v "$(pwd)/windows-output:/output" tauri-cross-windows bash -c "
    echo '🎨 Construyendo frontend...'
    pnpm run build:web
    
    echo '🔧 Construyendo backend...'
    cd backend
    pnpm run build
    pnpm run prisma:generate
    pnpm run pkg:windows
    
    echo '📋 Copiando binarios...'
    pnpm run copy:windows
    
    echo '📦 Copiando archivos de salida...'
    cp -r dist-bin /output/backend-binaries || true
    cp -r ../src-tauri/binaries /output/tauri-binaries || true
    
    echo '✅ Build completado!'
    ls -la /output/
"

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Binarios de Windows generados exitosamente!"
    echo "📁 Los binarios están en:"
    echo "   - Backend: ./windows-output/backend-binaries/"
    echo "   - Tauri: ./windows-output/tauri-binaries/"
    ls -la ./windows-output/
else
    echo "❌ Error generando los binarios"
fi

# Nota: Para generar los instaladores .msi/.exe necesitarías Windows
echo ""
echo "ℹ️  Nota: Los binarios están listos, pero para generar instaladores .msi/.exe"
echo "   necesitarías ejecutar 'cargo tauri build' en una máquina Windows."
echo ""
echo "📋 Para continuar en Windows:"
echo "1. Copia los archivos del proyecto a una máquina Windows"
echo "2. Copia los binarios de ./windows-output/tauri-binaries/ a src-tauri/binaries/"
echo "3. Ejecuta: cargo tauri build"
