create database envios;
use envios;

create table Sucursales (
IDSuc int auto_increment primary key,
Ciudad varchar(50),
Provincia varchar(50),
responsable varchar(20)
);
 
create table Paquetes (
IDPaq int auto_increment primary key,
Peso decimal(10,2),
Descripcion_Contenido text,
TipoEnvio enum('Express' , 'Normal'),
IDSucOrigen int,
foreign key (IDSucOrigen) references Sucursales (IDSuc)
);

create table Envios (
IDEnvio int auto_increment primary key,
IDPaq int, 
Costo_Envio decimal (10,2),
FechaDespacho date,
Estado enum('Entregado','En camino','Devuelto'),
foreign key (IDPaq) references Paquetes (IDPaq)
);

insert into Sucursales (Ciudad, Provincia, responsable ) values
("Buenos Aires", "Buenos Aires", "Carlos Gomez"),
("Rosario", "Santa Fe", "Maria Perez"),
("Cordoba", "Cordoba", "Juan Lopez"),
("La Plata", "Buenos Aires", "Ana Ruiz"),
("Mendoza", "Mendoza", "Luis Torres");

insert into Paquetes ( Peso, Descripcion_Contenido , TipoEnvio, IDSucOrigen) values
(15.50, "Caja de herramientas", "Express", 1),
(45.00, "Documentacion medica", "Normal", 2),
(5.20, "Caja de repuestos", "Express", 3),
(30.00, "Caja de Equipamiento electronico", "Express", 4),
(12.00, "Caja de libros", "Normal", 5);

insert into Envios (IDPaq, Costo_Envio ,FechaDespacho ,Estado) values
(1, 60000.00, '2026-05-10', "Entregado"),
(2, 55000.00, '2026-05-12', "En Camino"),
(3, 75000.00, '2026-05-15', "Entregado"),
(4, 12000.00, '2026-05-20', "En Camino"),
(5, 8000.00, '2026-05-05', "Devuelto");

-- Consulta 1
select Sucursales.Ciudad, avg(Paquetes.Peso) as Peso_Promedio 
from Sucursales
inner join Paquetes on Sucursales.IDSuc = Paquetes.IDSucOrigen
inner join Envios on Paquetes.IDPaq = Envios.IDPaq
where Envios.Estado = 'Entregado' and 
Paquetes.Peso >= 1 and Paquetes.Peso <= 50
group by Sucursales.Ciudad
having sum(Envios.Costo_Envio) > 50000;
 
-- Consulta 2
select Sucursales.Ciudad, Count(Envios.IDEnvio) as Envios_Totales_Activos
from Sucursales
inner join Paquetes on Sucursales.IDSuc = Paquetes.IDSucOrigen
inner join Envios on Paquetes.IDPaq = Envios.IDPaq
where Envios.Estado = 'En Camino' and
Envios.Costo_Envio >= 5000
group by Sucursales.Ciudad Desc;

-- Consulta 3
select Paquetes.Descripcion_Contenido, Envios.Costo_Envio from Paquetes
inner join Sucursales on Paquetes.IDSucOrigen = Sucursales.IDSuc
inner join Envios on Paquetes.IDPaq = Envios.IDPaq
where Sucursales.Provincia = 'Buenos Aires' and
Paquetes.TipoEnvio = 'Express'
order by Envios.Costo_Envio desc;

-- Consulta 4
select Paquetes.IDPaq, Paquetes.Peso, Paquetes.Descripcion_Contenido,  
Paquetes.TipoEnvio, Paquetes.IDSucOrigen, Envios.FechaDespacho, Envios.Estado 
from Paquetes 
join Envios on Paquetes.IDPaq = Envios.IDPaq 
where Paquetes.Descripcion_Contenido like 'Caja%' 
and Envios.FechaDespacho >= '2026-05-01'  
and Envios.FechaDespacho <= '2026-05-31';


