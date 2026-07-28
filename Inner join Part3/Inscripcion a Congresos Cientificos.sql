create database tt;
use tt;

create table Congresos (
IDCon int auto_increment primary key,
tematica varchar(150),
Fecha_inicio date,
PrecioInscripcion decimal(10,2)
);

create table Expositores (
IDExp int auto_increment primary key,
nombre varchar(50),
pais varchar(50),
especialidad varchar(20)
);

create table Charlas (
IDCharla int auto_increment primary key,
IDCon int,
TituloCharla varchar(50),
Asistentes_Estimados int,
IDExp int,
duracionMin time,
Foreign key (IDCon) references Congresos (IDCon),
foreign key (IDExp) references Expositores (IDExp)
);


insert into Congresos(tematica, Fecha_inicio, PrecioInscripcion)
values
("Congreso de lectura", '2026-06-06', 1500.00),
("Congreso del poder", '2022-05-04', 1900.00),
("Congreso de historia", '2024-09-03', 1400.00),
("Congreso Escolar", '2022-09-09', 1209.50),
("Congreso de inteligencia artificial", '2008-05-11', 1500.50);

insert into Expositores(nombre, pais, especialidad)
values
("Feria de libro", 'Argentina', "Leer"),
("Dinero", "China", "Financiar"),
("Historia antigua", "Brasil", "Investiagar" ),
("Color azul", "Chile", "Azul"),
("Laboratorios", "Uruguay", "Farmaceuticos");

insert into Charlas(IDCon, TituloCharla, Asistentes_Estimados , IDExp, duracionMin )
values
(1, "Poemas", '150', 1, '90'),
(2, "Palabras", '22', 2, '80'),
(3, "Antiguedad", '120', 3, '70'),
(4, "Arcoiris", '200', 4, '30'),
(5, "Formulas", '30', 5, '400');

-- Consulta 1
select Congresos.tematica, sum(Charlas.Asistentes_Estimados) as  totalAsistentes from Congresos
inner join Charlas on Congresos.IDCon = Charlas.IDCon
inner join Expositores on Charlas.IDExp = Expositores.IDExp
where (Expositores.pais = 'Chile' or Expositores.pais = 'Brasil')
and Charlas.Asistentes_Estimados > 100
group by Congresos.IDCon ,Congresos.tematica
having Count(Charlas.IDCharla) > 2;

-- Consulta 2
select Expositores.pais, avg(Charlas.Asistentes_Estimados) as promedio_de_Asistentes
from Expositores
inner join Charlas on Expositores.IDExp = Charlas.IDExp
inner join Congresos on Charlas.IDCon = Congresos.IDCon
where Congresos.tematica like '%InteligenciaArtificial%'
group by Expositores.pais;

-- Consulta 3
select Charlas.TituloCharla ,Expositores.nombre as nombre_Expositor, Charlas.DuracionMin
from Charlas
inner join Expositores on Charlas.IDExp = Expositores.IDExp
where Charlas.DuracionMin > 60
order by Charlas.DuracionMin Desc;

-- Consulta 4
select tematica, PrecioInscripcion from Congresos
where tematica like '%Avanzada%' or tematica like '%Intelgencia%'
order by tematica Asc;