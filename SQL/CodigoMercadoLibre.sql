create database MercadoLibre;
-- drop database MercadoLibre
use MercadoLibre;

create table Categorias (
    IDCategoria int auto_increment primary key not null,
    Nombre varchar(50),
    Descripcion text
);

create table Detalles (
    IDDetalle int auto_increment primary key not null,
    Titulo varchar(50),
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
    Color varchar(50),
    IDCategoria int,
    IDDetalle int,
    foreign key (IDCategoria) references Categorias(IDCategoria),
    foreign key (IDDetalle) references Detalles(IDDetalle)
);

create table Publicaciones (
    IDPublicacion int auto_increment primary key not null,
    Fecha date,
    IDUsuario int,
    Descripcion text,
    IDProducto int,
    Precio decimal,
    Stock int,
    Estado enum("Activa", "Eliminada", "SinStock"),
    foreign key (IDUsuario) references Usuarios(IDUsuario),
    foreign key (IDProducto) references Productos(IDProducto)
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
CREATE PROCEDURE NuevoUsuario(IN xcorreo Varchar(50), IN xtelefono Varchar(50), IN xnombre varchar(50), IN xcontrasena varchar(50), IN xdireccion varchar(50), IN xciudad varchar(50), IN xapellido varchar(50), IN ximagen varchar(255))
	BEGIN
		if exists(select Correo from usuarios where Correo=xcorreo) then
            select "1" as resultado;
		elseif exists (select Telefono from usuarios where Telefono=xtelefono)then
            select "2" as resultado;
		else
			insert into usuarios(Correo, Telefono, Nombre, Contrasena, Direccion, Ciudad, Apellido, imagen) values (xCorreo, xTelefono, xNombre, xContrasena, xDireccion, xCiudad, xapellido, ximagen);
            select "3" as resultado,
            IDUsuario as id, imagen  from usuarios WHERE Correo = xcorreo;
		end if;
    END//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE ValidarSesion(IN xcorreo VARCHAR(50), IN xpass VARCHAR(255))
BEGIN
SELECT IDUsuario, Nombre, imagen FROM usuarios WHERE Correo = xcorreo AND Contrasena = xpass;
END;
DELIMITER ;
DELIMITER //
CREATE PROCEDURE EliminarCuenta(IN xIDusuario int)
BEGIN
     delete from usuarios where IDUsuario = xIDusuario;
END;
DELIMITER ;

USE MercadoLibre;
 
DROP PROCEDURE IF EXISTS ActualizarUsuario;
 
DELIMITER //
CREATE PROCEDURE ActualizarUsuario( IN xid INT,  IN xcorreo VARCHAR(50), IN xtelefono VARCHAR(50), IN xnombre VARCHAR(50), IN xcontrasena VARCHAR(50), IN xdireccion VARCHAR(50), IN xciudad VARCHAR(50), IN xapellido VARCHAR(50), IN ximagen VARCHAR(255))
BEGIN

    if exists (SELECT 1 FROM usuarios WHERE Correo = xcorreo AND IDUsuario <> xid) THEN
        SELECT "1" AS resultado;
        
    ELSEIF EXISTS (SELECT 1 FROM usuarios WHERE Telefono = xtelefono AND IDUsuario <> xid) THEN
        SELECT "2" AS resultado;
    ELSE
        UPDATE usuarios SET Correo = xcorreo, Telefono = xtelefono, Nombre = xnombre, Apellido   = xapellido, Direccion = xdireccion, Ciudad = xciudad,  Contrasena = IF(xcontrasena IS NULL OR xcontrasena = '', Contrasena, xcontrasena), imagen = IF(ximagen IS NULL OR ximagen = '', imagen, ximagen)
        WHERE IDUsuario = xid;

        SELECT "3" AS resultado, IDUsuario AS id, Correo, imagen
        FROM usuarios
        WHERE IDUsuario = xid;
    END IF;
END//
DELIMITER ;
