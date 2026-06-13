create database tecnologia;
Use tecnologia;

create table Categorias (
ID_Cat int auto_increment primary key,
Nombre_Cat varchar(20)
);

create table Productos (
ID_prod int auto_increment primary key,
Nombre varchar(20),
Precio decimal(10, 2),
ID_Cat int,
foreign key (ID_Cat) references Categorias (ID_Cat)
) ;

create table Detalles (
ID_Detalle int auto_increment primary key,
Color varchar(20)
);

create table Ventas (
ID_Venta int auto_increment primary key,
Cantidad int,
ID_Prod int,
foreign key (ID_Prod) references Productos (ID_Prod)
);

create table Detalles_ventas (
ID_Detalle_Venta int auto_increment primary key,
ID_Detalle int,
foreign key (ID_Detalle) references Detalles (ID_Detalle),
ID_Venta int,
foreign key (ID_Venta) references Ventas (ID_Venta) 
);

insert into Categorias ( Nombre_Cat)
values ('Computadoras'),
('Celular'),
('Perifericos'),
('Audio'),
('Monitores');

insert into Productos  (Nombre, Precio , ID_Cat)
values ('Macbook pro', 5000.00,1),
('Samsung A35', 5000.00, 2),
('Teclado', 100.00, 3),
('Auriculares', 5.00, 4),
('Monitor 4k', 3.00, 5);

insert into Detalles(Color)
values
('Gris'),
('Negro'),
('Blanco'),
('Azul'),
('Plateado');

insert into Ventas(Cantidad, ID_Prod)
values
(600,1),
(250,2),
(100,3),
(5,4),
(5,5);

insert into Detalles_Ventas(ID_Detalle, ID_Venta)
values (1,1),
(2,2),
(3,3),
(4,4),
(5,5);

select Categorias.Nombre_Cat, Productos.Nombre, sum(Ventas.Cantidad) as Total_Vendido
from Categorias
inner join Productos on Categorias.ID_Cat = Productos.ID_cat
inner join Ventas on Productos.ID_Prod = Ventas.ID_Prod
group by Categorias.Nombre_Cat, Productos.Nombre
having sum(Ventas.Cantidad) > 500;

select Categorias.Nombre_Cat, avg(Productos.Precio) as Promedio_Precio,
sum(Ventas.Cantidad) as Productos_Vendidos
from Categorias
inner join Productos on Categorias.ID_Cat = Productos.ID_Cat
inner join Ventas on Productos.ID_Prod = Ventas.ID_Prod
group by Categorias.Nombre_Cat
having avg(Productos.Precio) >1500 and sum(Ventas.Cantidad) >=10;

select Categorias.Nombre_Cat, count(Ventas.ID_Venta)as Total_ventas,
sum(Ventas.Cantidad*Productos.Precio) Total_Recaudacion
from Categorias
inner join Productos on Categorias.ID_Cat = Productos.ID_Cat
inner join Ventas on Productos.ID_Prod = Ventas.ID_Prod
Where Productos.Precio < 100
group by Categorias.Nombre_cat
having sum(Ventas.Cantidad*Productos.Precio) < 5000;