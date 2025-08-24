NOTAS IMPORTANTES DE EMPAQUETADO (Prisma + pkg)
----------------------------------------------
- Prisma incluye motores nativos (query engines) en node_modules/.prisma/client.
  Si vas a usar `pkg` para empaquetar el backend, debes incluir esos archivos como assets
  y configurar `binaryTargets` en schema.prisma para los targets de tu build (linux, macos, windows).
- Alternativa: dejar la carpeta dist (JS) y distribuir junto al runtime Node en el instalador,
  o generar el binario en CI para cada plataforma y copiarlo a `src-tauri/binaries`.

REFERENCIAS / COMPATIBILIDAD
- Tauri 2.0 (stable) — https://v2.tauri.app/
- Vite requiere Node >= 20.19 / 22.12+ — https://vite.dev/guide/
- Prisma v6 requires Node >= 18.18 / 20.9 / 22.11 and TypeScript >= 5.1 — https://www.prisma.io/docs/
- NestJS 11 is the current major series (2025) — https://github.com/nestjs/nest/releases