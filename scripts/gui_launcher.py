import tkinter as tk
from tkinter import ttk, messagebox
import subprocess
import os
import sys
import threading
import queue
import time
import signal
import psutil

class ScriptLauncher:
    def __init__(self, root):
        self.root = root
        self.root.title("Keeptoken Script Launcher")
        self.root.geometry("800x800")
        
        # Cola para la comunicación entre hilos
        self.output_queue = queue.Queue()
        self.active_processes = {}
        self.server_process = None
        
        # Estilo
        self.style = ttk.Style()
        self.style.configure('TButton', padding=5)
        self.style.configure('TLabel', padding=5)
        
        # Frame principal
        main_frame = ttk.Frame(root, padding="10")
        main_frame.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))
        
        # Título
        title_label = ttk.Label(main_frame, text="Keeptoken Script Launcher", font=('Arial', 14, 'bold'))
        title_label.grid(row=0, column=0, columnspan=2, pady=10)
        
        # Frame para los botones
        button_frame = ttk.Frame(main_frame)
        button_frame.grid(row=1, column=0, columnspan=2, pady=10)
        
        # Botones para cada script
        scripts = [
            ("Iniciar Servidor", "start_server.ps1", self.toggle_server),
            ("Inicializar Base de Datos", "init_db.ps1", None),
            ("Realizar Backup", "backup.ps1", None),
            ("Restaurar Backup", "restore_backup.ps1", None),
            ("Backup Git", "git_backup.ps1", None)
        ]
        
        self.buttons = {}
        for i, (text, script, command) in enumerate(scripts, start=1):
            if command:
                btn = ttk.Button(
                    button_frame,
                    text=text,
                    command=lambda s=script, c=command: c(s)
                )
            else:
                btn = ttk.Button(
                    button_frame,
                    text=text,
                    command=lambda s=script: self.run_script(s)
                )
            btn.grid(row=i, column=0, columnspan=2, pady=5, sticky=(tk.W, tk.E))
            self.buttons[script] = btn
        
        # Área de log con scroll
        log_frame = ttk.Frame(main_frame)
        log_frame.grid(row=2, column=0, columnspan=2, pady=10, sticky=(tk.W, tk.E, tk.N, tk.S))
        
        self.log_text = tk.Text(log_frame, height=25, width=90)
        self.log_text.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))
        
        scrollbar = ttk.Scrollbar(log_frame, orient="vertical", command=self.log_text.yview)
        scrollbar.grid(row=0, column=1, sticky=(tk.N, tk.S))
        self.log_text.configure(yscrollcommand=scrollbar.set)
        
        # Botones de control
        control_frame = ttk.Frame(main_frame)
        control_frame.grid(row=3, column=0, columnspan=2, pady=5)
        
        clear_btn = ttk.Button(control_frame, text="Limpiar Log", command=self.clear_log)
        clear_btn.grid(row=0, column=0, padx=5)
        
        # Configurar el grid para que el log se expanda
        main_frame.columnconfigure(0, weight=1)
        main_frame.rowconfigure(2, weight=1)
        log_frame.columnconfigure(0, weight=1)
        log_frame.rowconfigure(0, weight=1)
        
        # Iniciar el hilo para actualizar el log
        self.update_log_thread = threading.Thread(target=self.update_log, daemon=True)
        self.update_log_thread.start()
    
    def toggle_server(self, script_name):
        if script_name in self.active_processes:
            self.stop_script(script_name)
        else:
            self.run_script(script_name)
    
    def stop_script(self, script_name):
        if script_name in self.active_processes:
            process = self.active_processes[script_name]
            try:
                # Detener el proceso y sus hijos
                parent = psutil.Process(process.pid)
                children = parent.children(recursive=True)
                
                # Detener primero los procesos hijos
                for child in children:
                    try:
                        child.terminate()
                    except:
                        pass
                
                # Esperar a que los hijos terminen
                gone, alive = psutil.wait_procs(children, timeout=3)
                for p in alive:
                    p.kill()
                
                # Detener el proceso principal
                parent.terminate()
                parent.wait(timeout=3)
                
                self.output_queue.put(f"\nDeteniendo {script_name}...\n")
                self.buttons[script_name].configure(text="Iniciar Servidor")
                del self.active_processes[script_name]
                
            except Exception as e:
                self.output_queue.put(f"\nError al detener {script_name}: {str(e)}\n")
                try:
                    process.kill()
                except:
                    pass
    
    def run_script(self, script_name):
        try:
            # Obtener la ruta del script
            script_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), script_name)
            
            # Crear un nuevo hilo para ejecutar el script
            thread = threading.Thread(
                target=self._run_script_thread,
                args=(script_path, script_name),
                daemon=True
            )
            thread.start()
            
            if script_name == "start_server.ps1":
                self.buttons[script_name].configure(text="Detener Servidor")
            
        except Exception as e:
            self.output_queue.put(f"\nError: {str(e)}\n")
            messagebox.showerror("Error", f"Error al ejecutar {script_name}")
    
    def _run_script_thread(self, script_path, script_name):
        try:
            # Ejecutar el script en un proceso separado
            process = subprocess.Popen(
                ["powershell", "-ExecutionPolicy", "Bypass", "-File", script_path],
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                text=True,
                creationflags=subprocess.CREATE_NO_WINDOW
            )
            
            # Guardar el proceso para poder detenerlo después
            self.active_processes[script_name] = process
            
            # Leer la salida en tiempo real
            while True:
                output = process.stdout.readline()
                if output == '' and process.poll() is not None:
                    break
                if output:
                    self.output_queue.put(output)
            
            # Verificar si hubo errores
            if process.returncode != 0:
                error = process.stderr.read()
                self.output_queue.put(f"\nError: {error}\n")
                self.root.after(0, lambda: messagebox.showerror("Error", f"Error al ejecutar {os.path.basename(script_path)}"))
            
            # Limpiar el proceso si se completó
            if script_name in self.active_processes:
                del self.active_processes[script_name]
                if script_name == "start_server.ps1":
                    self.root.after(0, lambda: self.buttons[script_name].configure(text="Iniciar Servidor"))
            
        except Exception as e:
            self.output_queue.put(f"\nError: {str(e)}\n")
            self.root.after(0, lambda: messagebox.showerror("Error", f"Error al ejecutar {os.path.basename(script_path)}"))
    
    def update_log(self):
        while True:
            try:
                # Obtener mensajes de la cola
                while not self.output_queue.empty():
                    message = self.output_queue.get_nowait()
                    self.log_text.insert(tk.END, message)
                    self.log_text.see(tk.END)
            except queue.Empty:
                pass
            
            # Actualizar la interfaz
            self.root.update_idletasks()
            time.sleep(0.1)
    
    def clear_log(self):
        self.log_text.delete(1.0, tk.END)

if __name__ == "__main__":
    root = tk.Tk()
    app = ScriptLauncher(root)
    root.mainloop() 