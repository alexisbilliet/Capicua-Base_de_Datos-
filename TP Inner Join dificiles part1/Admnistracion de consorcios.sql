create database AdministracionDeConsorcios;
use AdministracionDeConsorcios;

create table Edificios (
ID_Edificio int auto_increment primary key,
Nombre varchar(100),
Documentacion varchar(100)
);

create table Unidades (
ID_Unidad int auto_increment primary key,
Nro_Piso int,
ID_Edificio int,
foreign key (ID_Edificio) references Edificios (ID_Edificio)
);

create table Expensas (
ID_Expensa int auto_increment primary key,
ID_Unidad int,
foreign key (ID_Unidad) references Unidades(ID_Unidad),
Monto decimal (10 , 2),
Estado enum('Pago' , 'Impago')
);

insert into Edificios (Nombre , Documentacion)
values ('Torre Norte', 'Planos de arquitectura'),
('Torre Sur', 'Instalaciones'),
('Centro Comercial', 'Reglamento interno'),
('Rascacielo', 'Licencia de obra'),
('Crentro de rehabilitacion', 'Planos de arquitectura');

insert into Unidades (Nro_Piso, ID_Edificio)
values (4, 1),
(2, 2),
(3, 3),
(4,4),
(5,5);

insert into Expensas (ID_Unidad, Monto, Estado)
values (1, 2000000.00, 'Pago'),
(2, 2000000.00, 'Impago'),
(3, 180000.00, 'Impago'),
(4, 50000.00,'Pago'),
(5, 15000.00, 'Pago'); 

select Edificios.Nombre, sum(Expensas.Monto) as Total_Impagas
from Edificios
inner join Unidades on Edificios.ID_Edificio = Unidades.ID_Edificio
inner join Expensas on Unidades.ID_Unidad = Expensas.ID_Unidad
where Expensas.Estado = 'Impago'
group by Edificios.ID_Edificio , Edificios.Nombre
having sum(Expensas.Monto) > 1000000 
and count(Unidades.ID_Unidad) > 5;

select Edificios.Nombre, avg(Expensas.Monto) as Promedios_Pagados
from Edificios 
inner join Unidades on Edificios.ID_Edificio = Unidades.ID_Edificio
inner join Expensas on Unidades.ID_Unidad = Expensas.ID_Unidad
where Expensas.Estado = 'Pago'
group by Edificios.ID_Edificio, Edificios.Nombre
having avg(Expensas.Monto) <= 20000;

select Edificios.Nombre, sum(Expensas.Monto) as Total_Recaudacion
from Edificios
inner join Unidades on Edificios.ID_Edificio = Unidades.ID_Edificio
inner join Expensas on Unidades.ID_Unidad = Expensas.ID_Unidad
where Expensas.Estado = 'Pago'
group by  Edificios.ID_Edificio, Edificios.Nombre
order by Total_Recaudacion desc
limit 3;