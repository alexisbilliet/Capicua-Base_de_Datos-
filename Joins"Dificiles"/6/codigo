create database algo;
-- drop database algo
use algo;

create table restaurantes
(
	IDRestaurante int primary key auto_increment not null,
    nombre varchar(25),
    zona varchar(25)
    
);
create table platos
(
	IDPlato int primary key auto_increment not null,
    nombre varchar(25),
    precio float,
    IDRestaurante int,
    foreign key (IDRestaurante) references restaurantes(IDRestaurante)
    
);
create table pedidos
(
	IDPedido int primary key auto_increment not null,
    cantidad int(3),
    IDPlato int,
    foreign key (IDPlato) references platos(IDPlato)
    
);

insert into restaurantes(nombre, zona) values
("ElPalito", "Villa Lynch"),
("LaVaquita", "Chacarita"),
("Viejo Tucho", "Saenz peña"),
("El Torito", "Villa Crespo"),
("DonJulio", "Palermo");

insert into platos(nombre, precio, IDRestaurante) values
("PizzadeAnana", 40000, 1),
("Puerto Madero", 12500, 2),
("Suprema con Fritas", 16000, 3),
("Fitito", 20000, 4),
("Lomito", 50000, 5);

insert into pedidos(cantidad, IDPlato) values
(1,1), (2,2), (8,4), (10,3), (2,5);

select restaurantes.nombre, count(pedidos.IDPedido) as pedidosTotales
from restaurantes
inner join platos
on platos.IDRestaurante = restaurantes.IDRestaurante
inner join pedidos
on pedidos.IDPlato = platos.IDPlato
group by restaurantes.IDRestaurante, pedidos.IDPedido
having count(pedidos.IDPedido) > 200 and count(platos.IDPlato) > 5;

select restaurantes.nombre, AVG(platos.precio * pedidos.cantidad) as PromediodeIngresos
from restaurantes
inner join platos
on platos.IDRestaurante = restaurantes.IDRestaurante
inner join pedidos
on pedidos.IDPlato = platos.IDplato
where platos.precio > 1500
group by restaurantes.IDrestaurante;

select platos.nombre
from platos
where platos.nombre like "%Pizza%"
limit 10;
