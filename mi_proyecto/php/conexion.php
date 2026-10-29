<?php
$conexion = new mysqli("localhost", "root", "", "mercadolibre", 3307);
if ($conexion->connect_error) die("Error de conexión");
?>