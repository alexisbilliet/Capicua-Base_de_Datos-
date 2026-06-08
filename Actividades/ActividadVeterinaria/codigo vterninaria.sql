create database veterinaria;
-- drop database veterinaria
use veterinaria;

create table duenios
(
	IDDuenio int primary key auto_increment not null,
    DNI int(10),
    Nombre varchar(25),
    Apellido varchar(25),
    Telefono int(25)
);
create table mascotas
(
	IDMascota int primary key auto_increment not null,
    Nombre varchar(25),
    Especie varchar(25),
    Edad int(2),
    Raza Varchar(25),
    IDDuenio int,
    foreign key (IDDuenio) references duenios(IDDuenio)
);
create table veterinarios
(
	IDVeterinario int primary key auto_increment not null,
    DNI int(10),
    Nombre varchar(25),
    Apellido varchar(25),
    Telefono int(25)
);
create table turnos
(
	IDTurno int primary key auto_increment not null,
    Fecha date,
    Hora time,
    motivo text,
    IDMascota int,
    foreign key (IDMascota) references mascotas(IDMascota),
    IDVeterinario int,
    foreign key (IDVeterinario) references veterinarios(IDVeterinario)
    
);
insert into duenios(DNI, Nombre, Apellido, Telefono) values
(50024742, "Santiago", "Fidani", 1134520496),
(49865012, "Benjamin", "Sala", 1146960259);

insert into Mascotas(Nombre, Especie, Edad, Raza, IDDuenio) values
("Ramón", "Perro", 5, "Golden Retriver", 2),
("Lolo", "Gato", 2, "Siames", 1);

insert into veterinarios(DNI, Nombre, Apellido, Telefono) values
(38765023, "Julian", "Dominguez", 1156750296),
(50259264, "Benjamin", "Gimenez", 1145989687);

insert into turnos(Fecha, Hora, motivo, IDMascota, IDVeterinario) values
("2026-05-06", "12:30:00", "Sufrio una fractura en la pata delantera izquierda", 1, 1),
("2026-07-08", "15:30:00", "Inyeccion de medicamentos", 2, 2);

select * 
from mascotas;

select nombre, apellido
from duenios;

select * 
from turnos
where Fecha > "2024-05-01"
