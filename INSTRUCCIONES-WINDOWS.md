# Instrucciones para generar instalador de Windows

## 🎉 ¡Los binarios ya están listos!

Los binarios de Windows han sido generados exitosamente y están disponibles en la carpeta `output/`:
- `main-win.exe`: Ejecutable standalone del backend
- `my-backend-x86_64-pc-windows-msvc.exe`: Backend para Tauri

## 🖥️ Opción 1: Usar desde Mac (ya completado)

Si tienes Docker en Mac, puedes generar los binarios ejecutando:
```bash
./build-simple.sh
```

## 🪟 Opción 2: Completar en Windows (generar instaladores)

### Paso 1: Preparar entorno Windows
En una máquina Windows, instalar:
```powershell
# Instalar Chocolatey (ejecutar como administrador)
Set-ExecutionPolicy Bypass -Scope Process -Force
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Instalar dependencias
choco install nodejs-lts -y
choco install rust -y
choco install visualstudio2022buildtools -y
choco install visualstudio2022-workload-vctools -y

# Instalar pnpm y tauri-cli
npm install -g pnpm@8.9.0
cargo install tauri-cli@1.5.6
```

### Paso 2: Clonar y configurar proyecto
```bash
git clone https://github.com/diegoortegaxcode/example-generate-build-project-multiple-plataforms.git
cd example-generate-build-project-multiple-plataforms
pnpm install
```

### Paso 3: Copiar binarios
Los binarios ya están en `output/`. Si necesitas regenerarlos:
```bash
# El binario ya debería estar en src-tauri/binaries/
# Si no está, copiarlo:
copy output\my-backend-x86_64-pc-windows-msvc.exe src-tauri\binaries\
```

### Paso 4: Generar instaladores
```bash
# Generar instaladores de Windows
cd src-tauri
cargo tauri build
```

### Paso 5: Recoger instaladores
Los instaladores se generarán en:
```
src-tauri\target\release\bundle\msi\
  - Tauri Vite Nest Prisma Example_0.1.0_x64_en-US.msi

src-tauri\target\release\bundle\nsis\  
  - Tauri Vite Nest Prisma Example_0.1.0_x64-setup.exe
```

## 📱 Para usuarios finales (Windows)

Una vez tengas el instalador:

1. **Descargar el instalador** (.msi o .exe)
2. **Ejecutar como administrador** (click derecho → "Ejecutar como administrador")
3. **Seguir el asistente de instalación**
4. **¡Listo!** La aplicación estará en el menú inicio

### Lo que NO necesitan instalar los usuarios finales:
- ❌ Node.js
- ❌ Rust
- ❌ Visual Studio
- ❌ Ninguna dependencia de desarrollo

### Lo que SÍ incluye el instalador automáticamente:
- ✅ Frontend (React + Vite)
- ✅ Backend (NestJS + Prisma)
- ✅ Base de datos SQLite (se crea automáticamente)
- ✅ Todas las dependencias necesarias

## 🐛 Solución de problemas

### Si el build falla en Windows:
1. Asegurate de tener Visual Studio Build Tools instalado con "Desktop development with C++"
2. Reinicia PowerShell después de instalar las herramientas
3. Verifica las versiones: `cargo --version`, `node --version`, `pnpm --version`

### Si la aplicación no inicia:
1. Verifica que el puerto 4000 esté libre
2. Ejecuta la aplicación desde la línea de comandos para ver errores
3. Revisa los logs en `%APPDATA%\tauri-vite-nest-prisma-example\`

## 📝 Notas técnicas

- **Arquitectura soportada**: x86_64 (64-bit)
- **Versiones de Windows**: Windows 10 o superior
- **Tamaño del instalador**: ~50MB (incluye todo el runtime)
- **Base de datos**: SQLite (se crea automáticamente en primer uso)

## 🚀 Distribución

Una vez tengas los instaladores, puedes distribuirlos de cualquier forma:
- Email
- Página web de descargas
- Repositorio de releases en GitHub
- USB/CD/DVD

Cada instalador es completamente independiente y no requiere conexión a internet para funcionar.
