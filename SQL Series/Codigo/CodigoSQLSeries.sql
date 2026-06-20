create database SQLSeries;
-- drop database SQLSeries
use SQLSeries;

create table directores
(
 IDDirector int primary key auto_increment not null,
 nombre varchar(25),
 Edad int(2),
 Sueldo float
);
create table actores
(
 IDActor int primary key auto_increment not null,
 nombre varchar(25),
 Apellido varchar(25)
);
create table series
( 
 IDSerie int primary key auto_increment not null,
 nombre varchar(25),
 GeneroPrincipal varchar(25),
 AñoLanzamiento year,
 Presupuesto float,
 IDDirector int,
 foreign key (IDDirector) references directores(IDDirector)
);
create table plataformas
(
 IDPlataforma int primary key auto_increment not null,
 nombre varchar(25),
 AñoLanzamiento year
);
create table series_plataformas
(
 IDSerie_Plataforma int primary key auto_increment not null,
 IDPlataforma int,
 foreign key (IDPlataforma) references plataformas(IDPlataforma),
 IDSerie int,
 foreign key (IDSerie) references series(IDSerie)
);
create table personajes
(
 IDPersonajes int primary key auto_increment not null,
 Nombre varchar(25),
 edad int(3), 
 Genero enum("M", "F"),
 IDActor int,
 foreign key (IDActor) references actores(IDActor)
);
create table temporadas
(
 IDTemporada int primary key auto_increment not null,
 NumTemp int(2),
 Nombre varchar(25),
 descripcion text, 
 IDSerie int,
 foreign key (IDSerie) references series(IDSerie)
);
create table episodios
(
 IDEpisodio int primary key auto_increment not null,
 NumEp int,
 Nombre varchar(25),
 descripcion text, 
 puntuacion decimal(3,1),
 IDTemporada int,
 foreign key (IDTemporada) references temporadas(IDTemporada)
);

create table episodios_personajes
(
 IDEpisodio_Personaje int primary key auto_increment not null,
 IDPersonaje int,
 foreign key (IDPersonaje) references personajes(IDPersonajes),
 IDEpisodio int,
 foreign key (IDEpisodio) references episodios(IDEpisodio)
);
insert into directores (nombre, Edad, Sueldo) values
("Duffer Brothers", 40, 500000),
("Christopher Storer", 43, 350000),
("Craig Mazin", 53, 900000),
("Mark Mylod", 59, 750000),
("Eric Kripke", 50, 400000),
("Charlie Brooker", 53, 300000),
("Declan Lowney", 63, 450000),
("Ben Stiller", 58, 800000),
("Jonathan Nolan", 47, 1200000),
("Baran bo Odar", 46, 280000);

insert into series (nombre, GeneroPrincipal, AñoLanzamiento, Presupuesto, IDDirector) values
("Stranger Things","Sci-Fi",2016,30000000,1),
("The Bear","Drama",2022,12000000,2),
("The Last of Us","Post-apoc",2023,100000000,3),
("Succession","Drama",2018,90000000,4),
("The Boys","Acción",2019,11000000,5),
("Black Mirror","Antología",2011,5000000,6),
("Ted Lasso","Comedia",2020,15000000,7),
("Severance","Suspenso",2022,40000000,8),
("Fallout","Sci-Fi",2024,150000000,9),
("Dark","Intriga",2017,18000000,10);

insert into plataformas (nombre, AñoLanzamiento) values
("Netflix",1997),
("Disney+",2019),
("Max",2020),
("Prime Video",2006),
("Apple TV",2019);

insert into series_plataformas (IDPlataforma, IDSerie) values
(1,1),(2,2),(3,3),(3,4),(4,5),(1,6),(5,7),(5,8),(4,9),(1,10);

insert into temporadas (NumTemp, Nombre, descripcion, IDSerie) values
(1,"Stranger Things 1","Desaparición de Will",1),
(4,"Stranger Things 4","El regreso de Vecna",1),
(1,"The Bear S1","El caos en la cocina",2),
(1,"The Last of Us S1","El viaje de Joel y Ellie",3),
(4,"Succession S4","La guerra final",4),
(1,"The Boys S1","Los héroes son malos",5),
(1,"Black Mirror S1","Tecnología y pesadillas",6),
(1,"Ted Lasso S1","Un DT de fútbol americano en UK",7),
(1,"Severance S1","Separación cerebral laboral",8),
(1,"Fallout S1","Salida del refugio 33",9);

insert into personajes (Nombre, edad, Genero) values
("Eleven",14,"F"),
("Carmy Berzatto",28,"M"),
("Joel Miller",52,"M"),
("Ellie Williams",14,"F"),
("Kendall Roy",40,"M"),
("Homelander",38,"M"),
("Ted Lasso",45,"M"),
("Mark Scout",42,"M"),
("Lucy MacLean",22,"F"),
("Jonas Kahnwald",17,"M");

insert into episodios (NumEp, Nombre, descripcion, puntuacion, IDTemporada) values
(101,"El mundo del revés","El inicio de todo",9.2,1),
(102,"Dear Billy","El escape de Max",9.8,2),
(103,"Sistema","El servicio más intenso",9.5,3),
(104,"Mucho tiempo","La historia de Bill y Frank",9.9,4),
(105,"Connor's Wedding","Un giro inesperado",10.0,5),
(106,"El nombre del juego","Hughie se une a los Boys",8.8,6),
(107,"Himno Nacional","El episodio del primer ministro",8.1,7),
(108,"Piloto","Ted llega a Richmond",8.5,8),
(109,"Lo que somos","El final de temporada",9.7,9),
(110,"El fin","Descubrimientos en el yermo",9.4,10);