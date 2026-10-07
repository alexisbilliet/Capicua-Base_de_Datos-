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
    Telefono int,
    Nombre varchar(50),
    Contraseña varchar(50),
    Direccion varchar(50),
    Ciudad varchar(50)
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
