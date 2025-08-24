#![cfg_attr(
  all(not(debug_assertions), target_os = "windows"),
  windows_subsystem = "windows"
)]

use tauri::{Manager, api::process::{Command, CommandEvent}};
use std::time::Duration;
use std::sync::atomic::{AtomicBool, Ordering};
use std::sync::Arc;

fn main() {
  tauri::Builder::default()
    .setup(|app| {
      let app_handle = app.handle();
      let backend_ready = Arc::new(AtomicBool::new(false));
      let backend_ready_clone = backend_ready.clone();
      
      println!("Iniciando backend sidecar...");
      
      match Command::new_sidecar("my-backend") {
        Ok(command) => {
          match command.spawn() {
            Ok((mut rx, command_child)) => {
              println!("Backend process iniciado correctamente");
              
              let app_handle_clone = app_handle.clone();
              tauri::async_runtime::spawn(async move {
                let mut attempts = 0u16;
                let max_attempts = 120; // 30 segundos
                
                tokio::time::sleep(Duration::from_millis(1000)).await;
                
                loop {
                  if attempts >= max_attempts {
                    println!("Backend no respondió después de {} intentos", max_attempts);
                    break;
                  }
                  
                  match reqwest::get("http://127.0.0.1:4000/health").await {
                    Ok(resp) => {
                      if resp.status().is_success() {
                        println!("Backend está listo!");
                        backend_ready_clone.store(true, Ordering::Relaxed);
                        
                        if let Some(w) = app_handle_clone.get_window("main") {
                          let _ = w.emit("backend-ready", {});
                        }
                        break;
                      }
                    }
                    Err(e) => {
                      if attempts % 20 == 0 {
                        println!("Esperando backend... intento {}/{}: {}", attempts + 1, max_attempts, e);
                      }
                    }
                  }
                  
                  attempts += 1;
                  tokio::time::sleep(Duration::from_millis(250)).await;
                }
              });
              
              tauri::async_runtime::spawn(async move {
                while let Some(event) = rx.recv().await {
                  if let CommandEvent::Terminated(_) = event {
                    println!("Backend process terminado");
                    break;
                  }
                }
              });
            }
            Err(e) => println!("Error spawning backend: {}", e),
          }
        }
        Err(e) => println!("Error creating backend command: {}", e),
      }
      
      Ok(())
    })
    .run(tauri::generate_context!())
    .expect("error while running tauri application");
}
