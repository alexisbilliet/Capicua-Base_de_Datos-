create database ecommerce_tecnologia;
-- drop database ecommerce_tecnologia
use ecommerce_tecnologia;

create table categorias
(
    IDCategoria int auto_increment primary key not null,
    nombre varchar(25)
);

create table productos
(
    IDProducto int auto_increment primary key,
    Nombre varchar(25),
    Precio decimal,
    IDCategoria int,
    foreign key (IDCategoria) references categorias(IDCategoria)
);

create table detalleventa
(
    IDDetalle int auto_increment primary key,
    IDProducto int,
    Cantidad int,
    PrecioUnidad decimal,
    fecha date,

    foreign key (IDProducto) references productos(IDProducto)
);

insert into categorias (nombre) values
('gaming extremo'),
('smart home'),
('audio premium'),
('movilidad tech'),
('oficina digital');

insert into productos (Nombre, Precio, IDCategoria) values
('teclado vortex x90', 1850, 1),
('mouse nebula pro', 950, 1),
('camara orbit cam', 3200, 2),
('auriculares pulse max', 2700, 3),
('tablet nova pad', 5200, 5);

insert into detalleventa (IDProducto, Cantidad, PrecioUnidad, fecha) values
(1, 2500, 1850, '2026-05-01'),
(2, 180, 950, '2026-05-03'),
(3, 120, 3200, '2026-05-05'),
(4, 90, 2700, '2026-05-08'),
(5, 75, 5200, '2026-05-10');

select categorias.nombre as categoria, productos.Nombre as producto, sum(detalleventa.Cantidad) as total_vendido
from categorias 
inner join productos 
on categorias.IDCategoria = productos.IDCategoria
inner join detalleventa 
on productos.IDProducto = detalleventa.IDProducto
group by categorias.IDCategoria, productos.IDproducto
having sum(detalleventa.Cantidad) > 500
order by total_vendido desc
limit 1;

select categorias.nombre as categoria, avg(productos.Precio) as promedio_precio, sum(detalleventa.Cantidad) as productos_vendidos
from categorias
inner join productos
on categorias.IDCategoria = productos.IDCategoria
inner join detalleventa
on productos.IDProducto = detalleventa.IDProducto
group by categorias.IDCategoria, categorias.nombre
having avg(productos.Precio) > 1500
and sum(detalleventa.Cantidad) >= 10;

select categorias.nombre as categoria, sum(detalleventa.Cantidad * detalleventa.PrecioUnidad) as recaudaciontotal
from categorias
inner join productos
on categorias.IDCategoria = productos.IDCategoria
inner join detalleventa
on productos.IDProducto = detalleventa.IDProducto
where productos.Precio < 100
group by categorias.IDCategoria, categorias.nombre 
having sum(detalleventa.Cantidad * detalleventa.PrecioUnidad) < 5000;
