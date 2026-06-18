create database Serie;
-- drop database Serie
use Serie;

create table Creadores
(
	IDCreador int not null auto_increment primary key,
    Nombre varchar(25),
    Apellido varchar(25),
    Edad int
);
create table Series
(
	IDSerie int not null auto_increment primary key,
    Nombre varchar(25),
    Estreno year,
    IDCreador int,
    foreign key (IDCreador) references Creadores(IDCreador)
);
create table Personajes
(
	IDPersonaje int not null auto_increment primary key,
    Nombre varchar(25),
    IDSerie int,
    foreign key(IDSerie) references Series(IDSerie),
    Rol Varchar(25),
	NivelEnergia int
);
create table Episodios
(
	IDEpisodio int not null auto_increment primary key,
    Titulo varchar(25),
    IDSerie int,
    foreign key(IDSerie) references Series(IDSerie),
	DuracionMinutos int,
    Rating float
);
create table HablididadesEspeciales
(
	IDHabilidad int not null auto_increment primary key,
    Nombre Varchar(25),
	Tipo Varchar(25)
);
create table HablididadesPersonajes
(
	IDHabilidadPersonaje int not null auto_increment primary key,
    IDPersonaje int,
    foreign key (IDPersonaje) references Personajes(IDPersonaje),
    IDHabilidad int,
    foreign key (IDHabilidad) references HablididadesEspeciales(IDHabilidad)
);
create table Rivalidades
(
	IDRivalidad int not null auto_increment primary key,
    IDHeroe int,
    foreign key(IDHeroe) references Personajes(IDPersonaje),
    IDVillano int,
    foreign key(IDVillano) references Personajes(IDPersonaje),
    Encuentros int
);
create table ObjetosMisticos
(
	IDObjeto int not null auto_increment primary key,
    Nombre varchar(25),
    IDPersonajeDuenio int,
    foreign key(IDPersonajeDuenio) references Personajes(IDPersonaje),
    ValorSubasta int
);

insert into Creadores(Nombre, Apellido, edad) values
("Quentin", "Tarantino", 63),
("Martin", "Scorsese", 73),
("Christopher", "Nolan", 73);

insert into Series(Nombre, Estreno, IDCreador) values
("Hora De Aventura", 2010, 1),
("Ben 10", 2005, 1),
("Billy y Mandy", 2003, 2),
("Un Show Mas", 2010, 2),
("Coraje el Perro Cobarde", 1999, 3),
("El laboratorio de Dexter", 1996, 3);

insert into Personajes(Nombre, IDSerie, Rol, NivelEnergia) values
("Finn El Humano", 1, "Protagonista", 85),
("Jake el Perro", 1, "Protagonista", 90),
("Rey Helado", 1, "Antagonista", 75),
("Ben Tennyson", 2, "Protagonista", 95),
("Vilgax", 2, "Antagonista", 98),
("Puro Hueso", 3, "Secundario", 80),
("Mordecai", 4, "Protagonista", 60),
("Rigby", 4, "Protagonista", 55),
("Coraje", 5, "Protagonista", 40),
("Dexter", 6, "Protagonista", 70);

insert into Episodios(Titulo, IDSerie, DuracionMinutos, Rating) values
("Rescate de Jake", 1, 40, 8.7),
("El Omnitrix", 2, 22, 6.9),
("El problema de Billy", 3, 27, 4.9),
("El regreso del diablo", 4, 32, 9.4),
("Cobardia", 5, 21, 7.1),
("La explosion", 6, 34, 8.1);

insert into HablididadesEspeciales(Nombre, Tipo) values
("Uso de la Espada", "Cuerpo a Cuerpo"),
("Elongacion", "Apoyo"),
("Hielo", "Ataque a distancia"),
("Convertirse", "Transformacion"),
("Proyeccion de Energio", "Ataque a distancia"),
("Telequinesis", "Ataque a distancia"),
("Artes Marciales", "Cuerpo a Cuerpo"),
("agujeros negros", "Creacion"),
("Valentia", "Apoyo"),
("Superdotado", "Apoyo");

insert into HablididadesPersonajes(IDPersonaje, IDHabilidad) values
(1,1), (2,2), (3,3), (4,4), (5,5), (6,6), (7,7), (8,8), (9,9), (10,10);

insert into ObjetosMisticos(Nombre, IDPersonajeDuenio, ValorSubasta) values
("Espada de Diamante", 1, 1000000),
("BMO", 2, 50000),
("Corona Magica", 3, 800000),
("Omnitrix", 4, 9999999),
("Ascalon", 5, 100000),
("Hueso de Percebe", 6, 100000000),
("El Poder", 7, 250000),
("Guantes de la Suerte", 8, 200000),
("Coraje", 5, "Protagonista", 40),
("Dexter", 6, "Protagonista", 70);

