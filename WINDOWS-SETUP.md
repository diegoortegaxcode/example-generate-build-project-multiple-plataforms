# Configuración y Uso en Windows

## Compatibilidad de Windows

✅ **Versiones de Windows compatibles:**
- Windows 10 (versión 1809 o superior) - **Recomendado**
- Windows 11 (todas las versiones)
- Windows Server 2019/2022

⚠️ **Versiones con compatibilidad limitada:**
- Windows 8.1 (puede funcionar pero no es oficialmente soportado por Tauri)
- Windows Server 2016 (funcionalidad limitada)

❌ **Versiones NO compatibles:**
- Windows 7 y anteriores
- Windows Server 2012 y anteriores

### Requisitos del Sistema
- **Arquitectura:** x64 (64-bit)
- **RAM:** Mínimo 4GB, recomendado 8GB
- **Espacio en disco:** Al menos 2GB libres
- **WebView2:** Se instala automáticamente si no está presente

## Uso Rápido - Actualizaciones Futuras

### Opción 1: Script Automático (Recomendado)
```powershell
# Ejecutar el script de actualización automática
.\update-and-build.ps1
```

### Opción 2: Pasos Manuales
```powershell
# 1. Descargar cambios
git pull origin master

# 2. Instalar dependencias
npm install
cd backend && npm install && cd ..

# 3. Construir backend
cd backend && npm run build && cd ..

# 4. Construir aplicación
npm run tauri build
```

## Ubicación del Instalador

Después de la construcción, el instalador se encuentra en:
```
src-tauri\target\release\bundle\msi\
```

Los archivos tendrán nombres como:
- `example-generate-build-project-multiple-plataforms_1.0.0_x64_en-US.msi`

## Instalación

1. Localiza el archivo `.msi` en la carpeta mencionada arriba
2. Haz doble clic en el archivo `.msi`
3. Sigue el asistente de instalación
4. La aplicación se instalará en `C:\Program Files\`

## Desinstalación

- Ve a **Configuración > Aplicaciones** o **Panel de Control > Programas**
- Busca "example-generate-build-project-multiple-plataforms"
- Selecciona y haz clic en "Desinstalar"

## Solución de Problemas

### Error: "No se puede ejecutar scripts"
```powershell
# Permitir la ejecución de scripts locales
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Error: "WebView2 no encontrado"
- Descarga e instala Microsoft Edge WebView2 Runtime desde el sitio oficial de Microsoft

### Error: "npm no encontrado"
- Instala Node.js desde https://nodejs.org/

### Error: "Rust/Cargo no encontrado"
- Instala Rust desde https://rustup.rs/

## Desarrollo

### Ejecutar en modo desarrollo
```powershell
npm run tauri dev
```

### Construir sin instalar
```powershell
npm run tauri build
```

---

**Nota:** Este proyecto está configurado para generar instaladores MSI compatibles con Windows. Los binarios están optimizados para arquitecturas x64 de Windows.
