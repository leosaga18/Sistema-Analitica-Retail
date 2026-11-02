@echo off
chcp 65001 > nul

echo 🚀 INICIANDO PIPELINE AUTOMATIZADO DE RETAIL & CHURN...
echo --------------------------------------------------

:: 1. Nos paramos de forma segura en la carpeta donde está este archivo .bat
cd /d "%~dp0"

:: 2. Activar el entorno virtual de Python
echo 🔐 Activando entorno virtual seguro (venv)...
call venv\Scripts\activate.bat

:: 3. Ejecutar los scripts en orden secuencial
echo 🛠️ 1. Ejecutando limpieza y procesamiento de datos...
python 02_limpieza_datos.py

echo 📊 2. Generando metricas y analisis de correlacion...
python 03_analisis_estadistico.py

echo 🚨 3. Analizando Fuga de Ingresos y Alertas de Churn...
python 04_alerta_churn.py

echo --------------------------------------------------
echo ✅ ¡PIPELINE COMPLETO EJECUTADO CON ÉXITO!
echo 💾 Los reportes comerciales y de alertas han sido actualizados.
pause
