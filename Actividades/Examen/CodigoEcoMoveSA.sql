create database EcoMoveSA;
-- drop database EcoMoveSA
use EcoMoveSA;

create table Organizaciones
(
IDOrganizacion int primary key not null auto_increment,
Nombre varchar(25),
Fundacion year
);
create table Autos
(
IDAuto int primary key not null auto_increment,
Marca varchar(25),
Modelo varchar(25),
Año year,
IDOrganizacion int,
foreign key (IDOrganizacion) references Organizaciones(IDorganizacion)
);
create table Tecnicos
(
IDTecnico int primary key not null auto_increment,
Nombre varchar(25),
Apellido varchar(25),
IDOrganizacion int,
foreign key (IDOrganizacion) references Organizaciones(IDorganizacion)
);
create table Revisiones
(
IDRevision int primary key not null auto_increment,
Fecha date,
EstadoGeneral enum("DestruccionTotal", "AveriaLeve", "AveriaGrave"),
NivelBateria int(2),
CostoMantenimiento decimal(10,2),
TipoMantenimiento varchar(50),
IDAuto int,
foreign key (IDAuto) references Autos(IDAuto),
IDTecnico int,
foreign key (IDTecnico) references Tecnicos(IDTecnico)
);
create table Piezas
(
IDPieza int primary key not null auto_increment,
Nombre varchar(25),
Costo decimal(10,2)
);
create table RevisionesPiezas
(
IDRevisionPieza int primary key not null auto_increment,
IDPieza int,
foreign key (IDPieza) references Piezas(IDPieza),
IDRevision int,
foreign key (IDRevision) references Revisiones(IDRevision)
);

Insert into Organizaciones(Nombre, Fundacion) Values

("Electric Motors", 2018),
("Green Energy", 2007),
("MQF", 2025);

Insert into Autos(Marca,modelo,  Año, IDOrganizacion) Values
("Roll Royce", "calsic", 1999, 2),
("Chevrolet", "camaro", 2023, 1),
("Nissan","frontier", 2026, 3);

Insert into Tecnicos(Nombre, Apellido, IDOrganizacion) Values
("Jorge", "Ocorbojon", 2),
("Hernan", "Gutierrez", 3),
("Hermenegildo", "Ruperez", 1);

Insert into Revisiones(Fecha, EstadoGeneral, NivelBateria, CostoMantenimiento, TipoMantenimiento, IDAuto, IDTecnico) Values
("2026-02-27", "DestruccionTotal", 14, 2500000, "Desguace", 3, 3),
("2026-03-04", "AveriaLeve", 87, 100000, "Desgaste en Frenos", 1, 2),
("2026-03-06", "AveriaGrave", 78, 500000, "Reparacion de puertas izquierdas", 2, 3),
("2026-03-13", "AveriaLeve", 85, 100000, "Reparacion de Rayones", 1, 3),
("2026-06-30", "DestruccionTotal", 70, 8000000, "Desguace", 1, 3);

Insert into Piezas(Nombre, Costo) Values

("Manija Puerta Izquierda", 50000),
("Motor de Ventanilla", 200000),
("Llanta Rodado 18", 300000);

Insert into RevisionesPiezas(IDPieza, IDRevision) Values
(1, 3), (2, 2), (3, 5);

select Autos.Marca as Auto, Organizaciones.Nombre as Organizacion, Tecnicos.Nombre as Tecnico
from Autos
inner join Organizaciones on Organizaciones.IDOrganizacion = Autos.IDOrganizacion
inner join Revisiones on Revisiones.IDAuto = Autos.IDAuto
inner join Tecnicos on Tecnicos.IDTecnico = Revisiones.IDTecnico;

select IDRevision, Fecha, EstadoGeneral, NivelBateria, CostoMantenimiento, TipoMantenimiento
from revisiones
where CostoMantenimiento >(select avg(CostoMantenimiento) from revisiones);

select tecnicos.nombre, count(revisiones.IDTecnico) as CantidadRevisiones
from tecnicos
inner join revisiones on revisiones.IDTecnico = tecnicos.IDTecnico
group by tecnicos.IDTecnico
having CantidadRevisiones > 3;

select autos.marca, autos.modelo, count(revisiones.IDAuto) as CantidadRevisiones
from autos
inner join revisiones on revisiones.IDAuto = Autos.IDAuto
group by Autos.IDAuto
order by CantidadRevisiones asc
limit 1;

select organizaciones.nombre, organizaciones.fundacion
from organizaciones
inner join autos on autos.IDOrganizacion = organizaciones.IDOrganizacion
inner join revisiones on revisiones.IDAuto = autos.IDAuto
where revisiones.NivelBateria < (select avg(NivelBateria) from revisiones );

select tecnicos.nombre, count(revisiones.IDTecnico) as CantidadRevisiones
from tecnicos
inner join revisiones on revisiones.IDTecnico = tecnicos.IDTecnico
group by tecnicos.IDTecnico
order by CantidadRevisiones desc
limit 3;	
