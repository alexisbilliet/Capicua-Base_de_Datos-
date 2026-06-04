create database veterinaria;
-- drop database veterinaria
use veterinaria;

create table dueños
(
	IDDueño int primary key auto_increment not null,
    DNI int(10),
    Nombre varchar(25),
    Apellido varchar(25),
    Telefono int(25)
);
create table Mascotas
(
	IDMascota int primary key auto_increment not null,
    Nombre varchar(25),
    Especie varchar(25),
    Edad int(2),
    Raza Varchar(25),
    IDDueño int,
    foreign key (IDDUeño) references dueños(IDDueño)
);
create table veterinarios
(
	IDDueño int primary key auto_increment not null,
    DNI int(10),
    Nombre varchar(25),
    Apellido varchar(25),
    Telefono int(25)
);
