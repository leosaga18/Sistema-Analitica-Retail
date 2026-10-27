--Ejercicio de Analítica y Business Intelligence JOINs, Funciones Agregadas y GROUP BY.
--Paso 1: Inserción Masiva de Datos (Volumen Real)
--Para que nuestros reportes visuales tengan sentido, necesitamos volumen de datos. Borra tu pantalla en tu gestor de base de datos, copia este script y ejecútalo (con Alt + X o seleccionando todo y ejecutando) para meter más clientes, productos y simular compras usando el procedimiento almacenado que creamos:

USE Ecommerce_Analytics;
GO

-- 1. Insertar más clientes de prueba
INSERT INTO Clientes (Nombre, Email) VALUES 
('Ana Martínez', 'ana.m@email.com'),
('Luis Rodríguez', 'luis.r@email.com'),
('María Elena Gómez', 'maria.g@email.com'),
('Javier López', 'javier.l@email.com');

-- 2. Insertar más productos con suficiente stock
INSERT INTO Productos (Nombre, Precio, Stock) VALUES 
('Teclado Mecánico RGB', 85.00, 100),
('Audífonos HyperX', 120.00, 80),
('Silla Ergonómica Pro', 299.00, 40),
('Cargador Carga Rápida', 25.00, 200);
GO

-- 3. Simular transacciones exitosas con nuestro procedimiento
EXEC sp_RegistrarVenta @Id_cliente = 1, @Id_producto = 1, @Cantidad = 1; -- Carlos compra 1 Laptop
EXEC sp_RegistrarVenta @Id_cliente = 2, @Id_producto = 4, @Cantidad = 2; -- Ana compra 2 Teclados
EXEC sp_RegistrarVenta @Id_cliente = 3, @Id_producto = 5, @Cantidad = 1; -- Luis compra 1 Audífono
EXEC sp_RegistrarVenta @Id_cliente = 4, @Id_producto = 6, @Cantidad = 1; -- María compra 1 Silla
EXEC sp_RegistrarVenta @Id_cliente = 1, @Id_producto = 7, @Cantidad = 3; -- Carlos compra 3 Cargadores
EXEC sp_RegistrarVenta @Id_cliente = 2, @Id_producto = 1, @Cantidad = 1; -- Ana compra 1 Laptop
GO

SELECT * FROM Clientes;
--Tu Reto del Sábado: Diseñar la "Vista Maestro de Ventas"

--Las herramientas como Power BI o Tableau funcionan mucho mejor cuando les entregas una Vista (VIEW) consolidada que haga los cálculos matemáticos pesados en el servidor SQL, en lugar de obligar al software visual a procesar millones de filas.
--Tu misión es crear una vista llamada vw_ConsolidadoAnalitico. Aplicando lo que aprendiste sobre JOINs, Funciones Agregadas y GROUP BY, esta vista debe mostrar una fila por cada combinación de Cliente y Producto con las siguientes columnas:
--1. Id_cliente y NombreCliente.
--2. Id_producto y NombreProducto.
--3. TotalCantidadVendida (Suma de la cantidad).
--4. TotalIngresos (Suma de la multiplicación de Cantidad * Precio_unitario).
--5. Métrica Avanzada: TicketPromedioPorProducto (Total de ingresos dividido entre el conteo de ventas de ese producto).


CREATE OR ALTER VIEW vw_ConsolidadoAnalitico AS
SELECT
	C.Id_cliente AS [ID Cliente],
	C.Nombre AS [Nombre Cliente],
	P.Id_producto AS [ID Producto],
	P.Nombre AS [Nombre Producto],
	V.Fecha_venta AS [Fecha Venta],
	SUM (D.Cantidad) AS [Total Cantidad Vendida],
	SUM (D.Cantidad*D.Precio_unitario) AS [Total Ingresos],
	CAST(AVG(D.Cantidad * D.Precio_unitario) AS DECIMAL(18,2)) AS [Ticket Promedio Por Producto]
FROM DetallesVentas D
	INNER JOIN Ventas V ON V.Id_venta = D.Id_venta
	INNER JOIN Clientes C ON C.Id_cliente =V.Id_cliente 
	INNER JOIN Productos P ON D.Id_producto = P.Id_producto
GROUP BY
	C.Id_cliente,
	C.Nombre,
	P.Id_producto,
	P.Nombre,
	V.Fecha_venta;

select * FROM vw_ConsolidadoAnalitico;



WITH CTE_Duplicados AS (
    SELECT 
        [Nombre Cliente], 
        [Total Ingresos],
        ROW_NUMBER() OVER (
            PARTITION BY [Nombre Cliente], [Total Ingresos] -- Columnas que identifican el duplicado
            ORDER BY (SELECT NULL)          -- O usa una columna de fecha/ID para decidir cuál conservar
        ) AS NumeroFila
    FROM vw_ConsolidadoAnalitico
)
DELETE FROM CTE_Duplicados
WHERE NumeroFila > 1;