import subprocess
import os
import sys
from datetime import datetime

# Detectamos la carpeta donde vive este orquestador
BASE_DIR = os.path.dirname(os.path.abspath(__file__))

# Lista secuencial de los scripts que componen nuestra tubería de datos
SCRIPTS = [
    '02_limpieza_datos.py',
    '03_analisis_estadistico.py',
    '04_alerta_churn.py',
    '05_modelo_predictivo.py'
]

def registrar_log(mensaje):
    fecha_actual = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    linea = f"[{fecha_actual}] {mensaje}\n"
    print(linea.strip())
    with open(os.path.join(BASE_DIR, 'pipeline_execution.log'), 'a', encoding='utf-8') as f:
        f.write(linea)

if __name__ == '__main__':
    registrar_log("🚀 INICIANDO EJECUCIÓN DEL PIPELINE MAESTRO...")
    
    # Buscamos el ejecutable de Python de nuestro entorno virtual aislado
    python_executable = sys.executable
    registrar_log(f"🔐 Usando entorno virtual: {python_executable}")

    error_detectado = False

    for script in SCRIPTS:
        script_path = os.path.join(BASE_DIR, script)
        if not os.path.exists(script_path):
            registrar_log(f"🚨 ERROR: No se encontró el archivo: {script}")
            continue

        registrar_log(f"⏳ Ejecutando módulo: {script}...")
        
        # Ejecutamos el script secundario de forma segura
        resultado = subprocess.run([python_executable, script_path], capture_output=True, text=True)

        if resultado.returncode == 0:
            registrar_log(f"✅ Módulo {script} completado con éxito.")
        else:
            registrar_log(f"❌ ERROR en módulo {script}:")
            registrar_log(resultado.stderr)
            error_detectado = True
            break # Detenemos el flujo si un paso crítico falla

    if not error_detectado:
        registrar_log("🏁 ¡PIPELINE COMPLETO EJECUTADO CON ÉXITO! Todos los reportes e IA actualizados.\n")
    else:
        registrar_log("⚠️ PIPELINE ABORTADO debido a fallos en la secuencia de ejecución.\n")
