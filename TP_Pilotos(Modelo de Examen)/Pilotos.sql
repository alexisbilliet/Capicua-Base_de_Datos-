create database Pilotos;
use Pilotos;

create table Escuderias (
IDEscuderia int auto_increment primary key,
Nombre varchar(50),
Prosupuesto decimal(10,2)
);

create table Pilotos (
IDPiloto int auto_increment primary key,
Nombre varchar(50),
Apellido varchar(50),
DNI int(8),
Edad int(2),
IDEscuderia int,
foreign key(IDEscuderia) references Escuderias (IDEscuderia)
);

create table Coches (
IDCoche int auto_increment primary key,
Marca varchar(50),
Modelo varchar(50),
Precio decimal(10,2),
Anio_Fabricacion int,
Patente varchar(50),
IDEscuderia int,
foreign key(IDEscuderia) references Escuderias(IDEscuderia)
);

create table Carreras (
IDCarrera int auto_increment primary key,
Km int(2),
Pais varchar(50),
CantPilotos int(2),
Anio int
);

create table Participaciones (
IDParticipacion int auto_increment primary key,
Puesto int,
IDPiloto int,
IDCoche int,
IDCarrera int,
foreign key (IDPiloto) references Pilotos (IDPiloto),
foreign key(IDCoche) references Coches(IDCoche),
foreign key(IDCarrera) references Carreras(IDCarrera)
);

insert into  Escuderias (Nombre, Prosupuesto) values
("Equipo rojo", 1000.50),
("Equipo estrella ", 1200.50),
("Equipo Azul", 1235.50);

insert into Pilotos (Nombre, Apellido, DNI, Edad, IDEscuderia) values
("Franco", "Colapinto", 96345812, 26 ,1),
("Max", "Verstappen", 96781256, 20, 2),
("Sergio", "perez", 96782378,45 , 3);

insert into Coches (Marca, Modelo, Precio,Anio_Fabricacion ,Patente,IDEscuderia  )values
("Ferrari", "F2004", 14000.50, 2016, "YUMJ79", 1),
("McLaren", "MP4/4", 15000.50, 2017, "ANCN56", 2),
("Chevrolet","Corvette C8.R",1200.50 ,2018, "QINX09", 3);

insert into Carreras(Km, Pais, CantPilotos, Anio)values
(20, "Italia", 32, 2024),
(34, "China", 23, 2020),
(45, "Portugal", 56, 2022);

insert into Participaciones(Puesto, IDPiloto, IDCoche,IDCarrera)values
(1, 1, 1, 1),
(5, 2, 2, 2),
(1, 3, 3, 3);

 -- Todos los pilotos junto su escudera
 select  Nombre, IDEscuderia as Escuderia from Pilotos;
 
 -- Mostrar todas las escuderías cuyo presupuesto sea mayor al
-- promedio de las demás escuderías
select * from Escuderias as e
where e.Prosupuesto >(select avg(Prosupuesto) 
from Escuderias);

-- Mostrar el auto más caro
select Marca, Precio from Coches as c
where c.Precio = (select max(Precio) from Coches)
limit 1;

-- Mostrar las carreras agrupadas por pais, ordenadas de la más
-- antigua a la más nueva y que tengan más 20km de recorrido
select Pais, count(*) as TotalCarrera from Carreras
where km > 20
group by Pais 
order by Anio desc;

-- Mostrar todos los pilotos que salieron campeones después del
-- año 2020 y que tengan más de 25 años
select * from Pilotos as P
inner join Participaciones Part on  P.IDPiloto  = Part.IDPiloto
inner join Carreras Car on Part.IDCarrera = Car.IDCarrera
where Part.Puesto = 1 
and Car.Anio > 2020 
and P.Edad >25;

-- Dado un Nombre de piloto mostrar la cantidad de carreras que tiene.
delimiter //
create procedure CantDeCarrerasPiloto(in NombrePiloto varchar (50))
begin
select P.Nombre as piloto, count(Car.IDCarrera) as CantidadCarreras
from Pilotos as P
inner join Carreras Car on P.IDPiloto = Car.IDPiloto
where P.Nombre = NombrePiloto
group by P.Nombre;
end //
delimiter ;

-- Dado una escudería mostrar los autos que tiene.
delimiter //
create procedure AutosEscuderia(in IDEscuderia int)
begin
select * from Coches
where IDEscuderia = IDEscuderia;
end //
delimiter ;
