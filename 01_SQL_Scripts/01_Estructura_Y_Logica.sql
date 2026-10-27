-- 1. Crear la base de datos
CREATE DATABASE Ecommerce_Analytics;
GO

USE Ecommerce_Analytics;
GO

-- 2. Crear tabla Clientes
CREATE TABLE Clientes (
    Id_cliente INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Fecha_registro DATETIME DEFAULT GETDATE()
);

-- 3. Crear tabla Productos
CREATE TABLE Productos (
    Id_producto INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(150) NOT NULL,
    Precio DECIMAL(10,2) NOT NULL,
    Stock INT NOT NULL
);

-- 4. Crear tabla Ventas (Encabezado)
CREATE TABLE Ventas (
    Id_venta INT IDENTITY(1,1) PRIMARY KEY,
    Id_cliente INT FOREIGN KEY REFERENCES Clientes(Id_cliente),
    Fecha_venta DATETIME DEFAULT GETDATE()
);

-- 5. Crear tabla DetallesVentas
CREATE TABLE DetallesVentas (
    Id_detalle INT IDENTITY(1,1) PRIMARY KEY,
    Id_venta INT FOREIGN KEY REFERENCES Ventas(Id_venta),
    Id_producto INT FOREIGN KEY REFERENCES Productos(Id_producto),
    Cantidad INT NOT NULL,
    Precio_unitario DECIMAL(10,2) NOT NULL
);
GO

-- 6. Insertar algunos productos para la prueba
INSERT INTO Productos (Nombre, Precio, Stock) VALUES 
('Laptop Pro 15', 1200.00, 10),
('Mouse Inalámbrico', 35.00, 50),
('Monitor 4K 27', 450.00, 15);
INSERT INTO Clientes (Nombre, Email) VALUES 
('Carlos Mendoza', 'carlos@email.com');
GO

SELECT * FROM Productos;
SELECT * FROM Clientes;

-------------------------------------------------------------------


--Tu Reto Práctico de Hoy (Viernes): El Procedimiento con Transacción

--Con las tablas creadas, tu misión para las horas restantes de hoy es escribir el Procedimiento Almacenado sp_RegistrarVenta.
--Este procedimiento debe recibir tres parámetros: @Id_cliente, @Id_producto y @Cantidad. Debe hacer lo siguiente de forma segura:
--1. Iniciar una transacción (BEGIN TRANSACTION).
--2. Buscar el precio actual del producto en la tabla Productos para guardarlo en una variable (así evitas que el cliente pague un precio desactualizado).
--3. Insertar en la tabla Ventas para generar el Id_venta.
--4. Insertar en DetallesVentas usando el Id_venta recién generado y el precio que encontraste.
--5. Restar la cantidad del Stock en la tabla Productos (¡Control de inventario!).
--6. Si todo sale bien, guardar los cambios (COMMIT). Si ocurre un error (por ejemplo, si no hay suficiente stock o el cliente no existe), deshacer todo (ROLLBACK) usando un bloque TRY...CATCH.
--¡Ejecuta el código de las tablas en tu SQL Server y ponte manos a la obra con el procedimiento!
--• ¿Cómo planeas capturar el precio del producto dentro del procedimiento almacenado utilizando variables en SQL Server?
--• Si te trancas en alguna parte del código con el BEGIN TRY o el SCOPE_IDENTITY(), compárteme lo que lleves escrito y lo pulimos juntos.

--Solución:

CREATE OR ALTER PROC sp_RegistrarVenta
    @Id_cliente INT,
    @Id_producto INT,
    @Cantidad INT
AS
BEGIN
    -- Declaramos variables internas para el negocio
    DECLARE @PrecioActual DECIMAL(10,2);
    DECLARE @StockActual INT;
    DECLARE @Id_venta INT;

    BEGIN TRANSACTION;

    BEGIN TRY
        -- 1. Obtenemos el precio y el stock actual del producto seleccionado
        SELECT @PrecioActual = Precio, @StockActual = Stock 
        FROM Productos 
        WHERE Id_producto = @Id_producto;

        -- 2. Validación de Negocio: Si no hay suficiente stock, forzamos un error
        IF @StockActual < @Cantidad
        BEGIN
            RAISERROR('No hay suficiente stock disponible para realizar la venta.', 16, 1);
        END

        -- 3. Insertar en la tabla Ventas (Encabezado)
        INSERT INTO Ventas (Id_cliente, Fecha_venta)
        VALUES (@Id_cliente, GETDATE());

        -- Capturamos el ID recién generado para la venta
        SET @Id_venta = SCOPE_IDENTITY();

        -- 4. Insertar en DetallesVentas usando las variables y parámetros
        INSERT INTO DetallesVentas (Id_venta, Id_producto, Cantidad, Precio_unitario)
        VALUES (@Id_venta, @Id_producto, @Cantidad, @PrecioActual); 

        -- 5. Control de Inventario: Restamos la cantidad exacta vendida
        UPDATE Productos
        SET Stock = Stock - @Cantidad
        WHERE Id_producto = @Id_producto;

        -- Si todo salió bien, guardamos los cambios permanentemente
        COMMIT TRANSACTION;
        PRINT '¡Venta completada con éxito!';

    END TRY
    BEGIN CATCH
        -- Si algo falló en cualquier paso, revertimos todo al estado inicial
        ROLLBACK TRANSACTION; 
        
        PRINT '==================================================';
        PRINT '🚨 ¡TRANSACCIÓN CANCELADA Y REVERTIDA! 🚨';
        PRINT 'Motivo real del fallo: '+  + ERROR_MESSAGE();
        PRINT ' - Stock disponible actual: ' + CONVERT(VARCHAR, @StockActual);
        PRINT '==================================================';
    END CATCH
END;
GO
  
  --pasá datos reales con el comando EXEC
EXEC sp_RegistrarVenta @Id_cliente = 1, @Id_producto = 1, @Cantidad =2;

SELECT * FROM Productos;
SELECT * FROM DetallesVentas; 
SELECT * FROM Ventas; 

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

