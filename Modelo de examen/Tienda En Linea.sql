create database TiendaEnLinea;
use TiendaEnLinea;

Create table Productos (
ID_Prod int auto_increment primary key,
Nombre_prod Varchar(50),
Descripcion varchar(100),
Precio decimal(10, 2),
Stock_disponible int
);

create table Clientes ( 
ID_Cliente int auto_increment primary key,
Nombre varchar(50),
Apellido varchar(50),
Correo_Electronico varchar(100),
Direccion varchar(50)
);

create table Pedidos (
ID_Pedido int auto_increment primary key,
ID_Cliente int,
foreign key (ID_Cliente) references Clientes (ID_Cliente),
Fecha_Del_Pedido date,
Estado_Del_Pedido enum('Pendiente', 'En proceso', 'Enviado', 'Entregado')
);

insert into Productos (Nombre_prod, Descripcion, Precio, Stock_Disponible)
values
('Teclado con luces', 'Con teclas negras', 1500.00, 5 ),
('Ariculares Azul', 'Son comodos para las orejas', 20000.00, 10 ),
('Ram de 32gb', 'Muy buena para juegos de muchos graficos', 500.00, 60),
('Funda de celular rosa', 'Con buen doseño de flores', 1200.00, 100 ),
('Lampara', 'Con buena iluminacion', 4000.00, 80);  

insert into Clientes (Nombre, Apellido, Correo_Electronico, Direccion)
values
('sofia', 'gonzales', 'Sofia@gmail.com', 'Av.Rosas 2390'),
('gloria', 'lopez', 'gloria@gmail.com', 'Belgrano 2387'),
('roberta', 'perez', 'roberta@gamail.com', 'Roseti 299'),
('carlos', 'perez', 'carlos@gmail.com', 'chacarita'),
('samara', 'avanzini', 'samara@gmail.com', 'Av.Vida 3096');

insert into Pedidos (ID_Cliente, Fecha_Del_Pedido, Estado_Del_Pedido)
values
(1, '2026-06-12', 'En proceso'),
(2, '2026-03-03', 'Entregado'),
(3, '2026-06-11', 'Pendiente'),
(4, '2026-04-07', 'Entregado'),
(5, '2026-03-24', 'Entregado');

select Productos.Nombre_Prod, Productos.Precio 
from Productos
where Productos.Precio > 50;

select Clientes.ID_Cliente,Clientes.Nombre, Clientes.Apellido
from Clientes
inner join Pedidos on Clientes.ID_Cliente = Pedidos.ID_Cliente;

select Pedidos.ID_Pedido, Clientes.Nombre, Pedidos.Fecha_Del_Pedido
from Pedidos
inner join Clientes on Pedidos.ID_Cliente = Clientes.ID_Cliente
Where Pedidos.Estado_Del_Pedido = 'Entregado';

select Clientes.Nombre, Clientes.Correo_Electronico, Pedidos.Estado_Del_Pedido
from Pedidos
inner join clientes on Pedidos.ID_Cliente = Clientes.ID_Cliente;

select Clientes.Nombre, Pedidos.Fecha_Del_Pedido
from Pedidos
inner join Clientes on Pedidos.ID_Cliente = Clientes.ID_Cliente
order by Pedidos.Fecha_Del_Pedido desc
limit 1;

select Clientes.Nombre, Pedidos.Fecha_Del_Pedido, Pedidos.Estado_Del_Pedido
from pedidos
inner join Clientes on Pedidos.ID_Cliente = Clientes.ID_Cliente
where Pedidos.Estado_Del_pedido = 'Pendiente';

Select Productos.Nombre_Prod, Productos.Precio
from Productos
order by Precio desc
limit 1;
