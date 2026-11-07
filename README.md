# Sistema de Analítica de Retail & E-Commerce
¡Proyecto Insignia de Automatización, Inteligencia de Negocios y Ciencia de Datos!

## 📝 Descripción del Proyecto
Este proyecto despliega una solución integral de datos para una plataforma de comercio electrónico de nivel empresarial. Abarca desde el diseño de la base de datos relacional y la programación de lógica de negocio transaccional y optimización en el servidor (SQL Server), pasando por procesos autónomos de ingeniería de tuberías y calidad de datos (Python), analítica avanzada de Inteligencia Artificial (Machine Learning), hasta la maquetación y despliegue híbrido de tableros de control ejecutivos (Power BI y Tableau).

## 🛠️ Tecnologías Utilizadas
* **Base de Datos & Tuning:** SQL Server (Transact-SQL) - Funciones de Ventana e Índices No Agrupados.
* **Lenguaje de Programación:** Python 3 (Scripts de Automatización e Ingeniería de Datos).
* **Ciencia de Datos & IA:** Pandas, NumPy y Scikit-Learn (Modelos de Aprendizaje Automático).
* **Visualización Científica:** Matplotlib y Seaborn.
* **ETL & Business Intelligence:** Power Query (Lenguaje M), DAX, Power BI Desktop y Tableau Public.
* **Infraestructura & Data Ops:** Git, GitHub, Entornos Virtuales (`venv`), Shell Scripts de Windows (`.bat`) y Programador de Tareas de Windows.

## 📐 Arquitectura de la Solución

### 1. Ingeniería de Datos & Optimización (SQL Server)
* **Modelo Relacional:** Diseño normalizado con tablas de Clientes, Productos, Ventas y Detalles de Ventas.
* **Lógica Transaccional:** Creación del procedimiento almacenado `sp_RegistrarVenta` blindado con bloques `TRY...CATCH` y transacciones (`COMMIT`/`ROLLBACK`) para garantizar el control automático del stock de inventario.
* **Capa Analítica Basada en Servidor:** Diseño de la vista `vw_ConsolidadoAnalitico` para precalcular métricas complejas en el servidor (Ingresos y Ticket Promedio) reduciendo el consumo en las herramientas de BI.
* **Optimización del Motor (SQL Tuning):** Diseño e implementación de índices no agrupados (`NONCLUSTERED INDEX`) en llaves foráneas y variables de tiempo, garantizando búsquedas masivas a velocidad de rayo.

### 2. Automatización, Calidad de Datos & Ciencia de Datos (Python)
* **Ingeniería de Tuberías (Pipelines):** Conexión segura mediante `pyodbc` a la instancia de SQL Server para extraer datos relacionales hacia DataFrames de Pandas.
* **Calidad de Datos (Data Cleansing):** Automatización de limpieza masiva usando NumPy para imputar valores nulos (`NaN`), estandarizar variables categóricas a mayúsculas y limpiar espacios en blanco (`.strip()`).
* **Análisis Estadístico Avanzado:** Cálculo de matrices de Correlación de Pearson para evaluar el impacto financiero real de las estrategias de precios (`Descuentos` vs `Total Ingresos`).
* **Visualización Científica:** Diseño de gráficos estadísticos avanzados (Boxplots) con Seaborn y Matplotlib bajo estándares de alto contraste para auditorías de negocio.

### 3. Inteligencia de Negocios Agnóstica (Power BI & Tableau)
* **Modelo en Estrella (Power BI):** Conexión híbrida a SQL Server y combinación analítica con metas comerciales externas (`.csv`) a través de Power Query.
* **Inteligencia de Tiempo & Métricas (DAX):** Creación de una tabla de calendario nativa y programación de indicadores de variación de rendimiento (`Total Ventas`, `Ventas Mes Anterior` y `Crecimiento Ventas MoM %`).
* **Panel de Control Visual Premium (UI/UX):** Maquetación de reportes ejecutivos con diseño oscuro elegante (Estilo Web App) con bordes suavizados a 12px, sombras paralelas y visuales interactivos de dispersión de mercado.
* **Despliegue Multiplataforma (Tableau):** Conexión directa a fuentes limpias de Python para generar análisis ágiles basados en hojas de trabajo independientes y distribución por canales directivos.

## 💼 Caso de Estudio Avanzado: Diagnóstico de Churn & Fuga de Ingresos
* **Capa de Servidor (SQL Server):** Creación de la vista avanzada `vw_DiagnosticoChurn` utilizando funciones de cálculo de fechas (`DATEDIFF`) para identificar clientes inactivos con más de 5 días desde su última transacción.
* **Pipeline de Acción (Pandas):** Desarrollo del script `04_alerta_churn.py` para conectarse a la vista, aplicar filtrado flexible de cadenas de texto (`.str.contains()`) y aislar de forma automática a los usuarios en riesgo de fuga.
* **Entregable Comercial:** Exportación automatizada hacia el reporte de negocio de alta prioridad `Clientes_En_Riesgo_Fuga.xlsx` enfocado en estrategias de retención de Customer Success.
* **Estadística Predictiva & Machine Learning (IA):** Implementación de un algoritmo de Clasificación basado en **Árboles de Decisión (`DecisionTreeClassifier`)** mediante la librería `scikit-learn` para predecir de forma autónoma el riesgo de abandono de nuevos usuarios en función de sus patrones de compra.

## ⚙️ Infraestructura de Producción (Data Ops)
* **Orquestación Centralizada:** Diseño del script maestro `run_pipeline.py` encargado de ejecutar de forma secuencial, limpia y ordenada todos los módulos de código utilizando subprocesos del sistema (`subprocess`).
* **Manejo de Errores y Logs:** Implementación de una bitácora automatizada de auditoría (`pipeline_execution.log`) para capturar códigos de salida de error (`stderr`) y estandarización a texto plano compatible con servidores de producción Windows.
* **Despliegue Autónomo Diario:** Configuración de un shell script lanzador `.bat` integrado en el **Programador de Tareas de Windows** para ejecutar de forma silenciosa e independiente toda la tubería de análisis e IA diariamente a las 08:30 AM.

