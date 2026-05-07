create database Concesionario;
-- drop database concesionario
use concesionario;

create table fichasclientes
(
	IDFichaCliente int primary key auto_increment not null,
    nombre varchar(25),
    apellido varchar(25),
    DNI int,
    direccion varchar(25),
    telefono int
);

create table Coches
(
	IDCoche int primary key auto_increment not null,
    matricula varchar(7),
    Modelo varchar(25),
    Marcha varchar(25),
    color varchar(25)
);
create table Usados
(
	IDUsado int primary key auto_increment not null,
    IDCoche int,
    foreign key (IDCoche) references Coches(IDCoche),
    kilometraje float
);
create table Nuevos
(
	IDNuevo int primary key auto_increment not null,
    IDCoche int,
    foreign key (IDCoche) references Coches(IDCoche),
    Stock int
);
create table Ventas
(
	IDVenta int primary key auto_increment not null,
    IDCoche int,
    foreign key (IDCoche) references Coches(IDCoche),
    IDFichaCliente int,
    foreign key (IDFichaCliente) references fichasclientes(IDFichaCliente),
    total float,
    Fecha date
);