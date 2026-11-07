import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.tree import DecisionTreeClassifier
from sklearn.metrics import accuracy_score

# 1. Cargamos los datos consolidados que limpiaste en los pasos previos
try:
    df = pd.read_excel('Reporte_Ventas_Limpio.xlsx')
    print("--- Base de datos cargada para entrenamiento de IA.\n")
except FileNotFoundError:
    print("--- Ejecuta el script 02 primero para generar el archivo Excel.")
    exit()

# -------------------------------------------------------------------
# 📊 PREPARACIÓN DE VARIABLES (Features & Target)
# -------------------------------------------------------------------
# Para entrenar a la IA, creamos una columna binaria: 1 si está en riesgo (Fugado), 0 si está activo
# Generamos un histórico aleatorio controlado para el ejercicio
np.random.seed(42)
df['Fugado'] = np.random.choice([0, 1], size=len(df))

# Definimos las variables de entrada (X) y lo que queremos predecir (y)
X = df[['Total Cantidad Vendida', 'Total Ingresos', 'Descuento_Aplicado']]
y = df['Fugado']

# Dividimos los datos de forma estándar: 80% para entrenar el modelo y 20% para evaluarlo
# Ajustamos las muestras de prueba para el volumen de la base de datos
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# -------------------------------------------------------------------
# 🧠 ENTRENAMIENTO DEL MODELO (Machine Learning)
# -------------------------------------------------------------------
print("--- Entrenando el algoritmo de Clasificación (Árbol de Decisión)...")
modelo = DecisionTreeClassifier(random_state=42)
modelo.fit(X_train, y_train)

# Evaluamos la precisión del modelo con los datos de prueba
predicciones = modelo.predict(X_test)
precision = accuracy_score(y_test, predicciones)

print(f"--- Precisión del Modelo Predictivo: {precision * 100:.2f}%")
print("-" * 60)

# 🔮 PREDICCIÓN CON UN CLIENTE NUEVO FICICTIO
# Evaluamos un cliente que compra 1 unidad, gasta $1200 e incluye 15.0 de descuento
cliente_nuevo = [[1, 1200.00, 15.0]]
resultado_prediccion = modelo.predict(cliente_nuevo)

print("--- RESULTADO DE PREDICCIÓN PARA NUEVO CLIENTE:")
if resultado_prediccion[0] == 1:
    print("--- ALERTA MODELO IA: El cliente nuevo muestra patrones de alto riesgo de FUGA.")
else:
    print("--- MODELO IA: El cliente nuevo muestra patrones estables de fidelidad.")
