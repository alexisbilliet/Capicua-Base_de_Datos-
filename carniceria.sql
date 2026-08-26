create database carniceria;
use carniceria;

create table Carniceros (
IDCarnicero int auto_increment primary key, 
Nombre varchar(50),
Apellido varchar(50),
Dni int(8)
);

create table Clientes (
IDCliente int auto_increment primary key,
Nombre varchar(50),
Telefono int(10)
);

create table Categorias (
IDCategoria int auto_increment primary key,
Nombre varchar(50)
);

create table Productos (
IDProducto int auto_increment primary key,
Nombre varchar(50),
Precio decimal(10,2),
IDCategoria int,
foreign key (IDCategoria) references Categorias (IDCategoria)
); 

create table MediosDePagos (
IDMedioDePago int auto_increment primary key,
Nombre varchar(50)
);

create table Ventas (
IDVenta int auto_increment primary key,
precio decimal(10 , 2),
IDCarnicero int,
IDProducto int,
IDMedioPago int,
IDCliente int,
Cantidad int,
Fecha date,
foreign key(IDCarnicero) references Carniceros(IDCarnicero),
foreign key(IDCliente) references Clientes(IDCliente),
foreign key(IDMedioPago)references MediosDePagos(IDMedioDePago),
foreign key(IDProducto) references Productos(IDProducto)
);


insert into Carniceros(Nombre, Apellido, DNI)values
("Juan", "Gomez", 96879767),
("Santiago", "Lopez", 96783456),
("Benjamin", "fidani", 96745312);

insert into Clientes (Nombre , Telefono) values
("Ezequiel", 1134678904),
("Karina", 1126783412),
("Carlitos", 1189762356);

insert into Categorias(Nombre) values
("Cane Vacuna"),
("Pollo"),
("Carne de cerdo");

insert into Productos(Nombre ,Precio,IDCategoria) values
("Asado ", 1200.50, 1),
("Pechuga", 5667.50, 2),
("Costilla de cerdo", 1400.50, 3);

insert into MediosDePagos(Nombre) values
 ("Tranferencia"),
 ("Tarjeta"),
 ("Billetera virtual");

insert into Ventas(Precio, IDCarnicero, IDCliente, IDMedioPago, IDProducto, Cantidad ,Fecha ) 
values
(1500.50, 1, 1, 1, 1, 1, '2025-05-05'),
(2000.00, 2, 2, 2, 2, 2, '2025-06-04'),
(1230.50, 1, 3, 3, 1, 3, '2026-09-19');



--  La Carne mas vendida
select nombre, precio from Productos
where precio= ( select max(precio) from productos);

-- Cliente mas fiel(EL que realizo mas compras)
select IDCliente from Ventas
group by IDCliente
order by sum(Cantidad);

-- El carnicero que mas clientes tuvo
select c.Nombre, Count(v.IDVenta)as Clientes_Atendidos
from Carniceros c 
inner join Ventas v on c.IDCarnicero = Ventas.IDCarnicero
group by c.IDCarnicero, c.Nombre
order by Clientes_Atendidos desc;

-- El pedido mas caro
select Clientes.Nombre as Cliente , Ventas.Cantidad as ContenidoPedido, Ca.Nombre as Carnicero
from Ventas v, Cliente cl, Carnicero ca
where v.IDCliente = cl.IDCliente and v.IDCarnicero = ca.IDCarnicero
order by  sum(v.Precio*v.Cantidad) desc
Limit 1;

-- total vendido por categoría
select P.IDCategoria, sum(P.Precio * v.Cantidad) as total -- select categoria, sum(precio * cantidad) as total
from Productos as p, Ventas as v                           -- from productos p
where v.IDProducto = p.IDProducto                        -- join ventas v on p.ID_producto = v.ID_producto
group by p.IDCategoria;                                   -- group by categoria;





