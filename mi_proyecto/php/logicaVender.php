<?php
session_start();

// Este archivo vive dentro de /php, por eso no usamos auth.php (su redirect es relativo a la raíz)
if (!isset($_SESSION['usuario_id'])) {
    header("Location: ../IniciarSesion.php");
    exit();
}
// Solo se procesa si viene del formulario
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    header("Location: ../Vender.php");
    exit();
}

include 'conexion.php';
mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT); // para que los errores de SQL entren en el catch

// El ID sale de la sesión, nunca del formulario
$idUsuario = (int)$_SESSION['usuario_id'];

$nombre      = trim($_POST['nombre']);
$precio      = (float)$_POST['precio'];
$descripcion = trim($_POST['descripcion']);
$categoria   = trim($_POST['categoria']);
$stock       = (int)$_POST['stock'];

// Las características vienen como listas (detalle_titulo[] y detalle_descripcion[])
$titulos       = $_POST['detalle_titulo'] ?? [];
$descripciones = $_POST['detalle_descripcion'] ?? [];

if ($precio < 0 || $stock < 0) {
    echo "<script>alert('El precio y el stock no pueden ser negativos.'); window.history.back();</script>";
    exit;
}

// --- INICIO LÓGICA DE LA IMAGEN ---
$rutaFoto = "img/perfil.png"; // Foto por defecto si no sube nada
$subioFoto = false;

if (isset($_FILES['foto']) && $_FILES['foto']['error'] === UPLOAD_ERR_OK) {
    $fileTmpPath = $_FILES['foto']['tmp_name'];
    $fileName    = $_FILES['foto']['name'];
    $fileSize    = $_FILES['foto']['size'];

    // Seguridad: Validar extensiones permitidas
    $infoArchivo = pathinfo($fileName);
    $extension   = strtolower($infoArchivo['extension'] ?? '');
    $extensionesPermitidas = ['jpg', 'jpeg', 'png', 'webp'];

    if (in_array($extension, $extensionesPermitidas)) {
        // Validar tamaño máximo (2MB)
        if ($fileSize <= 2097152) {

            $uploadFileDir = '../img/';
            $nuevoNombre   = md5(time() . $fileName) . '.' . $extension;
            $dest_path     = $uploadFileDir . $nuevoNombre;

            // Mover el archivo temporal a la carpeta definitiva
            if (move_uploaded_file($fileTmpPath, $dest_path)) {
                $rutaFoto  = "img/" . $nuevoNombre;
                $subioFoto = true;
            }
        } else {
            echo "<script>alert('La imagen es muy pesada. Máximo 2MB.'); window.history.back();</script>";
            exit;
        }
    } else {
        echo "<script>alert('Formato de imagen no permitido. Usa JPG, PNG o WEBP.'); window.history.back();</script>";
        exit;
    }
}
// --- FIN LÓGICA DE LA IMAGEN ---

// Todo o nada: si algo falla, no queda nada guardado a medias
$conexion->begin_transaction();

try {
    // 1) CATEGORIA: si ya existe usamos esa, si no la creamos
    $sql = "SELECT IDCategoria FROM Categorias WHERE Nombre = '$categoria'";
    $resultado = $conexion->query($sql);
    $filaCat = $resultado->fetch_assoc();

    if ($filaCat) {
        $idCategoria = (int)$filaCat['IDCategoria'];
    } else {
        $sql = "INSERT INTO Categorias (Nombre) VALUES ('$categoria')";
        $conexion->query($sql);

        $idCategoria = $conexion->insert_id;
    }

    // 2) PRODUCTO
    $sql = "INSERT INTO Productos (Nombre, IDCategoria) VALUES ('$nombre', '$idCategoria') ";
    $conexion->query($sql);

    $idProducto = $conexion->insert_id;

    // 3) PUBLICACIOn
    $estado = ($stock > 0) ? 'Activa' : 'SinStock';
    $fecha  = date('Y-m-d');
    $sql = "INSERT INTO Publicaciones (Fecha, IDUsuario, Descripcion, IDProducto, Precio, Stock, Estado, imagen) VALUES ('$fecha', '$idUsuario', '$descripcion', '$idProducto', '$precio', '$stock', '$estado', '$rutaFoto') ";
    $conexion->query($sql);





    // 4) DETALLES (una fila por cada característica)
    foreach ($titulos as $i => $titulo) 
    {
        $titulo = trim($titulo);
        $desc = trim($descripciones[$i] ?? '');

        if ($titulo == '' && $desc == '') continue;

        $sql = "INSERT INTO Detalles (IDProducto, Titulo, Descripcion)  VALUES ($idProducto, '$titulo', '$desc')";

        $conexion->query($sql);
    }

    $conexion->commit();

    header("Location: ../CatalogoProductos.php");
    exit();

} catch (Exception $e) {
    $conexion->rollback();

    // Si falló, no dejamos huérfana la foto que acabamos de subir
    if ($subioFoto) {
        @unlink('../' . $rutaFoto);
    }

    echo "<script>
    alert('No se pudo publicar el producto. Intenta de nuevo.');
    window.location.href = '../Vender.php';
    </script>";
}
?>
