<?php
include 'conexion.php';
session_start();
$nombre = $_POST['nombre'];
$correo = $_POST['correo'];
$contrasena = $_POST['contrasena'];
$telefono = $_POST['telefono'];
$direccion = $_POST['direccion'];
$ciudad = $_POST['ciudad'];
$sql = "CALL NuevoUsuario('$correo','$telefono','$nombre',  '$contrasena',  '$direccion', '$ciudad')";
$res = mysqli_query($conexion, $sql);
$fila = mysqli_fetch_assoc($res);
if ($fila['resultado'] == '3') {
$_SESSION['usuario_id'] = $fila["id"];
$_SESSION['correo_usuario'] = $correo;
header("Location: ../home.php");
} elseif ($fila['resultado'] == '1') {
echo "<script>
alert('Ese correo ya está registrado. Inicia sesión o usa otro.');
window.location.href = '../Registrarse.php';
</script>";
} else {
echo "<script>
alert('Ese teléfono ya está registrado. Usa otro.');
window.location.href = '../Registrarse.php';
</script>";
}