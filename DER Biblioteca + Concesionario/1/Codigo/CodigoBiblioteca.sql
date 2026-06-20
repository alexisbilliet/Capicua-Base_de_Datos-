create database biblioteca;
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

insert into editoriales (nombre, ubicacion, fundacion) values
('sudamericana', 'buenos aires', 1939),
('planeta', 'madrid', 1949),
('alfaguara', 'madrid', 1964),
('emece', 'buenos aires', 1939),
('anagrama', 'barcelona', 1969);

insert into libros (titulo, isbn, numeropaginas, ideditorial) values
('rayuela', 12345670, 600, 1),
('it', 23456789, 1500, 2),
('1984', 34567890, 350, 3),
('el tunel', 45678901, 180, 4),
('ficciones', 56789012, 250, 5);

insert into autores (nombre, apellido) values
('julio', 'cortazar'),
('stephen', 'king'),
('george', 'orwell'),
('ernesto', 'sabato'),
('jorge luis', 'borges');

insert into autores_libros (idautor, idlibro) values
(1,1),
(2,2),
(3,3),
(4,4),
(5,5);

insert into ejemplares (idlibro, localizacion) values
(1, 'estante a1'),
(2, 'estante b2'),
(3, 'estante c3'),
(4, 'estante d4'),
(5, 'estante e5');

insert into usuarios (nombre, apellido, direccion, telefono) values
('mateo', 'gonzales', 'Jose Cubas 2022', 1122334455),
('valentina', 'fernandez', 'Lavalle 400', 1133445566),
('tomás', 'gomez', 'Av. Forest 500', 1144556677),
('camila', 'martinez', 'Bolivia 2742', 1155667788),
('benjamín', 'fernandez', 'Costa rica 3120', 1166778899);

insert into fichas (idejemplar, idusuario, fechadev, fecharet) values
(1, 1, '2026-05-15', '2026-05-01'),
(2, 2, '2026-05-18', '2026-05-03'),
(3, 3, '2026-05-20', '2026-05-05'),
(4, 4, '2026-05-22', '2026-05-07'),
(5, 5, '2026-05-25', '2026-05-10');