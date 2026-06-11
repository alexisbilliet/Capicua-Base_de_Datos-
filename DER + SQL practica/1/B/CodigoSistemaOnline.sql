
create database SistemaOnline;
use SistemaOnline;
create table Ventas(
IDVenta int auto_increment primary key not null,
TipoFactura enum('a', 'b', 'c'),
total int(6)  
);
create table Clientes(
IDCliente int auto_increment primary key not null,
Nombre varchar(25),
DNI int(15),
Apellido varchar(25)   
);
create table Vendedores(
IDVendedor int auto_increment primary key not null,
Nombre varchar(25),
VentasRealizadas int(15),
Apellido varchar(25)   
);
create table Pedidos(
IDPedido int auto_increment primary key not null,
Estado enum('Entregado', 'EnProceso', 'Devuelto', 'EnCamino'),
PrecioUnidad int(15) 
);
create table Prendas(
IDPrenda int auto_increment primary key not null,
Tipo varchar(25),
Talle enum('S', 'M', 'L', 'XL', 'XXL', 'XS', 'XXS'),
Color varchar(15) 
);
create table Repartidores(
IDRepartidor int auto_increment primary key not null,
Nombre varchar(25),
Antiguedad int(2),
Apellido varchar(25)   
);
alter table Ventas
add IDVendedor int,
add foreign key (IDVendedor) references Vendedores(IDVendedor),
add IDPedido int,
add foreign key (IDPedido) references Pedidos(IDPedido);
alter table Pedidos
add IDRepartidor int,
add foreign key (IDRepartidor) references Repartidores(IDRepartidor),
add IDPrenda int,
add foreign key (IDPrenda) references Prendas(IDPrenda),
add IDCliente int,
add foreign key (IDCliente) references Clientes(IDCliente);



INSERT INTO Clientes (Nombre, DNI, Apellido) VALUES
('Juan', 12345678, 'Perez'),
('Maria', 23456789, 'Gomez'),
('Lucas', 34567890, 'Fernandez');


INSERT INTO Repartidores (Nombre, Antiguedad, Apellido) VALUES
('Pedro', 2020, 'Sanchez'),
('Diego', 2018, 'Torres'),
('Luis', 2022, 'Diaz');

INSERT INTO Prendas (Tipo, Talle, Color) VALUES
('Remera', 'L', 'Rojo'),
('Pantalon', 'XL', 'Negro'),
('Campera', 'S', 'Azul'),
('Buzo', 'M', 'Amarillo'),
('Sueter', 'XS', 'Violeta'),
('Short', 'M', 'Verde');


INSERT INTO Pedidos (Estado, PrecioUnidad, IDRepartidor, IDPrenda, IDCliente) VALUES
('EnProceso', 1500, 1, 1, 1),
('EnProceso', 3000, 1, 4, 1),
('EnCamino', 3000, 2, 2, 2),
('EnCamino', 2000, 2, 5, 2),
('Entregado', 5000, 3, 3, 3),
('Entregado', 9000, 3, 6, 3);

INSERT INTO Vendedores (Nombre, VentasRealizadas, Apellido) VALUES
('Ana', 5, 'Lopez'),
('Carlos', 8, 'Martinez'),
('Sofia', 3, 'Ramirez');

INSERT INTO Ventas (TipoFactura, total, IDVendedor, IDPedido) VALUES
('a', 4500, 1, 1),
('b', 5000, 2, 2),
('c', 14000, 3, 3);

select Prendas.tipo, Pedidos.PrecioUnidad
from Prendas, Pedidos
where Prendas.IDPrenda = Pedidos.IDPrenda;

select Ventas.IDVenta, Vendedores.Nombre, Vendedores.Apellido
from Ventas, Vendedores
where Ventas.IDVendedor = Vendedores.IDVendedor