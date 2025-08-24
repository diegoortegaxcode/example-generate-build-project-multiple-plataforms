#!/usr/bin/env pwsh

# Script para actualizar y construir la aplicación
# Autor: Generado automáticamente
# Fecha: $(Get-Date)

Write-Host "=== Actualizando proyecto ===" -ForegroundColor Green

# 1. Obtener los últimos cambios del repositorio
Write-Host "Descargando últimos cambios..." -ForegroundColor Yellow
git pull origin master

if ($LASTEXITCODE -ne 0) {
    Write-Host "Error al actualizar el repositorio" -ForegroundColor Red
    exit 1
}

# 2. Instalar dependencias del frontend
Write-Host "Instalando dependencias del frontend..." -ForegroundColor Yellow
npm install

if ($LASTEXITCODE -ne 0) {
    Write-Host "Error al instalar dependencias del frontend" -ForegroundColor Red
    exit 1
}

# 3. Instalar dependencias del backend
Write-Host "Instalando dependencias del backend..." -ForegroundColor Yellow
Set-Location backend
npm install
Set-Location ..

if ($LASTEXITCODE -ne 0) {
    Write-Host "Error al instalar dependencias del backend" -ForegroundColor Red
    exit 1
}

# 4. Construir el backend
Write-Host "Construyendo el backend..." -ForegroundColor Yellow
Set-Location backend
npm run build

if ($LASTEXITCODE -ne 0) {
    Write-Host "Error al construir el backend" -ForegroundColor Red
    exit 1
}

Set-Location ..

# 5. Construir la aplicación Tauri
Write-Host "Construyendo la aplicación..." -ForegroundColor Yellow
npm run tauri build

if ($LASTEXITCODE -ne 0) {
    Write-Host "Error al construir la aplicación Tauri" -ForegroundColor Red
    exit 1
}

# 6. Mostrar ubicación del instalador
Write-Host "=== ¡Construcción completada! ===" -ForegroundColor Green
Write-Host "El instalador se encuentra en:" -ForegroundColor Cyan
Write-Host "src-tauri\target\release\bundle\msi\" -ForegroundColor White

# Listar archivos .msi disponibles
$msiFiles = Get-ChildItem -Path "src-tauri\target\release\bundle\msi\" -Filter "*.msi" -ErrorAction SilentlyContinue
if ($msiFiles) {
    Write-Host "Instaladores disponibles:" -ForegroundColor Cyan
    foreach ($file in $msiFiles) {
        Write-Host "  - $($file.Name)" -ForegroundColor White
    }
} else {
    Write-Host "No se encontraron archivos .msi" -ForegroundColor Yellow
}

Write-Host "`n¡Listo para usar!" -ForegroundColor Green
