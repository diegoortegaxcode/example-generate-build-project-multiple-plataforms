import React, {useEffect, useState} from 'react'

const apiUrl = import.meta.env.VITE_API_URL ?? 'http://127.0.0.1:4000'

export default function App() {
  const [status, setStatus] = useState('loading')

  useEffect(() => {
    const checkHealth = async () => {
      try {
        const response = await fetch(`${apiUrl}/health`);
        const data = await response.json();
        setStatus(JSON.stringify(data));
      } catch (e) {
        setStatus('error: ' + (e as Error).message);
      }
    };

    // Esperar un poco para que el backend inicie
    const timer = setTimeout(checkHealth, 2000);
    return () => clearTimeout(timer);
  }, [])

  return (
    <div style={{padding: 24, fontFamily: 'Inter, system-ui'}}>
      <h1>Tauri + Vite + Nest + Prisma (example)</h1>
      <p>API: <code>{apiUrl}</code></p>
      <h3>Health: {status}</h3>
    </div>
  )
}
