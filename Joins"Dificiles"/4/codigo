create database consorcio_urbano;
use consorcio_urbano;

create table edificios
(
    IDEdificio int auto_increment primary key,
    nombre varchar(25),
    Direccion varchar(25)
);

create table unidades
(
    IDUnidad int auto_increment primary key,
    NroPiso int(2),
    IDEdificio int,
    foreign key (IDEdificio) references edificios(IDEdificio)
);

create table expensas
(
    IDExpensa int auto_increment primary key,
    IDUnidad int,
    Monto decimal,
    Estado enum('pago', 'impago'),

    foreign key (IDUnidad) references unidades(IDUnidad)
);

insert into edificios (nombre, Direccion)
values
('torre nebula', 'av. solar 1450'),
('residencias quantum', 'calle atlas 932'),
('edificio eclipse', 'boulevard central 210'),
('skyline point', 'av. horizonte 778'),
('portal aurora', 'calle luna 554');

insert into unidades (NroPiso, IDEdificio)
values
(1, 1),
(3, 1),
(5, 2),
(7, 3),
(10, 5);

insert into expensas (IDUnidad, Monto, Estado)
values
(1, 18500, 'pago'),
(2, 22300, 'impago'),
(3, 19800, 'pago'),
(4, 27500, 'impago'),
(5, 31200, 'pago');

select edificios.nombre as edificio, sum(expensas.Monto) as totalimpagas, count(expensas.IDExpensa) as unidades_en_mora
from edificios
inner join unidades
on edificios.IDEdificio = unidades.IDEdificio
inner join expensas
on unidades.IDUnidad = expensas.IDUnidad
where expensas.Estado = 'impago'
group by edificios.IDEdificio, edificios.nombre
having sum(expensas.Monto) > 1000000 and count(expensas.IDExpensa) > 5;

select edificios.nombre as edificio, avg(expensas.Monto) as promedioexpensas
from edificios
inner join unidades
on edificios.IDEdificio = unidades.IDEdificio
inner join expensas
on unidades.IDUnidad = expensas.IDUnidad
where expensas.Estado = 'pago'
group by edificios.IDEdificio, edificios.nombre
having avg(expensas.Monto) >= 20000;

select edificios.nombre as edificio, sum(expensas.Monto) as recaudaciontotal
from edificios
inner join unidades
on edificios.IDEdificio = unidades.IDEdificio
inner join expensas
on unidades.IDUnidad = expensas.IDUnidad
where expensas.Estado = 'pago'
group by edificios.IDEdificio, edificios.nombre
order by recaudaciontotal desc
limit 3;
