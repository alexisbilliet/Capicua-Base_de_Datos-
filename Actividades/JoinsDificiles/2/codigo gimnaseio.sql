create database gimnasio;
use gimnasio;

create table socios (
    IDSocio int auto_increment primary key,
    nombre varchar(100) not null,
    fechainscripcion date not null
);

create table planes (
    IDPlan int auto_increment primary key,
    tipo varchar(50) not null,
    costo decimal(10,2) not null
);

create table pagos (
    IDPago int auto_increment primary key,
    IDSocio int not null,
    foreign key (IDSocio) references socios(IDSocio),
    IDPlan int not null,
	foreign key (IDPlan) references planes(IDPlan),
    monto decimal,
    fecha date 
);

insert into socios (nombre, fechainscripcion) values
('Thiago', '2026-01-15'),
('Valentina', '2026-02-03'),
('Lautaro', '2026-02-20'),
('Camila', '2026-03-11'),
('Santino', '2026-04-05');

insert into planes (tipo, costo) values
('musculacion', 18000),
('premium ', 32000),
('crossfit', 25000),
('funcional', 21000);

insert into pagos (IDSocio, IDPlan, monto, fecha) values
(1, 2, 32000, '2026-05-01'),
(2, 1, 18000, '2026-05-02'),
(3, 3, 25000, '2026-05-03'),
(4, 4, 21000, '2026-05-04'),
(5, 2, 32000, '2026-05-05');

select socios.nombre, count(pagos.IDPago) as CantidadDePagos, sum(pagos.monto) as Total
from socios
inner join pagos
on pagos.IDSocio = socios.IDSocio
group by socios.nombre
having sum(pagos.monto) >= 32000;

select planes.tipo, sum(pagos.monto) as Recaudado
from planes
inner join pagos
on pagos.IDPlan = planes.IDPlan
inner join socios
on socios.IDSocio = pagos.IDSocio
group by planes.IDPlan
having count(socios.IDSocio) > 50 and sum(pagos.monto) > 50000;

select socios.nombre
from socios
inner join pagos
on socios.IDSocio = pagos.IDSocio
inner join planes
on planes.IDPlan = pagos.IDPlan
group by socios.IDSocio, socios.nombre, planes.IDPlan, planes.tipo
having count(pagos.IDPago) > 3;
