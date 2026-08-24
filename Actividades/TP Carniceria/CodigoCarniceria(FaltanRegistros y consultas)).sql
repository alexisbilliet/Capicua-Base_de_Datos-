create database Carniceros;
use Carniceros;

create table Carniceros(
IDCarnicero int auto_increment not null,
Nombre varchar(25),
Apellido varchar(25),
DNI int
);
create table Proveedores(
IDProveedor int auto_increment not null,
Nombre varchar(25),
Ubicacion varchar(25),
Telefono int
);
create table Productos(
IDProductos int auto_increment not null,
Nombre varchar(25),
PrecioUnitario float,
Stock int,
IDProveedor int,
foreign key (IDProveedor) references Proveedores(IDProveedor)
);
create table ListasDeProductos(
IDListaDeProducto int auto_increment not null,
IDProducto int, 
foreign key (IDProducto) references Productos(IDProducto),
Cantidad int
);
create table Clientes(
IDClientes int auto_increment not null,
Nombre varchar(25),
Telefono int
);
create table Pedidos(
IDPedido int auto_increment not null,
IDCarnicero int, 
foreign key (IDCarnicero) references Carniceros(IDCarnicero),
IDListaDeProducto int, 
foreign key (IDListaDeProducto) references Productos(IDListaDeProducto),
IDCliente int, 
foreign key (IDCliente) references Clientes(IDCliente),
MedioDePago enum("A", "B", "C"),
PrecioTotal float	
);

select productos.nombre, count(ListasDeProductos.cantidad) as CantidadComprada
from productos
inner join ListasDeProductos
on ListasDeProductos.IDProducto = productos.IDProducto
group by productos.nombre
order by CantidadComprada desc
limit 1;

