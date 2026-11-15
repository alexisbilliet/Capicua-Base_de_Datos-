<?php
$conexion = new mysqli("localhost", "root", "", "mercadolibre", 3306);
if ($conexion->connect_error) die("Error de conexión");
?>