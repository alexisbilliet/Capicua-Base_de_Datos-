create database HospitalVETERINARIo;
Use HospitalVETERINARIo;

CREATE TABLE Duenios (
IDDuenio INT AUTO_INCREMENT PRIMARY KEY,
DNI INT,
Nombre VARCHAR(50),
Apellido VARCHAR(50),
Telefono VARCHAR(20)
);

CREATE TABLE Veterinarios (
IDVeterinario INT AUTO_INCREMENT PRIMARY KEY,
Legajo INT,
Nombre VARCHAR(50),
Especialidad VARCHAR(50),
Turno enum('Mañana','Tarde','Noche')
);

CREATE TABLE Mascotas (
IDMascota INT AUTO_INCREMENT  PRIMARY KEY,
Nombre VARCHAR(50),
Especie VARCHAR(30),
Edad INT,
Raza VARCHAR(30),
IDDuenio INT,
FOREIGN KEY (IDDuenio) REFERENCES Duenios(IDDuenio)
);

CREATE TABLE Turnos (
ID_Turno INT AUTO_INCREMENT PRIMARY KEY,
Fecha DATE,
Hora TIME,
Motivo VARCHAR(100),
IDMascota INT,
IDVeterinario INT,
FOREIGN KEY (IDMascota) REFERENCES Mascotas(IDMascota),
FOREIGN KEY (IDVeterinario) REFERENCES Veterinarios(IDVeterinario)
);

INSERT INTO Duenios (DNI,Nombre,Apellido,Telefono)
values (98766543,"Maria", "PErez", '992314123'),
(12354878, "Juan", "Hernandez", '675849332');

INSERT INTO Veterinarios (Legajo,Nombre,Especialidad,Turno)
values (101,"DR.Lopez", "Cirugia","Mañana"),
(102, "DR.Liam", "Revision", "Mañana");

INSERT INTO Mascotas (Nombre,Especie,Edad,Raza,IDDuenio)
VALUES ("Nani", "Gato", 2, "Burmes", 1),
("Nieve", "Perro", 3 , "Husky",2);

INSERT INTO Turnos(Fecha, Hora, Motivo,IDMascota,IDVeterinario)
VALUES ('2024-05-10', '10:00', "Vacunacion", 1, 1), 
('2024-06-15', '15:30', 'Control', 2, 2);

SELECT * FROM Mascotas;

SELECT Nombre, Apellido FROM Duenios;

SELECT  * FROM Turnos
where Fecha > '2024-05-01';