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
NivelBateria enum("Desgastada", "Optima", "Inservible"),
CostoMantenimiento int,
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
Costo int
);
create table RevisionesPiezas
(
IDRevisionPieza int primary key not null auto_increment,
IDPieza int,
foreign key (IDPieza) references Piezas(IDPieza),
IDRevision int,
foreign key (IDRevision) references Revisiones(IDRevision)
);



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
group by tecnicos.IDTecnico;

select autos.marca, count(revisiones.IDAuto) as CantidadRevisiones
from autos
inner join revisiones on revisiones.IDAuto = Autos.IDAuto
group by Autos.IDAuto
order by CantidadRevisiones asc
limit 1;
