create database MercadoLibre;
-- drop database MercadoLibre
use MercadoLibre;

create table Categorias (
    IDCategoria int auto_increment primary key not null,
    Nombre varchar(50),
    Descripcion text
);



create table Usuarios (
    IDUsuario int auto_increment primary key not null,
    Correo varchar(50),
    Telefono varchar(50),
    Nombre varchar(50),
    Contrasena varchar(50),
    Direccion varchar(50),
    Ciudad varchar(50),
    Apellido varchar(50),
    imagen varchar(255)
);

create table Tarjetas (
    IDTarjeta int auto_increment primary key not null,
    TipoTarjeta varchar(50) ,
    NumeroDeTarjeta varchar(20) ,
    NombreTitular varchar(50) ,
    Vencimiento date not null,
    CodigoDeSeguridad int,
    DocumentoTitular int
);

create table MediosDePago (
    IDMedioDePago int auto_increment primary key not null,
    Tipo enum('efectivo','credito','debito','transferencia'),
    IDTarjeta int,
    foreign key (IDTarjeta) references Tarjetas(IDTarjeta)
);

create table Repartidores (
    IDRepartidor int auto_increment primary key not null,
    Nombre varchar(50),
    Apellido varchar(50) not null,
    Edad int,
    DNI int,
    Telefono int
);

create table Envios (
    IDEnvio int auto_increment primary key not null,
    IDRepartidor int,
    Estado enum("EnCurso", "Entregado","Pendiente"),
    foreign key (IDRepartidor) references Repartidores(IDRepartidor)
);

create table Productos (
    IDProducto int auto_increment primary key not null,
    Nombre varchar(50) not null,
    IDCategoria int,
    foreign key (IDCategoria) references Categorias(IDCategoria)
);
create table Detalles (
    IDDetalle int auto_increment primary key not null,
    Titulo varchar(50),
    Descripcion text,
    IDProducto int,
    foreign key (IDProducto) references Productos(IDProducto)
);
create table Publicaciones (
    IDPublicacion int auto_increment primary key not null,
    Fecha date,
    IDUsuario int,
    Descripcion text,
    IDProducto int,
    Precio decimal(10,2),
    Stock int,
    Estado enum("Activa", "Eliminada", "SinStock"),
    foreign key (IDUsuario) references Usuarios(IDUsuario),
    foreign key (IDProducto) references Productos(IDProducto),
    imagen varchar(255)
);

create table Carritos (
    IDRegistro int auto_increment primary key not null,
    IDUsuario int,
    IDPublicacion int,
    Cantidad int,
    foreign key (IDUsuario) references Usuarios(IDUsuario),
    foreign key (IDPublicacion) references Publicaciones(IDPublicacion)
);

create table Compras (
    IDCompra int auto_increment primary key not null,
    IDUsuario int,
    CostoTotal decimal,
    IDMedioDePago int,
    IDEnvio int,
    Fecha date,
    foreign key (IDUsuario) references Usuarios(IDUsuario),
    foreign key (IDMedioDePago) references MediosDePago(IDMedioDePago),
    foreign key (IDEnvio) references Envios(IDEnvio)
);

create table DetallesCompras (
    IDDetalle int auto_increment primary key not null,
    IDCompra int,
    IDPublicacion int,
    Cantidad int,
    PrecioPagado decimal,
    foreign key (IDCompra) references Compras(IDCompra),
    foreign key (IDPublicacion) references Publicaciones(IDPublicacion)
);

create table Preguntas (
    IDPregunta int auto_increment primary key not null,
    IDPublicacion int,
    IDUsuario int,
    Texto text,
    foreign key (IDPublicacion) references Publicaciones(IDPublicacion),
    foreign key (IDUsuario) references Usuarios(IDUsuario)
);

create table Respuestas (
    IDRespuesta int auto_increment primary key not null,
    IDUsuario int,
    IDPregunta int,
    Texto text,
    foreign key (IDUsuario) references Usuarios(IDUsuario),
    foreign key (IDPregunta) references Preguntas(IDPregunta)
);

create table Resenas (
    IDResena int auto_increment primary key not null,
    IDUsuario int,
    IDPublicacion int,
    Texto text,
    Fecha date,
    Calificacion decimal,
    foreign key (IDUsuario) references Usuarios(IDUsuario),
    foreign key (IDPublicacion) references Publicaciones(IDPublicacion)
);

DELIMITER //
create procedure nuevousuario(in xcorreo varchar(50), in xtelefono varchar(50), in xnombre varchar(50), in xcontrasena varchar(50), in xdireccion varchar(50), in xciudad varchar(50), in xapellido varchar(50), in ximagen varchar(255))
begin
    if exists(select correo from usuarios where correo = xcorreo) then
        select "1" as resultado;
    elseif exists (select telefono from usuarios where telefono = xtelefono) then
        select "2" as resultado;
    else
        insert into usuarios(correo, telefono, nombre, contrasena, direccion, ciudad, apellido, imagen) values (xcorreo, xtelefono, xnombre, xcontrasena, xdireccion, xciudad, xapellido, ximagen);
        select "3" as resultado,
        IDUsuario as id, imagen from usuarios where correo = xcorreo;
    end if;
end//
DELIMITER ;


DELIMITER //
create procedure validarsesion(in xcorreo varchar(50), in xpass varchar(255))
begin
    select IDUsuario, nombre, imagen from usuarios where correo = xcorreo and contrasena = xpass;
end//
DELIMITER ;


DELIMITER //
create procedure eliminarcuenta(in xidusuario int)
begin
    delete from usuarios where IDUsuario = xidusuario;
end //
DELIMITER ;


DELIMITER //
create procedure actualizarusuario(in xid int, in xcorreo varchar(50), in xtelefono varchar(50), in xnombre varchar(50), in xcontrasena varchar(50), in xdireccion varchar(50), in xciudad varchar(50), in xapellido varchar(50), in ximagen varchar(255))
begin
    if exists (select 1 from usuarios where correo = xcorreo and idusuario <> xid) then
        select "1" as resultado;

    elseif exists (select 1 from usuarios where telefono = xtelefono and idusuario <> xid) then
        select "2" as resultado;
    else
        update usuarios set correo = xcorreo, telefono = xtelefono, nombre = xnombre, apellido = xapellido, direccion = xdireccion, ciudad = xciudad, contrasena = if(xcontrasena is null or xcontrasena = '', contrasena, xcontrasena), imagen = if(ximagen is null or ximagen = '', imagen, ximagen)
        where IDUsuario = xid;

        select "3" as resultado, idusuario as id, correo, imagen
        from usuarios
        where IDUsuario = xid;
    end if;
end//
DELIMITER ;
