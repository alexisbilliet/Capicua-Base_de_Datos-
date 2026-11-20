create database Alien_Invasion;
-- drop database Alien_Invasion
use Alien_Invasion;

create table Niveles (
    IDNivel int primary key auto_increment not null,
    Nivel int not null unique,
    MultiDano decimal(10,2),
    MultiVel decimal(10,2),
    Multivida decimal(10,2),
    PuntosNecesarios int
);

create table TiposAcciones (
    IDTipoAccion int primary key auto_increment not null,
    Nombre varchar(25),
    Descripcion text
);

create table Efectos (
    IDEfecto int primary key auto_increment not null,
    Nombre varchar(50),
    DPS int,
    Duracion int,
    Descripcion text
);

create table Municiones (
    IDMunicion int primary key auto_increment not null,
    Nombre varchar(50),
    MultiDano decimal(10,2),
    Descripcion text,
    IDEfecto int,
    foreign key (IDEfecto) references Efectos(IDEfecto)
);

create table PatronMovimientos (
    IDPatronMovimiento int primary key auto_increment not null,
    Nombre varchar(50),
    Descripcion text,
    Velocidad decimal(10,2)
);

create table AliensFactions (
    IDAlienFaction int primary key auto_increment not null,
    Nombre varchar(50),
    ResistenciaBase decimal(10,2),
    SpriteBase varchar(100),
    IDPatronMovimiento int,
    foreign key (IDPatronMovimiento) references PatronMovimientos(IDPatronMovimiento)
);

create table AliensTypes (
    IDAlienType int primary key auto_increment not null,
    Nombre varchar(50),
    Vida int,
    Velocidad int,
    Dano int,
    PuntosOtorgados int,
    VelDisparos decimal(10,2),
    IDAlienFaction int,
    foreign key (IDAlienFaction) references AliensFactions(IDAlienFaction)
);

create table Players (
    IDPlayer int primary key auto_increment not null,
    Nombre varchar(50) not null unique,
    Dinero decimal(10,2),
    Edad int
);

create table Naves (
    IDNave int primary key auto_increment not null,
    Nombre varchar(50),
    Vida int,
    Dano int,
    Velocidad int,
    Cadencia decimal(10,2),
    Costo decimal(10,2)
);

create table PowerUps (
    IDPowerUp int primary key auto_increment not null,
    Nombre varchar(50),
    Descripcion text,
    Duracion time
);

create table Sessions (
    IDSession int primary key auto_increment not null,
    FechaInicio datetime,
    FechaFin datetime,
    EstadoFinal enum('Abandonado', 'Victoria', 'Derrota'),
    IDPlayer int,
    foreign key (IDPlayer) references Players(IDPlayer)
);

create table RegistrosNiveles (
    IDRegistroNivel int primary key auto_increment not null,
    TiempoInvertido time,
    EnemigosEliminados int,
    PuntajeTotal int,
    IDSession int,
    foreign key (IDSession) references Sessions(IDSession),
    IDNivel int,
    foreign key (IDNivel) references Niveles(IDNivel)
);

create table PlayersAction (
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

create table NavesPlayers (
    IDNaveJugador int primary key auto_increment not null,
    IDPlayer int,
    IDNave int,
    foreign key (IDNave) references Naves(IDNave),
    foreign key (IDPlayer) references Players(IDPlayer),
    unique (IDPlayer, IDNave)
);

create table PowerUpsUtilizados (
    IDPowerUpUtilizado int primary key auto_increment not null,
    Time_Stamp datetime,
    IDSession int,
    foreign key (IDSession) references Sessions(IDSession),
    IDPowerUp int,
    foreign key (IDPowerUp) references PowerUps(IDPowerUp)
);

create table ConfigOleadas (
    IDConfigOleada int primary key auto_increment not null,
    TasaSpawn decimal(10,2),
    CantidadDeAliens int,
    Oleada int,
    MultiplicadorDificultad decimal(10,2)
);

create table ProgresoOleadas (
    IDProgresoOleada int primary key auto_increment not null,
    TimeStampElim datetime,
    PuntosAcumulados int,
    IDSession int,
    foreign key (IDSession) references Sessions(IDSession),
    IDConfigOleada int,
    foreign key (IDConfigOleada) references ConfigOleadas(IDConfigOleada),
    IDAlienType int,
    foreign key (IDAlienType) references AliensTypes(IDAlienType)
);

create table AliensOleadas (
    IDAlienOleada int primary key auto_increment not null,
    NivelAlien int,
    IDProgresoOleada int,
    foreign key (IDProgresoOleada) references ProgresoOleadas(IDProgresoOleada),
    IDAlienType int,
    foreign key (IDAlienType) references AliensTypes(IDAlienType)
);

insert into Niveles (Nivel, MultiDano, MultiVel, Multivida, PuntosNecesarios) values
(1, 1.00, 1.00, 1.00, 0),
(2, 1.15, 1.10, 1.25, 500),
(3, 1.30, 1.20, 1.50, 1200),
(4, 1.45, 1.30, 1.75, 2200),
(5, 1.60, 1.40, 2.00, 3500),
(6, 1.75, 1.50, 2.25, 5000),
(7, 1.90, 1.60, 2.50, 7000),
(8, 2.05, 1.70, 2.75, 9500),
(9, 2.20, 1.80, 3.00, 12500),
(10, 2.35, 1.90, 3.25, 16000);

insert into TiposAcciones (Nombre, Descripcion) values
('Disparo', 'Disparo realizado por el jugador'),
('Impacto', 'Disparo que impacto contra un enemigo'),
('Fallo', 'Disparo que no impacto contra un enemigo');

insert into Efectos (Nombre, DPS, Duracion, Descripcion) values
('Sin efecto', 0, 0, 'Municion sin efecto especial');

insert into Municiones (Nombre, MultiDano, Descripcion, IDEfecto) values
('Normal', 1.00, 'Municion basica del jugador', 1);

insert into PatronMovimientos (Nombre, Descripcion, Velocidad) values
('Formacion', 'Movimiento coordinado en formacion', 1.00),
('Descenso', 'Movimiento de avance y descenso', 1.20),
('Erratico', 'Movimiento irregular', 1.40);

insert into AliensFactions (Nombre, ResistenciaBase, SpriteBase, IDPatronMovimiento) values
('Exploradores', 1.00, 'alien.png', 1),
('Soldados', 1.50, 'alien.png', 2),
('Destructores', 2.00, 'alien.png', 3);

insert into AliensTypes (Nombre, Vida, Velocidad, Dano, PuntosOtorgados, VelDisparos, IDAlienFaction) values
('Alien 1', 10, 40, 10, 10, 4.00, 1),
('Alien 2', 20, 55, 15, 20, 5.00, 2),
('Alien 3', 30, 70, 25, 30, 6.00, 3);

insert into Naves (Nombre, Vida, Dano, Velocidad, Cadencia, Costo) values
('Cazador', 3, 10, 250, 0.35, 0.00),
('Fortaleza', 5, 7, 180, 0.50, 0.00),
('Relampago', 2, 14, 350, 0.20, 0.00);

insert into PowerUps (Nombre, Descripcion, Duracion) values
('Disparo rapido', 'Aumenta temporalmente la cadencia de disparo', '00:00:10'),
('Escudo', 'Reduce temporalmente el dano recibido', '00:00:10'),
('Dano aumentado', 'Aumenta temporalmente el dano del jugador', '00:00:10');

insert into ConfigOleadas (TasaSpawn, CantidadDeAliens, Oleada, MultiplicadorDificultad) values
(1.00, 54, 1, 1.00),
(1.00, 54, 2, 1.00),
(1.00, 54, 3, 1.00);
