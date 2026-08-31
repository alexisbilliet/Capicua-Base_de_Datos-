create database Carrera;
-- drop database Carrera
use Carrera;

create table Escuderias
(
ID_Escuderia int primary key auto_increment not null,
Nombre varchar(25)
);


create table Pilotos
(
ID_Piloto int primary key auto_increment not null,
Nombre varchar(25),
Apellido varchar(25),
DNI int,
ID_Escuderia int,
foreign key (ID_Escuderia) references Escuderias(ID_Escuderia)
);

create table Marcas
(
ID_Marca int primary key auto_increment not null,
Nombre varchar(25)
);

create table Autos
(
ID_Auto int primary key auto_increment not null,
Nombre varchar(25),
Precio float,
Fabricacion date,
Patente  varchar(25),
ID_Piloto int,
foreign key (ID_Piloto) references Pilotos(ID_Piloto),
ID_Marca int,
foreign key (ID_Marca) references Marcas(ID_Marca)
);

create table Carreras
(
ID_Carrera int primary key auto_increment not null,
KM decimal(10, 2),
Pais varchar(25),
Fecha date
);

create table Participaciones
(
ID_Participacion int primary key auto_increment not null,
Puesto int,
ID_Piloto int,
foreign key (ID_Piloto) references Pilotos(ID_Piloto),
ID_Auto int,
foreign key (ID_Auto) references Autos(ID_Auto),
ID_Carrera int,
foreign key (ID_Carrera) references Carreras(ID_Carrera)
);

alter table Escuderias add column Presupuesto float;
alter table Pilotos add column Edad int;


insert into Escuderias(Nombre, Presupuesto) values
("Ferrari", 10),
("Red bull racing", 30),
("McLaren", 22);

insert into Pilotos(Nombre, Apellido, DNI, ID_Escuderia, Edad) values
("Agustin", "Barrionuevo", 49624223, 2, 71),
("Santiago", "Fidani",50226125, 1, 25),
("Alexis", "Billiet", 50225481, 1, 61);

insert into Marcas(Nombre) values
("BMW"),
("Ferrari"),
("volkswagen");

insert into Autos(Nombre, Precio, Fabricacion, Patente, ID_Piloto, ID_Marca) values
("Golf GTI", 40000, "1976-06-01", "YX 666 XY", 1, 3 ),
("Vento", 12000, "13-01-01", "KUX 827", 2, 3 ),
("BMW M3", 181900, "1986-03-01", "AE 492 WM", 3, 1 );

insert into Carreras(KM, Pais, Fecha) values
(207, "Japon", "05-07-26"),
(308, "Argentina", "13-01-25"),
(498, "Ucrania", "25-12-26");

insert into Participaciones(Puesto, ID_Piloto, ID_Auto, ID_Carrera) values
(1, 1, 1, 1),
(2, 2, 2, 2),
(3, 3, 2, 3);

select Pilotos.Nombre, Escuderias.Nombre
from Escuderias
inner join Pilotos
on Pilotos.ID_escuderia = Escuderias.ID_Escuderia
group by Pilotos.Nombre;

select Escuderias.Nombre, Escuderias.Presupuesto
from Escuderias
where Escuderias.Presupuesto > ( 
select avg(Escuderias.Presupuesto)
from Escuderias
);

select Autos.Nombre, Autos.Precio
from Autos
group by Autos.Nombre
order by Autos.Precio desc
limit 1;

select Carreras.Pais, Carreras.KM, Carreras.Fecha
from Carreras
where Carreras.KM > 20
group by Carreras.Pais
order by Carreras.Fecha asc;

select Pilotos.Nombre, Pilotos.Edad, Participaciones.Puesto, Carreras.Fecha
from Pilotos
inner join Participaciones
on Pilotos.ID_Piloto = Participaciones.ID_Piloto
inner join Carreras
on Participaciones.ID_Carrera = Carreras.ID_Carrera
where Carreras.Fecha > "2020-01-01" and Pilotos.Edad > 25;
