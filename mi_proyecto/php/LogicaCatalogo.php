<?php
include "php/auth.php";
include 'php/conexion.php';

// Este archivo solo prepara los datos: no muestra nada en pantalla.
// ---- Leer lo que eligió el usuario (vienen por la URL, método GET) ----
$buscar    = $_GET['buscar']    ?? '';
$categoria = $_GET['categoria'] ?? '';
$promedio  = $_GET['promedio']  ?? '';
$constock  = $_GET['stock']     ?? '';

// ---- Armar la consulta según los filtros ----
$where  = "p.Estado IN ('Activa', 'SinStock')";
$having = "";

if ($buscar != '') {
    $texto = $conexion->real_escape_string($buscar);
    $where .= " AND pr.Nombre LIKE '%$texto%'";
}
if ($categoria != '') {
    $where .= " AND c.IDCategoria = " . (int)$categoria;
}
if ($constock != '') {
    $where .= " AND p.Stock > 0";
}
if ($promedio != '') {
    $having = "HAVING AVG(r.Calificacion) >= " . (int)$promedio;
}

$sql = "SELECT p.IDPublicacion, p.Precio, p.Stock, pr.Nombre as Producto,p.imagen, c.Nombre as Categoria, round(AVG(r.Calificacion), 1) as Promedio, count(r.Calificacion) as Cantidad
        from Publicaciones as p
        inner join Productos as pr on p.IDProducto = pr.IDProducto
        inner join Categorias as c on pr.IDCategoria = c.IDCategoria
        left join `Resenas` as r on r.IDPublicacion = p.IDPublicacion
        where $where
        group by p.IDPublicacion, p.Precio, p.Stock, pr.Nombre, c.Nombre
        $having
        order by p.Fecha desc";

$resultado = $conexion->query($sql);

// Todas las categorías que existen, para el filtro del costado
$categorias = $conexion->query("SELECT IDCategoria, Nombre FROM Categorias ORDER BY Nombre");
