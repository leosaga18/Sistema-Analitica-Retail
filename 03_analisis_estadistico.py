import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt

# 1. Cargamos el archivo de datos limpios que generaste en el paso anterior
# (Garantizamos que usamos la base de datos completa de 19 filas)
try:
    df = pd.read_excel('Reporte_Ventas_Limpio.xlsx')
    print("✅ Base de datos cargada con éxito para análisis estadístico.\n")
except FileNotFoundError:
    print("🚨 No se encontró el archivo Excel. Asegúrate de correr el script 02 primero.")
    exit()

# -------------------------------------------------------------------
# 📊 1. ANÁLISIS DE CORRELACIÓN MATEMÁTICA (Métrica Senior)
# -------------------------------------------------------------------
print("🧠 CALCULANDO CORRELACIÓN DE PEARSON:")
# Evaluamos la relación numérica entre Descuentos, Cantidad y Total Ingresos
columnas_numericas = ['Total Cantidad Vendida', 'Total Ingresos', 'Descuento_Aplicado']
matriz_correlacion = df[columnas_numericas].corr(method='pearson')

print(matriz_correlacion)
print("\n💡 Interpretación Técnica:")
correlacion_descuento_ingreso = matriz_correlacion.loc['Total Ingresos', 'Descuento_Aplicado']
print(f"-> La correlación entre Ingresos y Descuentos es de: {correlacion_descuento_ingreso:.2f}")
if correlacion_descuento_ingreso > 0.5:
    print("🔥 Conclusión: Existe una fuerte relación positiva. A mayor descuento, los ingresos suben significativamente.")
elif correlacion_descuento_ingreso > 0:
    print("📉 Conclusión: La relación es positiva pero débil. Los descuentos ayudan un poco, pero no son el motor principal.")
else:
    print("🚨 Conclusión: La correlación es negativa. Los descuentos están destruyendo el valor del ingreso total.")
print("-" * 70)

# -------------------------------------------------------------------
# 🎨 2. GRÁFICO ESTADÍSTICO (Distribución de Ingresos por Producto)
# -------------------------------------------------------------------
print("🎨 Generando boxplot estadístico de ingresos...")

# Configuramos un estilo visual moderno y oscuro
plt.style.use('dark_background')
plt.figure(figsize=(10, 6))

# El Boxplot (Gráfico de caja y bigotes) nos muestra la dispersión, mediana y valores atípicos
sns.boxplot(
    data=df, 
    x='Nombre Producto', 
    y='Total Ingresos', 
    palette='pastel',
    hue='Nombre Producto',
    legend=False
)

# Estética Premium del gráfico
plt.title('Dispersión y Distribución Financiera de Ingresos por Producto', fontsize=14, fontweight='bold', pad=15)
plt.xlabel('Catálogo de Productos', fontsize=12)
plt.ylabel('Total Ingresos ($)', fontsize=12)
plt.xticks(rotation=15)
plt.grid(axis='y', linestyle='--', alpha=0.3)

# Mostrar el gráfico en pantalla
print("🖥️ Abriendo ventana del gráfico estadístico...")
plt.tight_layout()
plt.show()