# Sistema de Analítica de Retail & E-Commerce

## 📝 Descripción del Proyecto
Este proyecto despliega una solución integral de datos para una plataforma de comercio electrónico. Abarca desde el diseño de la base de datos relacional y la programación de lógica de negocio transaccional en el servidor, hasta la extracción, transformación (ETL) y visualización avanzada de indicadores clave de rendimiento (KPIs) financieros.

## 🛠️ Tecnologías Utilizadas
* **Base de Datos:** SQL Server (Transact-SQL)
* **ETL & Modelado:** Power Query (Lenguaje M) & DAX
* **Visualización:** Power BI Desktop
* **Control de Versiones:** Git & GitHub

## 📐 Arquitectura de la Solución

### 1. Ingeniería de Datos (SQL Server)
* **Modelo Relacional:** Diseño normalizado con tablas de Clientes, Productos, Ventas y Detalles de Ventas.
* **Lógica Transaccional:** Creación del procedimiento almacenado `sp_RegistrarVenta` con bloques `TRY...CATCH` y transacciones (`COMMIT`/`ROLLBACK`) para garantizar la integridad del stock de inventario.
* **Capa Analítica:** Diseño de la vista `vw_ConsolidadoAnalitico` para precalcular métricas complejas en el servidor (Ingresos y Ticket Promedio) optimizando el rendimiento.

### 2. Business Intelligence (Power BI)
* **Modelo en Estrella:** Conexión híbrida a SQL Server y combinación con metas comerciales externas (.CSV) a través de Power Query.
* **Inteligencia de Tiempo:** Creación de una tabla de calendario nativa en DAX para análisis temporales continuos.
* **Métricas Clave (DAX):**
  * `Total Ventas`: Ingresos financieros consolidados.
  * `Ventas Mes Anterior`: Cálculo dinámico de periodos previos mediante funciones de filtrado.
  * `Crecimiento Ventas MoM %`: Indicador porcentual de variación de rendimiento mes a mes.

## 📊 Dashboard Visual (UI/UX)
El reporte final implementa un diseño oscuro de alto impacto visual (Estilo Web App) con bordes suavizados a 12px, sombras paralelas y navegación intuitiva para la toma de decisiones directivas.
