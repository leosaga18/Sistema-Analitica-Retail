@echo off
chcp 65001 > nul

echo 🚀 INICIANDO PIPELINE AUTOMATIZADO DE RETAIL...
echo --------------------------------------------------

:: 1. Nos paramos de forma segura en la carpeta donde está este archivo .bat
:: Al envolverlo entre comillas, solucionamos CUALQUIER espacio en la ruta
cd /d "%~dp0"

:: 2. Activar el entorno virtual de Python
echo 🔐 Activando entorno virtual seguro (venv)...
call venv\Scripts\activate.bat

:: 3. Ejecutar los scripts llamándolos directamente por su nombre
echo 🛠️ Ejecutando limpieza y procesamiento de datos...
python 02_limpieza_datos.py

echo 📊 Generando metricas y analisis de correlacion...
python 03_analisis_estadistico.py

echo --------------------------------------------------
echo ✅ ¡PIPELINE EJECUTADO CON ÉXITO!
echo 💾 Los archivos Excel y CSV han sido actualizados.
pause

