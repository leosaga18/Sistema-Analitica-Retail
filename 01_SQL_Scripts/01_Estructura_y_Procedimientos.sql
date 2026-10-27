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
