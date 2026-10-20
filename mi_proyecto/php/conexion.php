<?php
$conexion = new mysqli("localhost", "root", "", "mercadolibre");
if ($conexion->connect_error) die("Error de conexión");
?>