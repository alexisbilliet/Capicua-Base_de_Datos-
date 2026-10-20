<?php
include 'conexion.php';
$nombre = $_POST['nombre'];
$correo = $_POST['correo'];
$contrasena = $_POST['contrasena'];
$telefono = $_POST['telefono'];
$direccion = $_POST['direccion'];
$ciudad = $_POST['ciudad'];
$sql = "CALL NuevoUsuario('$correo','$telefono','$nombre',  '$contrasena',  '$direccion', '$ciudad')";
$res = mysqli_query($conexion, $sql);

header("Location: ../iniciarSesion.php"); 