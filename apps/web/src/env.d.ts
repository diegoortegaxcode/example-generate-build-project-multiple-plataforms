// apps/web/src/env.d.ts
/// <reference types="vite/client" />

interface ImportMetaEnv {
  readonly VITE_API_URL?: string
  // añade aquí tus VITE_* si quieres tiparlas estrictas
}

interface ImportMeta {
  readonly env: ImportMetaEnv
}
