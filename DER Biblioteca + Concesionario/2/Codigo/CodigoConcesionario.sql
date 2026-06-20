create database Concesionario;
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

create table coches
(
	IDCoche int primary key auto_increment not null,
    matricula varchar(7),
    Modelo varchar(25),
    Marcha varchar(25),
    color varchar(25)
);
create table usados
(
	IDUsado int primary key auto_increment not null,
    IDCoche int,
    foreign key (IDCoche) references Coches(IDCoche),
    kilometraje float
);
create table nuevos
(
	IDNuevo int primary key auto_increment not null,
    IDCoche int,
    foreign key (IDCoche) references Coches(IDCoche),
    Stock int
);
create table ventas
(
	IDVenta int primary key auto_increment not null,
    IDCoche int,
    foreign key (IDCoche) references Coches(IDCoche),
    IDFichaCliente int,
    foreign key (IDFichaCliente) references fichasclientes(IDFichaCliente),
    total float,
    Fecha date
);
create table mecanicos
(
    IDMecanico int primary key auto_increment not null,
    nombre varchar(25),
    apellido varchar(25),
    DNI int(10),
    FechaContratacion date,
    salario int(8) 
);
create table reparaciones
(
	IDReparacion int primary key auto_increment not null,
    IDCoche int,
    foreign key (IDCoche) references Coches(IDCoche),
    IDMecanico int,
    foreign key (IDMecanico) references mecanicos(IDMecanico),
    horas float,
    Fecha date
);

insert into fichasclientes (nombre, apellido, DNI, direccion, telefono) values
('Thiago', 'Montenegro', 42156789, 'Avellaneda 742', 116543219),
('Renata', 'Villalba', 39874512, 'Belgrano 1550', 117892341),
('Gael', 'Iturriaga', 44789123, 'Sarmiento 923', 115673421),
('Mora', 'Zeballos', 40987654, 'Mitre 456', 113456782),
('Bautista', 'Quiroga', 43567891, 'San Martin 188', 119876543);

insert into coches (matricula, modelo, marcha, color) values
('AB123CD', 'Corolla', 'Toyota', 'Rojo'),
('EF456GH', 'Civic', 'Honda', 'Negro'),
('IJ789KL', '208', 'Peugeot', 'Blanco'),
('MN321OP', 'Focus', 'Ford', 'Azul'),
('QR654ST', 'Cronos', 'Fiat', 'Gris');

insert into usados (IDCoche, kilometraje) values
(1, 85420),
(3, 65400),
(5, 43210);

insert into nuevos (IDCoche, stock) values
(2, 5),
(4, 4);
insert into ventas (IDCoche, IDFichaCliente, total, Fecha) values
(1, 1, 18500000, '2025-03-12'),
(2, 2, 22350000, '2025-03-19'),
(3, 3, 17400000, '2025-04-02'),
(4, 4, 19870000, '2025-04-15'),
(5, 5, 16750000, '2025-04-28');

insert into mecanicos (nombre, apellido, DNI, FechaContratacion, salario) values
('Leandro', 'Barrenechea', 35678124, '2021-06-10', 850000),
('Camila', 'Ormaechea', 38945127, '2022-01-18', 910000),
('Bruno', 'Santillan', 40123789, '2020-09-25', 970000),
('Julieta', 'Mansilla', 41789456, '2023-03-14', 820000),
('Nicolas', 'Echeverria', 37214589, '2019-11-30', 1050000);

insert into reparaciones (IDCoche, IDMecanico, horas, Fecha) values
(1, 1, 4.5, '2025-02-10'),
(2, 2, 2.0, '2025-02-18'),
(3, 3, 6.5, '2025-03-05'),
(4, 4, 3.0, '2025-03-22'),
(5, 5, 5.5, '2025-04-11');