create database Serie;
-- drop database Serie
use Serie;

create table Creadores
(
	IDCreador int not null auto_increment primary key,
    Nombre varchar(25),
    Apellido varchar(25),
    edad int
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
	Duracion time,
    rating int
);
create table HablididadesEspeciales
(
	IDHabilidad int not null auto_increment primary key,
    IDPersonaje int,
    foreign key(IDPersonaje) references Personajes(IDPersonaje),
    Nombre Varchar(25),
	Tipo Varchar(25)
);
create table Rivalidades
(
	IDRivalidade int not null auto_increment primary key,
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
("Christopher", "Scorsese", 73)