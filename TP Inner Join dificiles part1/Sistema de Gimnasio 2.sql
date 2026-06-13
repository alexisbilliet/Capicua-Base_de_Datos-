create database SistemaDeGimnasio;
use SistemaDeGimnasio;

create table Socios (
    ID_Socio int auto_increment primary key,
    Nombre varchar(100),
    Fecha_Alta date
);

create table Planes (
    ID_Plan int auto_increment primary key,
    Tipo varchar(50),
    Costo decimal(10, 2)
);

create table Pagos (
    ID_Pago int auto_increment primary key,
    ID_Socio int,
    foreign key (ID_Socio) references Socios (ID_Socio),
    ID_Plan int,
    foreign key (ID_Plan) references Planes (ID_Plan),
    Monto decimal(10, 2),
    Fecha date
);

insert into Socios (nombre, fecha_alta)
values
('Juan Perez', '2024-01-15'),
('Maria Garcia', '2024-02-15'),
('Carlos Lopez', '2024-02-20'),
('Ana Martinez', '2024-03-10'),
('Luis Rodriguez', '2024-04-05');

insert into Planes(Tipo, Costo)
values 
('Basic', 5000.00),
('Premium', 15000.00),
('VIP', 10000.00),
('Basic', 5000.00),
( 'Premium', 15000.00);

insert into Pagos(ID_Socio, ID_Plan, Monto, Fecha)
values
(1, 1, 5000.00, '2024-01-15'),
(2, 2, 15000.00, '2024-02-15'),
(3, 3, 1000.00, '2024-02-20'),
(4, 4, 5000.00, '2024-03-10'),
(5, 5, 15000.00, '2024-04-05');

select Socios.Nombre,count(Pagos.ID_Pago) as Cantidad_Pagos
from Socios 
inner join Pagos on Socios.ID_Socio = Pagos.ID_Socio
inner join Planes on Pagos.ID_Plan = Planes.ID_plan
where Planes.Tipo = 'Premium'
group by Socios.ID_Socio, Socios.Nombre, Planes.Costo
having sum(Pagos.Monto) >= Planes.Costo;

select Planes.tipo as Tipo__de_PLan, sum(Pagos.Monto) as Ingreso_Total
from Planes
inner join  Pagos on Planes.ID_Plan = Pagos.ID_Plan
Group by Planes.ID_Plan, Planes.Tipo
having count(Pagos.ID_Socio) >= 50 
and sum(Pagos.Monto) >= 100000;

select Socios.Nombre, Planes.Tipo, count(Pagos.ID_Pago) as Cantidad_Pagos
from Socios
inner join Pagos on Socios.ID_Socio = Pagos.ID_Socio
inner join Planes on Pagos.ID_Plan = Planes.ID_Plan
group by Planes.ID_Plan, Planes.Tipo 
having count(Pagos.ID_Pago) >= 1; 

