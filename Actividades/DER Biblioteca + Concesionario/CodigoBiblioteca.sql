create database biblioteca;
-- drop database biblioteca
use biblioteca;

create table Editoriales(
	IDEditorial int primary key auto_increment not null,
    Nombre varchar(25),
    Ubicacion Varchar(20),
    Fundacion year
 
);
create table libros(
	IDLibro int primary key auto_increment not null,
    Titulo varchar(25),
    ISBN int(10),
    numeropaginas int (5), 
    IDEditorial int,
    foreign key (IDEditorial) references Editoriales(IDEditorial)
);
create table Autores(
	IDAutor int primary key auto_increment not null,
    Nombre varchar(25),
    Apellido Varchar(25)
 
);
create table Autores_Libros(
	IDAutor_Libro int primary key auto_increment not null,
    IDAutor int,
    foreign key (IDAutor) references Autores(IDAutor),
    IDLibro int,
    foreign key (IDLibro) references libros(IDLibro)
 
);
create table Ejemplares(
	IDEjemplar int primary key auto_increment not null,
    IDLibro int,
    foreign key (IDLibro) references libros(IDLibro),
    Localizacion varchar(25)
);
create table Usuarios(
	IDUsuario int primary key auto_increment not null,
    nombre varchar(25),
    apellido varchar(25),
    direccion varchar(25),
    telefono int(15)
);
create table Fichas(
	IDFichas int primary key auto_increment not null,
    IDEjemplar int,
    foreign key (IDEjemplar) references Ejemplares(IDEjemplar),
    IDUsuario int,
    foreign key (IDUsuario) references Usuarios(IDUsuario),
    fechadev date, 
    fecharet date
    );
