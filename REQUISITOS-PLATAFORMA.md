# Requisitos y Configuración por Plataforma

Este documento describe los requisitos y pasos necesarios para utilizar la aplicación Tauri Vite NestJS Prisma en diferentes plataformas.

## 🚀 Configuración General

La aplicación está ahora configurada para generar ejecutables multiplataforma de forma automática. El proceso completo incluye:

1. Compilación del backend con NestJS y Prisma
2. Empaquetado del backend con pkg para Linux, macOS y Windows
3. Construcción del frontend con Vite
4. Empaquetado de todo con Tauri para producir instaladores nativos

## 🔧 Requisitos por Plataforma

### 🍎 macOS

**Para usuarios finales:**
- macOS 10.15 (Catalina) o superior
- Arquitectura x86_64 (Intel) o ARM64 (Apple Silicon)
- Sin dependencias adicionales, el instalador .dmg incluye todo lo necesario

**Para desarrolladores:**
- Xcode Command Line Tools: `xcode-select --install`
- Rust: `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`
- Node.js v16 o superior
- pnpm: `npm install -g pnpm`

### 🐧 Linux

**Para usuarios finales:**
- Distribución basada en Debian: Instalar el archivo `.deb`
- Distribución basada en Red Hat: Instalar el archivo `.rpm`
- Otras distribuciones: Descomprimir y ejecutar el binario
- Dependencias de WebKit: `libwebkit2gtk-4.0-dev libssl-dev libgtk-3-dev libayatana-appindicator3-dev librsvg2-dev`

**Dependencias del sistema (Ubuntu/Debian):**
```bash
sudo apt update
sudo apt install -y webkit2gtk-4.0-dev libssl-dev libgtk-3-dev libayatana-appindicator3-dev librsvg2-dev
```

**Para desarrolladores en Linux:**
```bash
# Instalar Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Instalar dependencias de desarrollo
sudo apt install -y build-essential curl wget file libssl-dev libgtk-3-dev libayatana-appindicator3-dev librsvg2-dev webkit2gtk-4.0-dev
```

### 🪟 Windows

**Para usuarios finales:**
- Windows 10 o superior
- Ejecutar el instalador `.exe` o `.msi`
- No se requieren dependencias adicionales, todo incluido en el instalador

**Para desarrolladores en Windows:**
```powershell
# Instalar Rust
winget install Rustlang.Rustup

# Instalar Visual Studio Build Tools (requerido para compilación)
winget install Microsoft.VisualStudio.2022.BuildTools

# Instalar Node.js
winget install OpenJS.NodeJS

# Instalar pnpm
npm install -g pnpm
```

## 🚀 Uso de la Aplicación

### Instalación

1. Descargar el instalador apropiado para tu plataforma:
   - **macOS**: archivo `.dmg` o `.app`
   - **Windows**: archivo `.exe` (NSIS) o `.msi`
   - **Linux**: archivo `.deb`, `.rpm` o binario comprimido

2. Instalar la aplicación:
   - **macOS**: Abrir el archivo .dmg y arrastrar la aplicación a la carpeta Applications
   - **Windows**: Ejecutar el instalador y seguir las instrucciones
   - **Linux**: Instalar con gestor de paquetes o extraer y ejecutar

### Primera Ejecución

La aplicación ahora inicia el backend automáticamente en el primer arranque. Hemos solucionado el problema anterior donde:

1. El frontend se iniciaba inmediatamente
2. El backend tardaba en iniciar y no estaba listo a tiempo
3. Esto causaba que pareciera que solo funcionaba en el segundo arranque

Las mejoras incluyen:
- Mejor manejo de errores en el código Rust
- Mayor tiempo de espera para el inicio del backend
- Logging mejorado para diagnóstico
- Sistema más robusto para detectar cuando el backend está listo

## 🔄 Generación de Ejecutables

Si necesitas generar ejecutables para las diferentes plataformas, ahora puedes usar:

```bash
# Construir para todas las plataformas (si el sistema lo permite)
./build-all.sh all

# O específicamente para una plataforma
./build-all.sh macos
./build-all.sh linux
./build-all.sh windows
```

### Archivos Generados

Los ejecutables finales se encontrarán en:
```
src-tauri/target/release/bundle/
```

## 🐛 Solución de Problemas

### Problemas comunes:

1. **El backend no arranca:**
   - Verificar que ninguna otra aplicación esté usando el puerto 4000
   - Comprobar que los archivos binarios tienen permisos de ejecución

2. **Error "Backend no respondió":**
   - El tiempo de espera para el inicio del backend puede aumentarse en `main.rs`
   - Probar aumentando el valor `max_attempts` si tu sistema es más lento

3. **Problemas de permisos en Linux:**
   - Asegurar que el binario tiene permisos de ejecución: `chmod +x path/to/app`

4. **Error de SQLite en Prisma:**
   - La base de datos SQLite se crea automáticamente en la carpeta del usuario
   - Verificar permisos de escritura en la carpeta donde se ejecuta la aplicación
