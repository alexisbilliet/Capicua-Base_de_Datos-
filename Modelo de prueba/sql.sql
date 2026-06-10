CREATE DATABASE TiendaOnline;
USE TiendaOnline;

CREATE TABLE Productos (
    ID INT PRIMARY KEY,
    NombreProducto VARCHAR(50),
    Descripcion VARCHAR(100),
    Precio DECIMAL(10,2),
    StockDisponible INT
);

CREATE TABLE Clientes (
    ID INT PRIMARY KEY,
    Nombre VARCHAR(25),
    Apellido VARCHAR(25),
    CorreoElectronico VARCHAR(100),
    Direccion VARCHAR(25)
);

CREATE TABLE Pedidos (
    ID INT PRIMARY KEY,
    ID_Cliente INT,
    FechaPedido DATE,
    EstadoPedido VARCHAR(25),
    FOREIGN KEY (ID_Cliente) REFERENCES Clientes(ID)
);

INSERT INTO Productos VALUES
(1, 'Mouse Gamer', 'Mouse RGB', 15000.00, 20),
(2, 'Teclado', 'Teclado mecanico', 30000.00, 15),
(3, 'Auriculares', 'Auriculares con microfono', 7500.00, 30),
(4, 'Monitor', 'Monitor Full HD', 200000.00, 10),
(5, 'Webcam', 'Webcam HD', 20000.00, 25);

INSERT INTO Clientes VALUES
(1, 'Sharon', 'Gimenez', 'Sharito.gimenezet32@gmail.com', 'Loyola 2323'),
(2, 'Santiago', 'Fidani', 'Santiago.fidaniet32@gmail.com', 'Av. San Martin'),
(3, 'Agustin', 'Barrionuevo', 'Agustin.barrionuevoet32@gmail.com', 'Loyola 2523'),
(4, 'Alexis', 'Billiet', 'Alexis.billietet32@gmail.com', 'mosconi 2727'),
(5, 'Elena', 'Martinez', 'Elena.martinezet32@gmail.com', 'Villa bosh');

INSERT INTO Pedidos VALUES
(1, 1, '2026-05-01', 'Entregado'),
(2, 2, '2026-05-10', 'Pendiente'),
(3, 3, '2026-05-15', 'Entregado'),
(4, 4, '2026-05-20', 'Enviado'),
(5, 5, '2026-05-25', 'Pendiente');

SELECT NombreProducto, Precio
FROM Productos
WHERE Precio > 50;

SELECT Clientes.Nombre, Clientes.Apellido
FROM Clientes
INNER JOIN Pedidos
ON Clientes.ID = Pedidos.ID_Cliente;

SELECT Clientes.Nombre, Pedidos.FechaPedido
FROM Clientes
INNER JOIN Pedidos
ON Clientes.ID = Pedidos.ID_Cliente
WHERE Pedidos.EstadoPedido = 'Entregado';

SELECT Pedidos.EstadoPedido, Clientes.CorreoElectronico
FROM Clientes
INNER JOIN Pedidos
ON Clientes.ID = Pedidos.ID_Cliente;

SELECT Clientes.Nombre, Pedidos.FechaPedido
FROM Clientes
INNER JOIN Pedidos
ON Clientes.ID = Pedidos.ID_Cliente
ORDER BY Pedidos.FechaPedido DESC
LIMIT 1;

SELECT Clientes.Nombre, Pedidos.FechaPedido, Pedidos.EstadoPedido
FROM Clientes
INNER JOIN Pedidos
ON Clientes.ID = Pedidos.ID_Cliente
WHERE Pedidos.EstadoPedido = 'Pendiente';

SELECT NombreProducto, Precio
FROM Productos
ORDER BY Precio DESC
LIMIT 1;
