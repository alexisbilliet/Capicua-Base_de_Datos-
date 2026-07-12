create database CNU;
use CNU;

create table Creadores (
ID_Creador int auto_increment primary key,
Nombre varchar(20),
Apellido varchar(25) null
);

create table Series (
ID_Serie int auto_increment primary key,
Nombre_Serie varchar(100),
Estreno date,
ID_Creador int,
foreign key(ID_Creador) references Creadores(ID_Creador)
);

create table Personajes (
ID_Personaje int auto_increment primary key,
Nombre_Personaje varchar(50),
ID_Serie int,
foreign key (ID_Serie) references Series (ID_Serie),
Rol varchar(50),
Nivel_Energia int
);

create table Episodios (
ID_Episodio int auto_increment primary key,
Titulo_Episodio varchar(100),
ID_Serie int,
foreign key (ID_Serie) references Series (ID_Serie),
Duracion_Minutos int,
Rating_Audencia int
);

create table Habilidades_Especiales (
ID_Habilidad int auto_increment primary key,
ID_Personaje int,
foreign key (ID_Personaje) references Personajes (ID_Personaje),
Nombre_Habilidad varchar(50),
Tipo_Habilidad varchar(20)
);

create table Villanos_Heroes (
ID_Villano_Heroe int auto_increment primary key,
Villano_Heroe bool,
ID_Personaje int,
foreign key (ID_Personaje) references Personajes(ID_Personaje)
);

create table Enemigos_Historicos (
ID_Rivalidad int auto_increment primary key,
ID_Villano int,
ID_Heroe int,
foreign key (ID_Villano) references Villanos_Heroes (ID_Villano_Heroe),
foreign key (ID_Heroe) references Villanos_Heroes (ID_Villano_Heroe),
Encuentros_Totales int
);

create table Objetos_Misticos (
ID_Objeto int auto_increment primary key,
Nombre_Objeto varchar(100),
ID_PersonajeDueno int,
foreign key (ID_PersonajeDueno) references Personajes (ID_Personaje),
Valor_Subasta decimal(10, 2)
);

insert into Creadores(Nombre,Apellido) values
('Pendleton', 'War'),
('Man of action',' '),
('Maxwell','Atoms'),
('James','Quintel'),
('John','Dilworth'),
('Genndy','TartaKovsky');

insert into Series(Nombre_Serie,Estreno, ID_Creador)
values
("Hora de Aventura", '2010-05-03', 1 ),
("Ben 10", '2005-03-23', 2),
("Billy y Mandy", '2003-03-24', 3 ),
("Un Show Mas", '2010-12-05', 4),
("Coraje el Perro Cobarde", '1999-02-13', 5),
("El laboratorio de Dexter", '1996-06-30', 6);

insert into Personajes(Nombre_Personaje, ID_Serie, Rol, Nivel_Energia)
values
("Finn el Humano", 1, "Protagonista", 85),
("Jake el perro", 1, "protagonista", 90),
("Rey Helado", 1, "Antagonista", 75),
("Ben Tennyson", 2, "Protagonista", 95),
("Vilgax", 2, "Antagonista", 98),
("Puro Hueso", 3, "Secundario", 80),
("Mordecai", 4, "Protagonista", 60),
("Rigby", 4, "Protagonista", 55),
("Coraje", 5, "Protagonista", 40),
("Dexter", 6, "Protagonista", 70);

insert into Episodios(Titulo_Episodio, ID_Serie, Duracion_Minutos, Rating_Audencia)
values
("Estrella dorada", 1, '20', 100),
("bomba", 1, '30', 100),
("Volcan de helado", 1, '20', 100),
("Cuatro brazos", 2, '20', 50),
("Lava", 2, '30', 100),
("Espuma", 3, '20', 100),
("Sandwich", 4, '40', 100),
("Asesinato", 4, '80', 200),
("El miedo", 5, '20', 300),
("Quimica", 6, '40', 400);

insert into Habilidades_Especiales(ID_Personaje, Nombre_Habilidad, Tipo_Habilidad)
values
(1, "Fuerza Fisica", "Fisico"),
(1, "Estiramiento", "Elastico"),
(1, "Corona Magica", "Magia"),
(2, "Reloj Magico", "transformaciones"),
(2, "Fuerza", "fisico"),
(3, "manejo de almas", "magico"),
(4, "No tiene", "no tiene"),
(4, "no tiene", "no tiene"),
(5, "No tiene", "No tiene"),
(6, "Es inteligente", "nivel genio");

insert into Villanos_Heroes(Villano_Heroe, ID_Personaje)
values
(0, 1),
(0, 2),
(1, 3),
(1, 4),
(0, 5),
(0,6),
(1, 7),
(1, 8),
(1, 9),
(0, 10);

 insert into Enemigos_Historicos(ID_Villano, ID_Heroe, Encuentros_Totales)
 values
 (1,3, 20 ),
 (2,4, 30),
 (5,7,56),
 (6,8,78),
 (9,10,100);
 
insert into Objetos_Misticos(Nombre_Objeto, ID_PersonajeDueno, Valor_Subasta)
values
("Espada", 1, 2200.00),
("No tiene", 1, 00.00),
("Corona", 1 , 1500.00),
("Reloj", 2, 2500.00),
("Espada", 2, 4000.50),
("Arma de la muerte", 3, 6000.00),
("Tv", 4, 200.00),
("Sandwich magico", 3, 8200.00);

-- consulta 1
select Series.Nombre_Serie,Creadores.ID_Creador 
from Series
inner join Creadores 
on Series.ID_Creador= Creadores.ID_Creador
order by Nombre_Serie Asc;

-- Consulta 2
select Nombre_Personaje, Rol
from Personajes
where Nombre_Personaje like '%B%' or Nombre_Personaje like '%F%';

-- Consulta 3
select * from Episodios
where Duracion_Minutos > 11
and Rating_Audencia > 8.5;

-- Consulta 4
select * from Objetos_Misticos 
where Nombre_Objeto like '%Espada%' or Nombre_Objeto like '%Anillo%';

-- Consulta 5
select min(Nivel_Energia) as Energia_Minima, max(Nivel_Energia) as Energia_Maxima
from Personajes
where rol = 'Antagonista';

-- Consulta 6
select Tipo_Habilidad, count(*) as Cantidad_Total
from Habilidades_Especiales
group by Tipo_Habilidad;

-- Consulta 7 
select Nombre_Personaje, Nivel_Energia
from Personajes
order by Nivel_Energia desc, nombre_Personaje asc;

-- Consulta 8
select ID_PersonajeDueno, sum(Valor_Subasta) as Total_recaudado
from Objetos_Misticos 
where Valor_Subasta > 5000
order by Total_recaudado desc;

-- Consulta 9
select ID_Serie, avg(Rating_Audencia) as Total_Rating
from Episodios
group by ID_Serie
having avg(Rating_Audencia) > 7.5;

-- Consulta 10
select ID_Serie, count(*) as Total_Personajes
from Personajes
group by ID_Serie;

-- Consulta 11
select avg(Duracion_Minutos) as promedioduracion
from Episodios
where Estreno > 2010;

-- Consulta 12
select ID_Personaje, count(*) as CantidadHabilidades
from Habilidades_Especiales
group by ID_Personaje;

-- Consulta 13
select ID_Rivalidad, Encuentros_totales
from Enemigos_Historicos
where Encuentros_Totales > 15
order by Encuentros_Totales desc;

-- Consulta14
select ID_PersonajeDueno, max(Valor_Subasta) as ValorMaximo
from Objetos_Misticos
where Valor_subasta > 100000
group by ID_PersonajeDueno; 

-- Consulta 15
select ID_Serie, count(*) as EpisodiosTotales
from Episodios
group by ID_Serie
order by EpisodiosTotales desc;

