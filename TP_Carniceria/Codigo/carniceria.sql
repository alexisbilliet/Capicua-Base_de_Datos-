create database Carniceria;
-- drop database SQLSeries
use Carniceria;

create table Carniceros
(
ID_Carnicero int primary key auto_increment not null,
Nombre varchar(25),
Apellido varchar(25),
DNI int
);

create table Clientes
(
ID_Cliente int primary key auto_increment not null,
Nombre varchar(25),
Telefono int
);

create table Productos
(
ID_Producto int primary key auto_increment not null,
Nombre varchar(25),
Tipo varchar(25),
Corte varchar(25),
Precio float
);

create table ventas
(
ID_Venta int primary key auto_increment not null,
Fecha date,
Cantidad int,
Mediosdepago enum ("Billetera virtual","Efectivo","Tarjeta"),
ID_Carnicero int,
foreign key (ID_carnicero) references Carniceros (ID_Carnicero),
ID_Producto int,
foreign key (ID_Producto) references Productos (ID_Producto),
ID_Cliente int,
foreign key (ID_Cliente) references Clientes(ID_Cliente)
);

create table Productosventas
(
ID_Productoventa int primary key not null,
Cantidad int,
ID_Venta int,
foreign key (ID_Venta) references Ventas(ID_Venta),
ID_Producto int,
foreign key (ID_Producto) references Productos(ID_Producto)
);


insert into Carniceros(Nombre, Apellido, DNI) values
("Santiago", "Fidani", 50257628),
("Agustin", "Barrionuevo", 49624223),
("Alexis", "Billiet", 50259264);

insert into Clientes(Nombre, Telefono) values
("Diana", 1154821780),
("Luciana", 1144678258),
("Elena", 1151632478);

insert into Productos(Nombre, Corte, Precio) values
("Pechuga de pollo", "Magro", 8000),
("Milanesa de carne", "Nalga", 6000),
("Bife de chorizo", "Bife ancho", 20000 );

insert into ventas(Fecha, Cantidad, Mediodepago, ID_Carnicero, ID_Productos, ID_Cliente) values
("2026-09-14", 3, "Billetera virtual", 1, 1, 1 ),
("2026-08-30", 2, "Tarjeta", 3, 2, 3 ),
("2026-10-05", 1, "Efectivo", 2, 3,2 );

select Nombre
from Productos
order by Precio desc
limit 1;

select Clientes.Nombre, count(Ventas.ID_Venta) as CantidadVentas
from Clientes
inner join Ventas
on Clientes.ID_Cliente = Ventas.ID_Cliente
group by Clientes.ID_Cliente, Clientes.Nombre
order by CantidadVentas desc
limit 1;

select Carniceros.Nombre, count(Clientes.ID_Cliente) as CantidadClientes
from Carniceros
inner join Ventas
on Carniceros.ID_Carnicero = Ventas.ID_Carnicero
inner join Clientes
on Ventas.ID_Cliente = Clientes.ID_Cliente
group by Carniceros.ID_Carnicero, Carniceros.Nombre
order by CantidadClientes desc
limit 1;

select Ventas.ID_Venta, Clientes.Nombre, Carniceros.Nombre, Productosventas.Cantidad, sum(Productosventas.Cantidad * Productos.Precio) as Total
from Ventas
inner join Clientes
on Clientes.ID_Clientes = Ventas.ID_Clientes
inner join Carniceros
on Carniceros.ID_Carniceros = Ventas.ID_Carniceros
inner join Productosventas 
on Ventas.ID_Venta = Productosventas.ID_Venta
inner join Productos
on productos.id_producto = productosventas.id_producto
group by 
ventas.id_venta, clientes.nombre, carniceros.nombre, productos.nombre
order by Total desc
limit 1;

select Productos.Corte, count (Ventas.ID_Venta)
from Ventas
inner join Productos
on Productos.ID_Producto = Ventas.ID_Producto
group by 
Productos.Corte;
