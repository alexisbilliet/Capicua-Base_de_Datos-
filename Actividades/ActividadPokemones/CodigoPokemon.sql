Create database PKM;
-- DROP DATABASE PKM
use PKM;

Create table Regiones
(
	IDRegion int primary key not null auto_increment,
    Nombre varchar(25),
    Clima varchar(25)
);
Create table Ciudades
(
	IDCiudades int primary key not null auto_increment,
    Nombre varchar(25),
    Poblacion int, 
    IDRegion int,
    foreign key (IDRegion) references Regiones(IDRegion)
);
Create table Entrenadores
(
	IDEntrenador int primary key not null auto_increment,
    Nombre varchar(25),
    Edad int, 
    IDCiudad int,
    foreign key (IDCiudad) references Ciudades(IDCiudad)
);
Create table Especies
(
	IDEspecie int primary key not null auto_increment,
    Nombre varchar(25),
    NumPokeDex int, 
    TipoElemento varchar(25),
    IDRegion int,
    foreign key (IDRegion) references Regiones(IDRegion)
);
Create table Pokemones
(
	IDPokemon int primary key not null auto_increment,
    Nombre varchar(25),
    Nivel int,
    IDEntrenador int,
    foreign key (IDEntrenador) references Entrenadores(IDEntrenador),
    IDEspecie int,
    foreign key (IDEspecie) references Especies(IDEspecie)
);
Create table Evoluciones
(
	IDEspecie int primary key not null auto_increment,
    Nombre varchar(25),
    NumPokeDex int, 
    TipoElemento varchar(25),
    IDRegion int,
    foreign key (IDRegion) references Regiones(IDRegion)
);