
create database Vuelos;
use Vuelos;

create table Aviones (
ID_Avion int auto_increment primary key,
Modelo varchar(50),
Capacidad int
);

create table Vuelos (
ID_Vuelo int auto_increment primary key,
Origen varchar(100),
Destino varchar(100),
Fecha date,
ID_Avion int,
Foreign key (ID_Avion) references Aviones (ID_Avion)
);

create table Pasajeros (
ID_Pasajero int auto_increment primary key,
DNI_Pasajero int,
Nombre varchar(100),
ID_Vuelo int,
foreign key (ID_Vuelo) references Vuelos (ID_Vuelo)
);

create table Pasajeros_Vuelos (
ID_Pasajero_Vuelo int auto_increment primary key,
Precio_Ticket decimal(10, 2),
ID_Pasajero int,
ID_Vuelo int,
foreign key (ID_Pasajero) references Pasajeros (ID_Pasajero),
foreign key (ID_Vuelo) references Vuelos (ID_Vuelo)
);

insert into Aviones (Modelo, Capacidad)
values
('Boeing 747', 500),
('Airbus A320', 180),
('Embraer 190', 110),
('Boeing 737', 200),
('Airbus A350', 250);

insert into Vuelos (Origen, Destino, Fecha, ID_Avion)
values
('EZEIZA', 'NYC', '2024-01-01', 1),
('EZEIZA', 'SUECIA', '2024-01-05', 2),
('SUECIA', 'EZEIZA', '2024-03-24', 3),
('EZEIZA', 'ITALIA', '2024-05-23', 4),
('CALIFORNIA', 'EZEIZA', '2024-01-01', 5);

insert into Pasajeros (DNI_Pasajero, Nombre, ID_Vuelo)
values
('11111111', 'Juan Perez', 1),
('22222222', 'Maria Garcia', 2),
('33333333', 'Carlos Lopez', 3),
('44444444', 'Ana Martinez', 4),
('55555555', 'Luis Rodriguez', 5);

insert into Pasajeros_Vuelos (Precio_Ticket, ID_Pasajero, ID_Vuelo)
values
(12000.00, 1, 1),
(11500.50, 2, 1),
(6000.00, 3, 2),
(30000.00, 4, 4),
(100000.00, 5, 3);

select Aviones.Modelo, sum(Pasajeros_Vuelos.Precio_Ticket) as Total_Recaudado
from Aviones
Inner Join Vuelos on Aviones.ID_Avion = Vuelos.ID_Avion
Inner join Pasajeros_Vuelos on Vuelos.ID_Vuelo = Pasajeros_Vuelos.ID_Vuelo
group by Aviones.ID_Avion, Aviones.Modelo
having sum(Pasajeros_Vuelos.Precio_Ticket) > 2000000 
and count(Pasajeros_Vuelos.ID_Pasajero) > 100;

select Vuelos.ID_Vuelo, avg(Pasajeros_Vuelos.Precio_Ticket)as Promedio_Ticket
from Vuelos
Inner Join Pasajeros_Vuelos on Vuelos.ID_Vuelo = Pasajeros_Vuelos.ID_Vuelo
where Vuelos.Origen = 'EZEIZA'
group by Vuelos.ID_Vuelo
having avg(Pasajeros_Vuelos.Precio_Ticket) > 500;

select Aviones.Modelo, count(Vuelos.ID_Vuelo) as Total_Vuelos
from Aviones
inner join Vuelos on Aviones.ID_Avion = Vuelos.ID_Avion
where Vuelos.Fecha >= '2024-01-01'
group by Vuelos.ID_Avion, Aviones.Modelo
having count(Vuelos.ID_Vuelo) > 50;

