#!/bin/bash

# Script de build automatizado para todas las plataformas
# Uso: ./build-all.sh [platform]
# Plataformas: all, linux, macos, windows

set -e

echo "🚀 Iniciando build multiplataforma..."

# Función para mostrar ayuda
show_help() {
    echo "Uso: $0 [platform]"
    echo "Plataformas disponibles:"
    echo "  all      - Construir para todas las plataformas"
    echo "  linux    - Construir solo para Linux"
    echo "  macos    - Construir solo para macOS"
    echo "  windows  - Construir solo para Windows"
    echo ""
    echo "Ejemplo: $0 all"
}

# Verificar si se proporcionó un argumento
PLATFORM=${1:-all}

# Función para verificar dependencias
check_dependencies() {
    echo "🔍 Verificando dependencias..."
    
    if ! command -v pnpm &> /dev/null; then
        echo "❌ pnpm no está instalado. Instalar con: npm install -g pnpm"
        exit 1
    fi
    
    if ! command -v cargo &> /dev/null; then
        echo "❌ Rust/Cargo no está instalado. Instalar desde: https://rustup.rs/"
        exit 1
    fi
    
    if ! command -v pkg &> /dev/null; then
        echo "⚠️  pkg no está instalado globalmente, usando versión local..."
    fi
    
    echo "✅ Dependencias verificadas"
}

# Función para limpiar builds anteriores
clean_builds() {
    echo "🧹 Limpiando builds anteriores..."
    rm -rf backend/dist-bin
    rm -rf src-tauri/binaries/*
    rm -rf src-tauri/target/release
    echo "✅ Limpieza completada"
}

# Función para construir el backend
build_backend() {
    echo "🔧 Construyendo backend..."
    cd backend
    pnpm run build
    pnpm run prisma:generate
    cd ..
    echo "✅ Backend construido"
}

# Función para construir frontend
build_frontend() {
    echo "🎨 Construyendo frontend..."
    pnpm run build:web
    echo "✅ Frontend construido"
}

# Función para generar binarios del backend
generate_backend_binaries() {
    local platform=$1
    echo "📦 Generando binarios del backend para: $platform..."
    
    cd backend
    
    case $platform in
        "linux")
            pnpm run pkg:linux
            ;;
        "macos")
            pnpm run pkg:macos
            ;;
        "windows")
            pnpm run pkg:windows
            ;;
        "all")
            pnpm run pkg:all
            ;;
    esac
    
    cd ..
    echo "✅ Binarios del backend generados"
}

# Función para copiar binarios
copy_binaries() {
    local platform=$1
    echo "📋 Copiando binarios para: $platform..."
    
    cd backend
    
    case $platform in
        "linux")
            if [ -f "./dist-bin/main-linux" ]; then
                pnpm run copy:linux
            else
                echo "⚠️  Binario de Linux no encontrado"
            fi
            ;;
        "macos")
            if [ -f "./dist-bin/main-macos" ]; then
                pnpm run copy:macos
            else
                echo "⚠️  Binario de macOS no encontrado"
            fi
            ;;
        "windows")
            if [ -f "./dist-bin/main-win.exe" ]; then
                pnpm run copy:windows
            else
                echo "⚠️  Binario de Windows no encontrado"
            fi
            ;;
        "all")
            [ -f "./dist-bin/main-linux" ] && pnpm run copy:linux
            [ -f "./dist-bin/main-macos" ] && pnpm run copy:macos
            [ -f "./dist-bin/main-win.exe" ] && pnpm run copy:windows
            ;;
    esac
    
    cd ..
    echo "✅ Binarios copiados"
}

# Función para construir con Tauri
build_tauri() {
    local platform=$1
    echo "🏗️  Construyendo aplicación Tauri para: $platform..."
    
    cd src-tauri
    
    case $platform in
        "linux")
            if command -v cross &> /dev/null; then
                cargo tauri build --target x86_64-unknown-linux-gnu
            else
                echo "⚠️  Cross-compilation para Linux no disponible en macOS sin cross"
                echo "💡 Instalar cross: cargo install cross"
            fi
            ;;
        "macos")
            cargo tauri build --target x86_64-apple-darwin
            ;;
        "windows")
            if command -v cross &> /dev/null; then
                cargo tauri build --target x86_64-pc-windows-msvc
            else
                echo "⚠️  Cross-compilation para Windows no disponible en macOS sin cross"
                echo "💡 Instalar cross: cargo install cross"
            fi
            ;;
        "all")
            # En macOS, solo podemos compilar nativo sin cross
            cargo tauri build --target x86_64-apple-darwin
            if command -v cross &> /dev/null; then
                cargo tauri build --target x86_64-unknown-linux-gnu
                cargo tauri build --target x86_64-pc-windows-msvc
            else
                echo "⚠️  Para cross-compilation, instalar: cargo install cross"
            fi
            ;;
    esac
    
    cd ..
    echo "✅ Aplicación Tauri construida"
}

# Main execution
case $PLATFORM in
    "help"|"-h"|"--help")
        show_help
        exit 0
        ;;
    "all"|"linux"|"macos"|"windows")
        check_dependencies
        clean_builds
        build_frontend
        build_backend
        generate_backend_binaries $PLATFORM
        copy_binaries $PLATFORM
        build_tauri $PLATFORM
        echo ""
        echo "🎉 Build completado para: $PLATFORM"
        echo "📁 Ejecutables generados en: src-tauri/target/release/bundle/"
        ;;
    *)
        echo "❌ Plataforma no válida: $PLATFORM"
        show_help
        exit 1
        ;;
esac
