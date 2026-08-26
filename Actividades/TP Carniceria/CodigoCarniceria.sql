
create database Carniceros;
-- drop database Carniceros
use Carniceros;

create table Carniceros(
IDCarnicero int auto_increment not null primary key,
Nombre varchar(25),
Apellido varchar(25),
DNI int
);
create table Proveedores(
IDProveedor int auto_increment not null primary key,
Nombre varchar(25),
Ubicacion varchar(25),
Telefono int
);
create table Productos(
IDProducto int auto_increment primary key,
Nombre varchar(25),
PrecioUnitario float,
Stock int,
IDProveedor int,
foreign key (IDProveedor) references Proveedores(IDProveedor)
);

create table Clientes(
IDCliente int auto_increment not null primary key,
Nombre varchar(25),
Telefono int
);
create table Pedidos(
IDPedido int primary key auto_increment not null,
IDCarnicero int, 
foreign key (IDCarnicero) references Carniceros(IDCarnicero),
IDCliente int, 
foreign key (IDCliente) references Clientes(IDCliente),
MedioDePago enum("A", "B", "C"),
PrecioTotal float	
);
create table ListasDeProductos(
IDDetalle int auto_increment primary key not null,
IDProducto int, 
foreign key (IDProducto) references Productos(IDProducto),
IDPedido int, 
foreign key (IDPedido) references pedidos(IDPedido),
Cantidad int
);

insert into Carniceros (Nombre, Apellido, DNI) values 
('Juan', 'Pérez', 30123456),
('Carlos', 'Gómez', 28999888),
('Luis', 'Martínez', 31222333);


insert into Proveedores (Nombre, Ubicacion, Telefono) values 
('Frigorífico Sur', 'Lanús', 114567890),
('Carnes Premium', 'Morón', 114123456),
('Campo Argentino', 'Luján', 114789123);


insert into Productos (Nombre, PrecioUnitario, Stock, IDProveedor) values 
('Bife de chorizo', 3000, 50, 1),
('Asado', 1000, 40, 2),
('Milanesa', 2000, 60, 3);




insert into Clientes (Nombre, Telefono) values 
('María López', 115678901),
('Pedro Sánchez', 114567890),
('Ana Torres', 116789012);


insert into Pedidos (IDCarnicero, IDCliente, MedioDePago, PrecioTotal) values 
(2, 2, 'A', 4000),
(2, 2, 'B', 5000),
(3, 3, 'C', 1000);

insert into ListasDeProductos (IDPedido, IDProducto, Cantidad) values 
(1, 2, 1), (1, 1, 1), (2, 3, 1), (3, 2, 1), (2, 1, 1);


select productos.nombre, count(ListasDeProductos.cantidad) as CantidadComprada
from productos
inner join ListasDeProductos
on ListasDeProductos.IDProducto = productos.IDProducto
group by productos.nombre
order by CantidadComprada desc
limit 1;


select Nombre
from Clientes
where IDCliente = (select IDCliente from pedidos group by IDCliente order by count(IDCliente) desc limit 1);


select Nombre, apellido
from carniceros
where IDCarnicero = (select IDCarnicero from pedidos group by IDCarnicero order by count(IDCarnicero) desc limit 1);


select Carniceros.nombre as NombreCarnicero, Clientes.nombre as NombreCliente, pedidos.MedioDePago, pedidos.Preciototal, productos.nombre as Producto, listasdeproductos.cantidad, pedidos.IDPedido
from pedidos
inner join Carniceros on Carniceros.IDCarnicero = pedidos.IDCarnicero
inner join Clientes on Clientes.IDCliente = pedidos.IDCliente
inner join listasdeproductos on listasdeproductos.IDPedido = pedidos.IDPedido
inner join productos on productos.IDProducto = listasdeproductos.IDProducto
where pedidos.IDPedido = (select IDPedido from pedidos order by preciototal desc limit 1);

select nombre, count(listasdeproductos.cantidad) as CantidadVendida
from productos
inner join listasdeproductos on listasdeproductos.IDProducto = productos.IDProducto
group by productos.IDProducto
order by CantidadVendida desc
limit 1 ;
