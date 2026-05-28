create database Streaming;
-- drop database Streaming
use Streaming;
create table Artistas(
id_artista int primary key auto_increment not null,
nombre varchar(20)
);
create table Albumes(
id_album int primary key auto_increment not null,
titulo varchar(20),
id_artista int,
foreign key(id_artista) references Artistas(id_artista)
);
create table Reproducciones(
id_reproduccion int primary key auto_increment not null,
id_album int ,
foreign key(id_album) references albumes(id_album),
cant_reproduccion int(8) 
);

insert into Artistas(Nombre) values
("Taylor Swift"),
("Ed Sheeran"),
("Milo J"),
("Callejero Fino"),
("Anuel");

Insert into Albumes(Titulo, ID_artista) values
("1989", 1),
("Divide", 2),
("LVEMC", 3),
("HAGAN CA$O", 4),
("Real Hasta La Muerte", 5);

Insert into Reproducciones(ID_album, cant_reproduccion) values
(1, 2000000),
(2, 1500000),
(3, 8000000),
(4, 4000000),
(5, 6000000);

select artistas.nombre, reproducciones.cant_reproduccion
from albumes
inner join artistas
on artistas.id_artista = albumes.id_artista
inner join reproducciones
on reproducciones.id_album = albumes.id_album
group by artistas.id_artista, albumes.id_album
having count(albumes.id_album) > 3 and reproducciones.cant_reproduccion > 1000000;

select  al.titulo as Album, ar.nombre as Artista, AVG(r.cant_reproduccion) as Promedio_Reproducciones
from Albumes al
inner join Artistas ar on al.id_artista = ar.id_artista
inner join Reproducciones r on al.id_album = r.id_album
group by al.id_album, al.titulo, ar.nombre
having AVG(r.cant_reproduccion) > 50000;

SELECT ar.nombre as Artista, SUM(r.cant_reproduccion) as Total_Reproducciones
FROM Artistas ar
inner join Albumes al on ar.id_artista = al.id_artista
inner join Reproducciones r on al.id_album = r.id_album
group by ar.id_artista, ar.nombre
order by Total_Reproducciones ASC
LIMIT 1;


