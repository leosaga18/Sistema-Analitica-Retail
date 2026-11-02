import pandas as pd
import pyodbc
import os

# 1. Configuración de conexión con el motor SQL local
server = r'.\SQLEXPRESS'
database = 'Ecommerce_Analytics'
conn_str = f"DRIVER={{ODBC Driver 17 for SQL Server}};SERVER={server};DATABASE={database};Trusted_Connection=yes;"

try:
    print("⏳ Conectando al servidor para extraer diagnóstico de Churn...")
    # Extraemos directamente los datos precalculados de tu nueva vista SQL
    df_churn = pd.read_sql("SELECT * FROM vw_DiagnosticoChurn", pyodbc.connect(conn_str))
    
    # -------------------------------------------------------------------
    # 🔍 FILTRADO Y SEGMENTACIÓN AVANZADA (Pandas Senior)
    # -------------------------------------------------------------------
    # Filtramos para quedarnos ÚNICAMENTE con las filas que dispararon la alerta roja
    df_clientes_riesgo = df_churn[df_churn['Estado del Cliente'] == 'ALERTA: CLIENTE EN RIESGO DE FUGA'].copy()
    
    print(f"\n📊 Diagnóstico procesado. Se detectaron {len(df_clientes_riesgo)} transacciones en riesgo de fuga.")
    print("-" * 70)
    print(df_clientes_riesgo[['Nombre Cliente', 'Dias Desde La Venta', 'Estado del Cliente']].to_string(index=False))
    print("-" * 70)
    
    # -------------------------------------------------------------------
    # 📦 EXPORTACIÓN AUTOMÁTICA DEL REPORTE DE ACCIÓN
    # -------------------------------------------------------------------
    # Detectamos la ubicación actual del archivo para guardarlo en la raíz de tu portafolio
    carpeta_actual = os.path.dirname(os.path.abspath(__file__))
    ruta_salida = os.path.join(carpeta_actual, 'Clientes_En_Riesgo_Fuga.xlsx')
    
    # Exportamos a Excel sin el índice numérico de Pandas
    df_clientes_riesgo.to_excel(ruta_salida, index=False)
    print(f"💾 ¡Pipeline Terminado! Archivo de acción inmediata generado con éxito en:\n➡️ {ruta_salida}")

except Exception as e:
    print(f"🚨 Error en la ejecución del pipeline: {e}")
