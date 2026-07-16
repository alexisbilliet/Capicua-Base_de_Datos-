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
	IDCiudad int primary key not null auto_increment,
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
	IDEvolucion int primary key not null auto_increment,
    IDFaseNueva int,
    foreign key (IDFaseNueva) references Especies(IDEspecie),
    IDFasePrevia int,
    foreign key (IDFasePrevia) references Especies(IDEspecie)
);
Create table HistorialEvoluciones
(
	IDHistorial int primary key not null auto_increment,
    Fecha date, 
    MetodoEvolucion text,
    IDPokemon int,
    foreign key (IDPokemon) references Pokemones(IDPokemon),
    IDEvolucion int,
    foreign key (IDEvolucion) references Evoluciones(IDEvolucion)
);
Create table Gimnasios
(
	IDGimnasio int primary key not null auto_increment,
    Nombre Varchar(50), 
    TipoElemento varchar(25),
    IDLider int,
    foreign key (IDLider) references Entrenadores(IDEntrenador),
    IDCiudad int,
    foreign key (IDCiudad) references Ciudades(IDCiudad)
);
Create table Equipos
(
	IDEquipo int primary key not null auto_increment,
    ObjetoEquipado Varchar(25), 
    IDPokemon int,
    foreign key (IDPokemon) references Pokemones(IDPokemon)
);
Create table Batallas
(
	IDBatalla int primary key not null auto_increment,
    Fecha date, 
    Ganador enum("Atacante", "Defensor"),
    IDAtacante int,
    foreign key (IDAtacante) references Entrenadores(IDEntrenador),
    IDDefensor int,
    foreign key (IDDefensor) references Entrenadores(IDEntrenador),
    IDEquipoAtacante int,
    foreign key (IDEquipoAtacante) references Equipos(IDEquipo),
    IDEquipoDefensor int,
    foreign key (IDEquipoDefensor) references Equipos(IDEquipo)
);
Create table BatallasGimnasios
(
	IDBatallaGimnasio int primary key not null auto_increment,
    IDBatalla int,
    foreign key (IDBatalla) references Batallas(IDBatalla),
    IDGimnasio int,
    foreign key (IDGimnasio) references Gimnasios(IDGimnasio)
);
