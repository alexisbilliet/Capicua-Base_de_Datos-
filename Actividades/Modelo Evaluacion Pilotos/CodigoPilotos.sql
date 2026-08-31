create database formula1;
-- drop database formula1
use formula1;

create table Escuderias (
    IDEscuderia int primary key auto_increment not null,
    Nombre varchar(25),
    Presupuesto decimal(10,2)
);

create table Autos (
    IDAuto int primary key auto_increment not null,
    Marca varchar(25),
    Modelo varchar(25),
    Precio decimal(10,2),
    IDEscuderia int,
    foreign key (IDEscuderia) references Escuderias(IDEscuderia)
);

create table Pilotos (
    IDPiloto int primary key auto_increment not null,
    Nombre varchar(25),
    Edad int,
    Apellido varchar(25),
    IDEscuderia int,
    foreign key (IDEscuderia) references Escuderias(IDEscuderia)
);

create table Pistas (
    IDPista int primary key auto_increment not null,
    Nombre varchar(25),
    Ubicacion varchar(25),
    KM decimal(10,2)
);

create table Carreras (
    IDCarrera int primary key auto_increment not null, 
    Nombre varchar(25),
    CantidadVueltas int,
    Fecha date,
    IDPista int,
    foreign key (IDPista) references Pistas(IDPista)
);

create table Grillas (
    IDGrilla int primary key auto_increment not null,
    IDCarrera int,
    foreign key (IDCarrera) references Carreras(IDCarrera),
    IDPiloto int,
    foreign key (IDPiloto) references Pilotos(IDPiloto),
    IDAuto int,
    foreign key (IDAuto) references Autos(IDAuto)
);

create table Resultados (
    IDResultado int primary key auto_increment not null, 
    IDCarrera int,
    foreign key (IDCarrera) references Carreras(IDCarrera),
    IDPiloto int,
    foreign key (IDPiloto) references Pilotos(IDPiloto),
    Posicion int
);

insert into Escuderias (Nombre, Presupuesto) values
('Ferrari', 5000000.00),
('Mercedes', 4500000.00),
('McLaren', 400000.00);

insert into Autos (Marca, Modelo, Precio, IDEscuderia) values
('Ferrari', 'SF-26', 150000.00, 1),
('Mercedes', 'W17', 145000.00, 2),
('McLaren', 'MCL40', 140000.00, 3);

insert into Pilotos (Nombre, Edad, Apellido, IDEscuderia) values
('Charles', 28, 'Leclerc', 1),
('George', 22, 'Russell', 2),
('Lando', 32, 'Norris', 3);


insert into Pistas (Nombre, Ubicacion, KM) values
('Monza', 'Italia', 5.79),
('Silverstone', 'Inglaterra', 22.4),
('Spa', 'Belgica', 7.00);


insert into Carreras (Nombre, CantidadVueltas, Fecha, IDPista) values
('Gran Premio Italia', 53, '2026-09-06', 1),
('Gran Premio Inglaterra', 52, '2026-07-05', 2),
('Gran Premio Belgica', 44, '2026-07-19', 3);

insert into Grillas (IDCarrera, IDPiloto, IDAuto) values
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(1, 2, 1),
(2, 3, 2),
(3, 1, 3);

insert into Resultados (IDCarrera, IDPiloto, Posicion) values
(1, 1, 1),
(1, 2, 2),
(2, 2, 2),
(2, 3, 1),
(3, 3, 2),
(3, 1, 1);




select p.nombre, p.apellido, p.edad, e.nombre as Escuderia 
from pilotos p
inner join escuderias e on e.IDEscuderia = p.IDEscuderia;

select * from escuderias
where escuderias.presupuesto > (select avg(escuderias.presupuesto) from escuderias);

select Marca, Modelo, Precio 
from autos
where IDAuto = (select IDAuto from autos order by precio desc limit 1);

select c.Nombre, c.CantidadVueltas, c.Fecha, p.Nombre as Pais from Carreras c
inner join pistas p on p.IDPista = c.IDPista
where p.KM > 20
group by c.Nombre
order by c.fecha asc;

select pilotos.Nombre, pilotos.apellido
from pilotos
inner join resultados on resultados.IDPiloto = pilotos.IDPiloto
inner join carreras on carreras.IDCarrera = resultados.IDCarrera
where resultados.posicion = 1 and carreras.fecha > 2020-01-01 and pilotos.edad > 25
group by pilotos.IDPiloto
