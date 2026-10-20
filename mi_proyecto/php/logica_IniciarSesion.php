<?php
session_start();
include 'conexion.php';
$u = $_POST['user'];
$p = $_POST['pass'];
$sql = "CALL ValidarSesion('$u', '$p')";
$res = mysqli_query($conexion, $sql);
if ($fila = mysqli_fetch_assoc($res)) {
// ÉXITO: Creamos las variables de sesión

$_SESSION['usuario_id'] = $fila['IDUsuario'];
$_SESSION['correo_usuario'] = $fila['Correo'];
header("Location: ../home.php"); // Entra al panel
} else {
echo "<script>
alert('Ese usuario no existe o los datos son incorrectos. Si no tienes cuenta, crea una nueva.');
window.location.href = '../IniciarSesion.php';
</script>";
}
?>