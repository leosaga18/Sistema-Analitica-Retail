import pandas as pd
import numpy as np
import pyodbc

# 1. Conexión y extracción de tus datos desde SQL Server
server = r'DESKTOP-1BC2GUF\SQLEXPRESS'
database = 'Ecommerce_Analytics'
conn_str = f"DRIVER={{ODBC Driver 17 for SQL Server}};SERVER={server};DATABASE={database};Trusted_Connection=yes;"

df = pd.read_sql("SELECT * FROM vw_ConsolidadoAnalitico", pyodbc.connect(conn_str))

# Para el ejercicio, tomamos solo las primeras 6 filas para que sea fácil ver el cambio
# df = df.head(6).copy()  para el ejercicio de Tableau tomaremos todas nuevamente

# -------------------------------------------------------------------
# ⚙️ SIMULACIÓN DE DATOS CORRUPTOS DINÁMICA (Ajustada a las 19 filas)
# -------------------------------------------------------------------
# Usamos np.resize para repetir nuestra lista de comentarios basura a lo largo de todas las filas del DataFrame
comentarios_basura = ['  Excelente producto  ', ' MAL SERVICIO ', 'Todo OK', np.nan, '   bien   ', 'PÉSIMO ']
df['Comentarios_Cliente'] = np.resize(comentarios_basura, len(df))

# Hacemos lo mismo con los descuentos simulados
descuentos_basura = [10.5, np.nan, 5.0, np.nan, 15.0, np.nan]
df['Descuento_Aplicado'] = np.resize(descuentos_basura, len(df))

# -------------------------------------------------------------------
# 🛠️ PROCESO DE INGENIERÍA DE LIMPIEZA
# -------------------------------------------------------------------

# Tarea A: Contar cuántos nulos (vacíos) tenemos por columna antes de avanzar
print(f"🔍 Conteo de valores nulos iniciales:\n{df.isnull().sum()}\n")
print("-" * 70)

# Tarea B: Eliminar espacios invisibles al inicio y al final de los textos (.strip())
df['Comentarios_Cliente'] = df['Comentarios_Cliente'].str.strip()

# Tarea C: Convertir todo a MAYÚSCULAS para estandarizar bases de datos
df['Comentarios_Cliente'] = df['Comentarios_Cliente'].str.upper()

# Tarea D: Imputación de Textos (Reemplazar nulos por un valor estándar)
df['Comentarios_Cliente'] = df['Comentarios_Cliente'].fillna('SIN COMENTARIOS')

# Tarea E: Imputación Numérica (Reemplazar descuentos vacíos por un 0.0 estándar)
df['Descuento_Aplicado'] = df['Descuento_Aplicado'].fillna(0.0)

# -------------------------------------------------------------------
# 🏁 RESULTADO FINAL
# -------------------------------------------------------------------
print("✅ 2. DATOS IMPECABLES (Después de la limpieza de Pandas):")
print(df[['Nombre Cliente', 'Comentarios_Cliente', 'Descuento_Aplicado']].to_string(index=False))

# -------------------------------------------------------------------
# 📦 EXPORTACIÓN DE LOS RESULTADOS (Data Delivery)
# -------------------------------------------------------------------
print("\n📦 Exportando datos limpios a archivos locales...")

# 1. Exportar a CSV (Ideal para sistemas masivos o bases de datos)
df.to_csv('Reporte_Ventas_Limpio.csv', index=False, encoding='utf-8-sig')

# 2. Exportar a Excel (Ideal para los directivos o el equipo de negocio)
# Nota: Para esto instalaremos rápidamente una pequeña librería de soporte
df.to_excel('Reporte_Ventas_Limpio.xlsx', index=False)

print("💾 ¡Archivos 'Reporte_Ventas_Limpio.csv' y '.xlsx' guardados con éxito en tu carpeta!")