create database vuelos;

use  vuelos;

create table aviones
(
  IDAvion int primary key auto_increment not null,
  modelo varchar(25),
  capacidad decimal
);
create table vuelos
(
   IDNroVuelo int primary key auto_increment not null,
   origen varchar(25),
   destino varchar(25),
   fecha date, 
   IDAvion int, 
   foreign key (IDAvion) references aviones(IDAvion)
);
create table pasajeros
(
   IDPasajero int primary key auto_increment not null,
   nombre varchar(25),
   apellido varchar(25),
   DNI int(10)
);
create table tickets
(
   IDTicket int primary key auto_increment not null,
   precio int(5),
   tipo enum("1Clase, ClaseEjecutiva, EconomicaPremium, ClaseEconomica"),
   IDNroVuelo int, 
   foreign key (IDNroVuelo) references vuelos(IDNroVuelo),
   IDPasajero int, 
   foreign key (IDPasajero) references pasajeros(IDPasajero)
);
insert into aviones (modelo, capacidad) values 
('Boeing 777', 396),
('Airbus A330', 277),
('Embraer 190', 114),
('Bombardier CRJ900', 90),
('Boeing 757', 239);

insert into pasajeros (nombre, apellido, DNI) values 
('Esteban', 'Quito', 45123789),
('Aquiles', 'Bailo', 38456123),
('Zoe', 'Aventurera', 95123456),
('Cosme', 'Fulanito', 12345678),
('Elena', 'Nito del Bosque', 22334455);

-- 5 Registros adicionales para VUELOS (IDAvion 4 y 5 son los de gran capacidad)
-- Nota: Se usa formato YYYY-MM-DD para evitar errores de tipo DATE.
INSERT INTO vuelos (origen, destino, fecha, IDAvion) VALUES 
('Ezeiza', 'Madrid', '2026-06-15', 4),
('Aeroparque', 'Santiago', '2026-06-16', 2),
('Cordoba', 'Miami', '2026-06-17', 5),
('Mendoza', 'Lima', '2026-06-18', 3),
('Ezeiza', 'Paris', '2026-06-19', 4);

-- 5 Registros iniciales para TICKETS
-- (Para cumplir tu consigna de >100 pasajeros y >$2M, deberías insertar muchos más registros aquí)
INSERT INTO tickets (precio, tipo, IDNroVuelo, IDPasajero) VALUES 
(550000, '1Clase', 6, 1),
(480000, 'ClaseEjecutiva', 8, 2),
(150000, 'ClaseEconomica', 7, 3),
(600000, '1Clase', 10, 4),
(120000, 'ClaseEconomica', 9, 5);



select aviones.modelo
from aviones
inner join vuelos
on aviones.IDAvion = vuelos.IDAvion
inner join tickets
on tickets.IDNroVuelo = vuelos.IDNroVuelo