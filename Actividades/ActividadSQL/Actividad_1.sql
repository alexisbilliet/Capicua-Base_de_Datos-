create database test;

use test;

create table Empleados(
     IDEmpleado Int auto_increment primary key not null,
     Nombre Varchar(25),
     Apellido Varchar(25),
     Sector enum("adm", "ventas", "compras", "RRHH") ,
     Edad Int(2) default 35,
     Sexo char not null,
     Barrio_vivienda Varchar(25) default "Belgrano",
     CodPostal Int(4),
     Ingreso Int(4) not null,
     Sueldo Float(8) not null,
     Antiguedad Float(8) default 250,
     Celular int(10) not null
);

insert into Empleados(Nombre, Apellido, Sector, Edad, Sexo, Barrio_vivienda, CodPostal, Ingreso, Sueldo, Antiguedad, Celular)
values ("Ja", "Gomez", "ventas", 54 , "M", default, 1427, 2011, 4000, 600, 1122345678 ),
("Enzo", "Jones", "adm", 47, "M", "Almagro", 1173, 2016, 3500, 380, 1122345679 ), 
("Maria", "Caballero", "compras", 35, "F", "Belgrano", 1428, 2019, 2500, 300, 1122345680 ),
("Julio", "Rodriguez", "RRHH", 43, "M", "Flores", 1406, 2011, 4000, 600, 1122345681 ),
("Ana", "Martinez", "adm", 23, "F", "Almagro", 1173, 2024, 2200, 25, 1122345682 ),
("Santino", "Cordera", "ventas", 40, "M", "Palermo", 1414, 2011, 4000, 600, 1122345683 ),
("Carlos", "Perez", "RRHH", 65, "M", "Flores", 1406, 2011, 4000, 600, 1122345684 ),
("Marta", "Herrera", "compras", 55, "F", "Recoleta", 1010, 2011, 4000, 600, 1122345685 ),
("Jonas", "Correa", "RRHH", 32, "M", "Recoleta", 1010, 2023, 2000, 15, 1122345686 ),
("Sofia", "Corridoni", "compras", 43, "F", "La Boca", 1161, 2013, 3500, 400, 1122345687 ),
("Martin", "Kaiser", "RRHH", 61, "M", "Belgrano", 1428, 2011, 4000, 600, 1122345688 ),
("Facundo", "Fernandez", "adm", 43, "M", "Chacarita", 1427, 2014, 3500, 380, 1122345689 ),
("Francisca", "Lima", "ventas", 67, "F", "Belgrano", 1428, 2010, 4200, 610, 1122345690 ),
("Antonella", "Nero", "RRHH", 18, "F", "Villa Martelli", 1003, 2026, 1400, 0, 1122345691 ),
("Franco", "Carreras", "RRHH", 18, "M", "Palermo", 1414, 2026, 1400, 0, 1122644893 );

select *
from empleados;

select  Nombre, Apellido 
from Empleados
where Barrio_vivienda = "Belgrano";

select Apellido, Edad
from Empleados
where Ingreso = 2010 or Ingreso = 2011 or Ingreso = 2012; 

select nombre, Apellido, Edad
from Empleados
where Sexo = "F" and Sector = "RRHH"; 

select Apellido, Sector, celular
from empleados;

select nombre, apellido, sueldo
from empleados
where barrio_vivienda = "almagro" or barrio_vivienda = "flores" 
order by apellido desc;

select count(idempleado)
from empleados;

select nombre, apellido, edad
from empleados
where edad = (select max(edad) from empleados) or edad = (select min(edad) from empleados);

select avg(edad)
from empleados;

select avg(edad)
from empleados
where Sector = "RRHH"
