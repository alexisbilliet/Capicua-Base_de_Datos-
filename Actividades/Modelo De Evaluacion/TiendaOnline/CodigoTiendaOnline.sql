create database TiendaOnline;
-- drop database TiendaOnline
use TiendaOnline;

create table productos
(
	IDProducto int primary key auto_increment not null,
    Nombre varchar(25),
    Descripcion text,
    Precio int(7),
    Stock int(10)
);
create table clientes
(
	IDCliente int primary key auto_increment not null,
    Nombre varchar(25),
    Apellido varchar(25),
    CorreoElectronico varchar(30),
    Direccion Varchar(25)
);
create table pedidos
(
	IDPedido int primary key auto_increment not null,
    IDCliente int,
    foreign key (IDCliente) references clientes(IDCliente),
    IDProducto int,
    foreign key (IDProducto) references productos(IDProducto),
    fecha date,
    estado enum('Pendiente', 'EnProceso', 'Enviado', 'Entregado')
);

insert into productos (Nombre, Descripcion, Precio, Stock) values
('Mate Imperial', 'Mate de calabaza forrado en cuero', 35000, 15),
('Termo Lumilagro', 'Termo de acero 1L', 28000, 20),
('Yerba Playadito', 'Paquete de yerba mate de 1kg', 4500, 100),
('Alfajores Jorgito', 'Caja de 12 alfajores', 8000, 50),
('Dulce de Leche ', 'Frasco de 1kg', 6500, 30);

insert into  clientes (Nombre, Apellido, CorreoElectronico, Direccion) values
('benjamin', 'sala', 'juan.gonzalez@gmail.com', 'Av. Rivadavia 1234'),
('zaira', 'cuiti', 'martina.fernandez@gmail.com', 'San Martin 456'),
('bianca', 'ducasse', 'facu.rodriguez@gmail.com', 'Belgrano 789'),
('Camila', 'sayed', 'camila.lopez@gmail.com', 'Mitre 321'),
('Santiago', 'fidani', 'santiago.perez@gmail.com', 'Sarmiento 654');

insert into  pedidos (IDCliente, IDProducto, Fecha, Estado) values
(1, 1, '2026-06-01', 'Entregado'),
(2, 3, '2026-06-03', 'EnProceso'),
(3, 2, '2026-06-04', 'Pendiente'),
(4, 5, '2026-06-05', 'Enviado'),
(5, 4, '2026-06-06', 'Entregado');

select nombre, precio
from productos
where precio > 50;

select clientes.nombre, pedidos.IDPedido
from clientes
inner join pedidos
on pedidos.IDCliente = clientes.IDCliente;

select pedidos.IDPedido, clientes.nombre, pedidos.fecha
from pedidos
inner join clientes
on clientes.IDCliente = pedidos.IDCliente
where Estado = 'Entregado' ;

select pedidos.Estado, clientes.CorreoElectronico
from pedidos
inner join clientes
on clientes.IDCliente = pedidos.IDCliente;

select clientes.nombre, pedidos.fecha
from clientes
inner join pedidos
on pedidos.IDCliente = clientes.IDCliente
order by fecha asc
limit 1;

select pedidos.IDPedido, clientes.nombre, pedidos.fecha, pedidos.estado
from pedidos
inner join clientes
on clientes.IDCliente = pedidos.IDCliente
where Estado = 'Pendiente' ;

select nombre, precio
from productos
order by precio desc
limit 1;