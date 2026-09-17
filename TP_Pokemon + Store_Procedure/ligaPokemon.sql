
create database ligapokemon;
use ligapokemon;

create table ciudades (
    id_ciudad int auto_increment primary key,
    nombre varchar(30) not null
);

create table entrenadores (
    id_entrenador int auto_increment primary key,
    nombre varchar(30) not null,
    apellido varchar(30) not null,
    id_ciudad int,
    foreign key (id_ciudad) references ciudades(id_ciudad)
);

create table gimnasios (
    id_gimnasio int auto_increment primary key,
    nombre varchar(30) not null,
    direccion varchar(50),
    id_ciudad int,
    id_entrenador int,
    foreign key (id_ciudad) references ciudades(id_ciudad),
    foreign key (id_entrenador) references entrenadores(id_entrenador)
);

create table pokemones (
    id_pokemon int auto_increment primary key,
    nombre varchar(30) not null,
    nivel_poder int not null,
    id_entrenador int,
    foreign key (id_entrenador) references entrenadores(id_entrenador)
);

create table tiposelementos (
    id_tipoelemento int auto_increment primary key,
    tipo varchar(30) not null,
    descripcion text
);

create table pokemonestiposelementos (
    id_pokemontipoelemento int auto_increment primary key,
    id_pokemon int,
    id_tipoelemento int,
    foreign key (id_pokemon) references pokemones(id_pokemon),
    foreign key (id_tipoelemento) references tiposelementos(id_tipoelemento)
);

create table batallas (
    id_batalla int auto_increment primary key,
    fecha date not null,
    id_ganador int,
    id_perdedor int,
    id_gimnasio int,
    foreign key (id_gimnasio) references gimnasios(id_gimnasio),
    foreign key (id_ganador) references pokemones(id_pokemon),
    foreign key (id_perdedor) references pokemones(id_pokemon)
);

insert into ciudades (nombre) values
('rosario'),
('medellin'),
('buenos aires'),
('celadon');

insert into entrenadores (nombre, apellido, id_ciudad) values
('santiago', 'fidani', 2),
('agustin', 'barrionuevo', 1),
('mia', 'pirro', 3),
('emma', 'myers', 1),
('erika', 'grass', 4);

insert into pokemones (nombre, nivel_poder, id_entrenador) values
('pikachu', 9756, 4),
('lucario', 9831, 3),
('charizard', 9867, 2),
('greninja', 9954, 1),
('vileplume', 4500, 5);

insert into tiposelementos (tipo, descripcion) values
('electrico', 'ataques electricos'),
('fuego', 'ataques de fuego'),
('agua', 'ataques de agua'),
('lucha', 'ataques fisicos'),
('planta', 'ataques de planta');

insert into pokemonestiposelementos (id_pokemon, id_tipoelemento) values
(1, 1),
(2, 4),
(3, 2),
(4, 3),
(5, 5);

insert into gimnasios (nombre, direccion, id_ciudad, id_entrenador) values
('gimnasio central', 'av. principal 123', 1, 2),
('gimnasio elite', 'calle 45 #210', 3, 3),
('gimnasio arcoiris', 'ruta 7 #42', 4, 5);

insert into batallas (fecha, id_ganador, id_perdedor, id_gimnasio) values
('2026-08-01', 4, 1, 1),
('2026-08-02', 3, 2, 2);

select e.nombre as entrenador, c.nombre as ciudad, g.nombre as gimnasio
from entrenadores e
join ciudades c on e.id_ciudad = c.id_ciudad
join gimnasios g on e.id_entrenador = g.id_entrenador;

select p.nombre as pokemon, t.tipo as tipoelemento
from pokemones p
join pokemonestiposelementos pte on p.id_pokemon = pte.id_pokemon
join tiposelementos t on pte.id_tipoelemento = t.id_tipoelemento;

select nombre, nivel_poder
from pokemones
where nivel_poder > 50;

select p.nombre as pokemon, p.nivel_poder, e.nombre as entrenador
from pokemones p
join pokemonestiposelementos pte on p.id_pokemon = pte.id_pokemon
join tiposelementos t on pte.id_tipoelemento = t.id_tipoelemento
join entrenadores e on p.id_entrenador = e.id_entrenador
where t.tipo = 'fuego'
order by p.nivel_poder asc;

select nombre
from pokemones
where id_entrenador in (
    select id_entrenador 
    from entrenadores
    where id_ciudad in (
        select id_ciudad 
        from ciudades 
        where nombre = 'celadon')
);

select nombre, nivel_poder
from pokemones
where nivel_poder > (select avg(nivel_poder) from pokemones);

select nombre
from pokemones
where id_pokemon in (
    select distinct id_ganador 
    from batallas
);


