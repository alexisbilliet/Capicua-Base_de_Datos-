<?php
include "php/auth.php";
include 'php/conexion.php';

// Este archivo solo prepara los datos: no muestra nada en pantalla.
// El id viene por la URL (Producto.php?id=5)
$id = (int)($_GET['id'] ?? 0);

$stmt = $conexion->prepare("SELECT p.IDProducto, p.Precio, p.Stock, p.Descripcion, p.imagen, pr.Nombre AS Producto, c.Nombre AS Categoria, u.Nombre AS Vendedor, u.Apellido, round(AVG(r.Calificacion), 1) AS Promedio, count(r.Calificacion) AS Cantidad
        FROM Publicaciones AS p
        INNER JOIN Productos AS pr ON p.IDProducto = pr.IDProducto
        INNER JOIN Categorias AS c ON pr.IDCategoria = c.IDCategoria
        INNER JOIN Usuarios AS u ON p.IDUsuario = u.IDUsuario
        LEFT JOIN Resenas AS r ON r.IDPublicacion = p.IDPublicacion
        WHERE p.IDPublicacion = ? AND p.Estado IN ('Activa', 'SinStock')
        GROUP BY p.IDPublicacion, pr.Nombre, c.Nombre, u.Nombre, u.Apellido");
$stmt->bind_param("i", $id);
$stmt->execute();
$p = $stmt->get_result()->fetch_assoc();
$stmt->close();

// Si el id no existe o la publicación fue eliminada, volvemos al catálogo
if (!$p) {
    header("Location: CatalogoProductos.php");
    exit();
}

// Características del producto (tabla Detalles)
$stmt = $conexion->prepare("SELECT Titulo, Descripcion FROM Detalles WHERE IDProducto = ?");
$stmt->bind_param("i", $p['IDProducto']);
$stmt->execute();
$detalles = $stmt->get_result();
$stmt->close();

$imagen = !empty($p['imagen']) ? $p['imagen'] : 'img/perfil.png';
