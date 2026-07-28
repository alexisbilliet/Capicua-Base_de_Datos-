create database Farmacia;
use Farmacia;
create table Laboratorios(
IDLab int auto_increment primary key,
NombreLab varchar(50),
PaisOrigen varchar(50),
telefono int 
);

create table Medicamentos (
IDMed int auto_increment primary key,
NombreComercial varchar(30),
Monodroga varchar(50),
PrecioVenta decimal(10,2),
IDLab int,
foreign key (IDLab) references Laboratorios (IDLab)
);

create table Lotes (
IDLote int auto_increment primary key,
IDMed int,
StockActual int,
PrecioCosto decimal(10, 2),
Fecha_Vencimiento date,
Ubicacion_Gondola varchar(50),
foreign key (IDMed) references Medicamentos (IDMed)
);

insert into Laboratorios (NombreLab ,PaisOrigen,telefono ) values
("Bool", "Alemania", '01145550192'),
('Abott', "Brasil", '01147773321'),
('Roiza', "Argentina", '01142228899'),
('Sieg', "Argentina", '01143331122'),
('Bago', "Argentina", '01141115544');

insert into Medicamentos (NombreComercial ,Monodroga ,PrecioVenta ,IDLab) values
("Amoxidal 500", "Amoxicilina", 4500.00, 1),
("Aspirina", "Acido", 2200.00, 2),
("xen", "Amoxicilina", 4100.00, 3),
("God", "Ibuprofeno", 15000.00, 4),
("Novv", "Ibuprofeno", 3800.00, 5);

insert into Lotes (IDMed, StockActual, PrecioCosto, Fecha_Vencimiento, Ubicacion_Gondola) values
(1, 40, 2500.00, '2025-05-12', 'A-1'),
(2, 30, 2300.00, '2025-09-18', 'A-1'),
(3, 120, 1200.00, '2026-01-10', 'B-2'),
(4, 15, 9000.00, '2025-11-20', 'C-3'),
(5, 80, 2000.00, '2027-04-15', 'A-1');

-- consulta 1
select Laboratorios.NombreLab, sum(Lotes.StockActual) as stockActual
from Laboratorios
inner join Medicamentos on Laboratorios.IDLab = Medicamentos.IDLab
inner join Lotes on Medicamentos.IDMed = Lotes.IDMed
where Lotes.Fecha_Vencimiento >= '2025-01-01' and
Lotes.Fecha_Vencimiento <= '2025-12-31' and
Medicamentos.IDMed >= 100 and Medicamentos.IDMed <=  500
group by Laboratorios.IDLab , Laboratorios.NombreLab
having sum(Lotes.StockActual) < 200
order by StockActual Asc
Limit 5;

-- Consulta 2
select Medicamentos.NombreComercial, max(Lotes.StockActual) as StockMax
from Medicamentos
inner join Laboratorios on Medicamentos.IDLab = Laboratorios.IDLab
inner join Lotes on Medicamentos.IDMed = Lotes.IDMed
where Laboratorios.NombreLab like 'A%' or Laboratorios.NombreLab like 'B%'
group by Medicamentos.NombreComercial, Medicamentos.IDMed;

-- Consulta 3
select Medicamentos.NombreComercial, Medicamentos.PrecioVenta, Lotes.PrecioCosto, (Medicamentos.PrecioVenta-Lotes.PrecioCosto) 
as Margen_Ganancia
from Medicamentos
inner join Lotes on Medicamentos.IDMed = Lotes.IDMed
order by Margen_Ganancia desc;

-- Consulta 4
select count(*) as Total_Lotes from Lotes
inner join Medicamentos on Lotes.IDMed = Medicamentos.IDMed
where Lotes.Ubicacion_Gondola = 'A-1' and
Medicamentos.Monodroga like '%Amoxi%'; 