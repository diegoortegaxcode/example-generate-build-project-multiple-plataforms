import React, {useEffect, useState} from 'react'

const apiUrl = import.meta.env.VITE_API_URL ?? 'http://127.0.0.1:4000'

export default function App() {
  const [status, setStatus] = useState('loading')

  useEffect(() => {
    fetch(`${apiUrl}/health`).then(r => r.json()).then(j => setStatus(JSON.stringify(j))).catch(e => setStatus('error: ' + e.message))
  }, [])

  return (
    <div style={{padding: 24, fontFamily: 'Inter, system-ui'}}>
      <h1>Tauri + Vite + Nest + Prisma (example)</h1>
      <p>API: <code>{apiUrl}</code></p>
      <h3>Health: {status}</h3>
    </div>
  )
}
