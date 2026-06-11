create database Clinica;
use Clinica;
create table turnos(
    IDTurno int primary key auto_increment not null,
    estado enum('Pendiente', 'Terminado', 'EnProceso'),
    fecha date,
    horario time
);
create table medicos(
    IDMedico int primary key auto_increment not null,
    Nombre varchar(25),
    apellido varchar(25)
);
create table pacientes(
    IDPaciente int primary key auto_increment not null,
    Nombre varchar(25),
    apellido varchar(25)
);
create table especialidades(
    IDEspecialidad int primary key auto_increment not null,
    NombreEspecialidad varchar(25)
);
create table medicos_especialidades(
    IDMedico_Especialidad int primary key auto_increment not null,
    IDMedico int,
    foreign key (IDMedico) references medicos(IDMedico),
	IDEspecialidad int,
    foreign key (IDEspecialidad) references especialidades(IDEspecialidad)
);
alter table turnos
add IDPaciente int,
add  foreign key (IDPaciente) references pacientes(IDPaciente),
add IDMedico int,
add  foreign key (IDMedico) references medicos(IDMedico);

insert into especialidades (NombreEspecialidad) values
('Neurologia'),
('Traumatologia'),
('Oftalmologia');

insert into medicos (Nombre, apellido) values
('Valentino', 'Rossi'),
('Camila', 'Ortega'),
('Thiago', 'Benitez');

insert into pacientes (Nombre, apellido) values
('Milagros', 'Suarez'),
('Franco', 'Acosta'),
('Valentina', 'Quiroga');

insert into medicos_especialidades (IDMedico, IDEspecialidad) values
(1, 1),
(2, 2),
(3, 3);

insert into turnos (estado, fecha, horario, IDPaciente, IDMedico) values
('Pendiente', '2026-05-15', '08:45:00', 1, 1),
('EnProceso', '2026-05-16', '11:20:00', 2, 2),
('Terminado', '2026-05-17', '15:10:00', 3, 3);

select medicos.Nombre, especialidades.NombreEspecialidad
from medicos, especialidades, medicos_especialidades
where medicos.IDMedico = medicos_especialidades.IDMedico and especialidades.IDEspecialidad = medicos_especialidades.IDEspecialidad ;

select *
from turnos