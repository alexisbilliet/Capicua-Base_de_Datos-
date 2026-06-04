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
create table Mascotas
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
    Legajo int(10),
    Nombre varchar(25),
    Especialidad varchar(25),
    Turno enum("Mañana", "Tarde", "Noche")
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
