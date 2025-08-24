# Tauri + Vite + NestJS + Prisma (example)

Estructura mínima de ejemplo para convertir una web (Vite + React) y un backend (NestJS + Prisma)
en una app de escritorio con Tauri usando un **sidecar** (ejecutable) para el backend.

**✨ Ahora configurado para build multiplataforma automático!**

**Contenido:**
- `apps/web` : Frontend Vite (React + TypeScript + Zustand)
- `backend` : NestJS + Prisma (schema + ejemplo de controller / health endpoint)
- `src-tauri`: skeleton con `tauri.conf.json` y un ejemplo de `main.rs` (spawn sidecar)
- `build-all.sh`: Script automatizado para generar ejecutables multiplataforma

## 🚀 Inicio Rápido

```bash
# Instalar dependencias
pnpm install

# Desarrollo
pnpm run dev

# Construir para tu plataforma actual
./build-all.sh macos     # En macOS
./build-all.sh linux     # En Linux
./build-all.sh windows   # En Windows

# Construir para todas las plataformas (requiere cross-compilation)
./build-all.sh all
```

## 📦 Generación de Ejecutables

El proyecto ahora incluye:
- ✅ **Configuración automática** para generar binarios multiplataforma
- ✅ **Scripts automatizados** para todo el proceso de build
- ✅ **Solución al problema de arranque** del backend
- ✅ **Cross-compilation** preparada para Linux y Windows desde macOS

**Requisitos mínimos:**
- Node.js 18.x o superior
- Rust toolchain (stable) + cargo (para Tauri)
- pnpm (recomendado) o npm/yarn
- pkg (incluido como dependencia del proyecto)

**Para cross-compilation (opcional):**
- `cargo install cross` - Para compilar desde una plataforma hacia otras

## 🛠️ Configuración por Plataforma

Ver archivo `REQUISITOS-PLATAFORMA.md` para detalles específicos de cada sistema operativo.

## 🔧 Soluciones Implementadas

### Problema: Backend no arrancaba al primer intento
**Solución:** 
- Aumentamos el tiempo de espera inicial (1 segundo)
- Incrementamos los intentos de health check (120 intentos = 30 segundos)
- Mejor logging para diagnosticar problemas
- Manejo robusto de errores en el spawn del sidecar

### Problema: Build manual complejo
**Solución:**
- Script `build-all.sh` que automatiza todo el proceso
- Scripts npm organizados por plataforma
- Copia automática de binarios a las ubicaciones correctas

**Notas importantes:**
- ✅ Los binarios del backend ahora se generan automáticamente
- ✅ Prisma está configurado para funcionar correctamente con pkg
- ✅ El sidecar se maneja de forma más robusta en producción
- ✅ Cross-compilation configurada para desarrollo multiplataforma
