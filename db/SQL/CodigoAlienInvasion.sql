Create database Alien_Invasion;
-- drop database Alien_Invasion
Use Alien_Invasion;

Create table Niveles (
    IDNivel int primary key auto_increment not null,
    MultiDano decimal (10,2),
    MultiVel decimal(10,2),
    Multivida decimal(10,2),
    PuntosNecesarios int
);

Create table TiposAcciones (
    IDTipoAccion int primary key auto_increment not null,
    Nombre varchar (25),
    Descripcion text
);

Create table Efectos (
    IDEfecto int primary key auto_increment not null,
    Nombre varchar (50),
    DPS int,
    Duracion int,
    Descripcion text
);

Create table Municiones (
    IDMunicion int primary key auto_increment not null, 
    Nombre varchar (50),
    MultiDano decimal (10,2),
    Descripcion text,
    IDEfecto int,
    foreign key (IDEfecto) references Efectos(IDEfecto)
);

Create table Players (
    IDPlayer int primary key auto_increment not null,
    Nombre varchar (50),
    Dinero decimal(10,2),
    Edad int
);

Create table Naves (
    IDNave int primary key auto_increment not null, 
    Nombre varchar (50),
    Vida int,
    Dano int,
    Velocidad int,
    Cadencia decimal(10,2),
    Costo decimal (10,2)
);

Create table PowerUps (
    IDPowerUp int primary key auto_increment not null, 
    Nombre varchar (50),
    Descripcion text,
    Duracion time
);

Create table PatronMovimientos (
    IDPatronMovimiento int primary key auto_increment not null,
    Nombre varchar (50),
    Descripcion text,
    Velocidad decimal(10,2)
);

Create table AliensFactions (
    IDAlienFaction int primary key auto_increment not null,
    Nombre varchar (50),
    ResistenciaBase decimal(10,2),
    SpriteBase varchar (100),
    IDPatronMovimiento int,
    foreign key (IDPatronMovimiento) references PatronMovimientos(IDPatronMovimiento)
);

Create table AliensTypes (
    IDAlienType int primary key auto_increment not null,
    Nombre varchar (50),
    Vida int,
    Velocidad int,
    Dano int,
    PuntosOtorgados int,
    VelDisparos decimal(10,2),
    IDAlienFaction int,
    foreign key (IDAlienFaction) references AliensFactions(IDAlienFaction)
);

Create table Sessions (
    IDSession int primary key auto_increment not null,
    FechaInicio datetime,
    FechaFin datetime,
    EstadoFinal enum("Abandonado", "Victoria", "Derrota"),
    IDPlayer int,
    foreign key (IDPlayer) references Players(IDPlayer)
);

Create table RegistrosNiveles (
    IDRegistroNivel int primary key auto_increment not null,
    TiempoInvertido time,
    EnemigosEliminados int,
    PuntajeTotal int,
    IDSession int,
    foreign key(IDSession) references Sessions(IDSession),
	IDNivel int,
    foreign key (IDNivel) references Niveles(IDNivel)
);

Create table PlayersAction (
    IDPlayerAction int primary key auto_increment not null,
    Time_Stamp datetime,
    Impactos int,
    Fallos int,
    IDSession int,
    foreign key (IDSession) references Sessions(IDSession),
	IDTipoAccion int,
    foreign key (IDTipoAccion) references TiposAcciones(IDTipoAccion),
	IDMunicion int,
    foreign key (IDMunicion) references Municiones(IDMunicion)
);

Create table NavesPlayers (
    IDNaveJugador int primary key auto_increment not null,
    IDPlayer int,
    IDNave int,
    foreign key (IDNave) references Naves(IDNave),
    foreign key (IDPlayer) references Players(IDPlayer)
);

Create table PowerUpsUtilizados (
    IDPowerUpUtilizado int primary key auto_increment not null,
    Time_Stamp DATETIME,
    IDSession int,
    foreign key (IDsession) references Sessions(IDSession),
    IDPowerUp int,
    foreign key (IDPowerUp) references 	PowerUps(IDPowerUp)
);

Create table ConfigOleadas (
    IDConfigOleada int primary key auto_increment not null,
    TasaSpawn decimal (10,2),
    CantidadDeAliens int,
    Oleada int,
    MultiplicadorDificultad decimal (10,2)
);

Create table ProgresoOleadas (
    IDProgresoOleada int primary key auto_increment not null,
    TimeStampElim datetime,
    PuntosAcumulados int,
    IDSession int,
    foreign key(IDsession) references Sessions(IDSession),
	IDConfigOleada int,
    foreign key (IDConfigOleada) references ConfigOleadas(IDConfigOleada),
	IDAlienType int,
    foreign key (IDAlienType) references AliensTypes(IDAlienType)
);

Create table AliensOleadas (
    IDAlienOleada int primary key auto_increment not null,
    NivelAlien int,
    IDProgresoOleada int,
    foreign key (IDProgresoOleada) references progresoOleadas(IDProgresoOleada),
    IDAlienType int,
   foreign key (IDAlienType) references AliensTypes(IDAlienType)
);

-- Jugadores y sus naves
DELIMITER //

CREATE PROCEDURE JugadoresYSusNaves(in xnombre varchar(50))
BEGIN
    select Players.Nombre as NombreJugador, Naves.Nombre as NombreNave
    from Players
    inner join NavesPlayers on Players.IDPlayer = NavesPlayers.IDPlayer
    inner join Naves on NavesPlayers.IDNave = Naves.IDNave
    where Players.Nombre = xnombre;
END //

DELIMITER ;


-- Aliens y sus facciones
DELIMITER //

CREATE PROCEDURE AliensYSusFacciones()
BEGIN
    select AliensTypes.Nombre as NombreAlien, AliensFactions.Nombre as NombreFaccion
    from AliensTypes
    inner join AliensFactions on AliensTypes.IDAlienFaction = AliensFactions.IDAlienFaction;
END //

DELIMITER ;


-- Municiones y sus características
DELIMITER //

CREATE PROCEDURE MunicionesYSusCaracteristicas()
BEGIN
    select Municiones.Nombre as NombreMunicion, Municiones.multidano as DanoMuniciones, Municiones.Descripcion as DescripcionMuniciones, Efectos.Nombre as NombreEfecto, Efectos.Dps,Efectos.Duracion
    from Municiones
    inner join Efectos on Municiones.IDEfecto = Efectos.IDEfecto;
END //

DELIMITER ;


-- Partidas de cada jugador
DELIMITER //

CREATE PROCEDURE PartidasDeCadaJugador(in xnombre varchar(50))
BEGIN
    select Players.Nombre as jugador, Sessions.IDSession as Partida, Sessions.FechaInicio, Sessions.FechaFin, Sessions.EstadoFinal
    from Players
    inner join Sessions on Players.IDPlayer = Sessions.IDPlayer
    where Players.Nombre = xnombre;
END //

DELIMITER ;


-- Nivel alcanzado de los jugadores
DELIMITER //

CREATE PROCEDURE NivelAlcanzadoDeLosJugadores()
BEGIN
    select Players.Nombre as NombreJugador, MAX(RegistrosNiveles.IDNivel) as NivelAlcanzado,SUM(RegistrosNiveles.EnemigosEliminados) as EnemigosEliminados, MAX(RegistrosNiveles.PuntajeTotal) as PuntajeTotal
    from Players
    inner join Sessions on Players.IDPlayer = Sessions.IDPlayer
    inner join RegistrosNiveles on Sessions.IDSession = RegistrosNiveles.IDSession
    group by Players.IDPlayer, Players.Nombre;
END //

DELIMITER ;
