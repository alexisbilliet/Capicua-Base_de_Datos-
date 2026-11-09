<?php
session_start();

// Este archivo vive dentro de /php, por eso no usamos auth.php (su redirect es relativo a la raíz)
if (!isset($_SESSION['usuario_id'])) {
    header("Location: ../IniciarSesion.php");
    exit();
}
// Solo se procesa si viene del formulario
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    header("Location: ../EditarPerfil.php");
    exit();
}

include 'conexion.php';

// El ID sale de la sesión, nunca del formulario
$id = (int)$_SESSION['usuario_id'];

$nombre     = trim($_POST['nombre']);
$apellido   = trim($_POST['apellido']);
$correo     = trim($_POST['correo']);
$contrasena = $_POST['contrasena'];   // vacío = se mantiene la actual
$telefono   = trim($_POST['telefono']);
$direccion  = trim($_POST['direccion']);
$ciudad     = trim($_POST['ciudad']);

// Foto actual (para borrar el archivo viejo si sube una nueva)
$stmt = $conexion->prepare("SELECT imagen FROM Usuarios WHERE IDUsuario = ?");
$stmt->bind_param("i", $id);
$stmt->execute();
$filaAnterior = $stmt->get_result()->fetch_assoc();
$stmt->close();
$imagenAnterior = $filaAnterior['imagen'] ?? '';

// --- INICIO LÓGICA DE LA IMAGEN ---
$rutaNueva = ""; // vacío = no cambia la foto

if (isset($_FILES['foto']) && $_FILES['foto']['error'] === UPLOAD_ERR_OK) {
    $fileTmpPath = $_FILES['foto']['tmp_name'];
    $fileName    = $_FILES['foto']['name'];
    $fileSize    = $_FILES['foto']['size'];

    $infoArchivo = pathinfo($fileName);
    $extension   = strtolower($infoArchivo['extension'] ?? '');
    $extensionesPermitidas = ['jpg', 'jpeg', 'png', 'webp'];

    if (in_array($extension, $extensionesPermitidas)) {
        if ($fileSize <= 2097152) { // 2MB

            $uploadFileDir = '../img/';
            $nuevoNombre   = md5(time() . $fileName) . '.' . $extension;
            $dest_path     = $uploadFileDir . $nuevoNombre;

            if (move_uploaded_file($fileTmpPath, $dest_path)) {
                $rutaNueva = "img/" . $nuevoNombre;
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

$stmt = $conexion->prepare("CALL ActualizarUsuario(?,?,?,?,?,?,?,?,?)");
$stmt->bind_param("issssssss", $id, $correo, $telefono, $nombre, $contrasena, $direccion, $ciudad, $apellido, $rutaNueva);
$stmt->execute();
$fila = $stmt->get_result()->fetch_assoc();
$stmt->close();

if ($fila['resultado'] == '3') {
    // Actualizamos la sesión para que el navbar muestre la foto nueva
    $_SESSION['correo_usuario'] = $fila['Correo'];
    $_SESSION['imagen']         = $fila['imagen'];

    // Borramos la foto anterior solo si la subió el usuario (nombre md5) y si cambió
    if ($rutaNueva !== '' && preg_match('/^[a-f0-9]{32}\.(jpg|jpeg|png|webp)$/', basename($imagenAnterior))) {
        @unlink('../img/' . basename($imagenAnterior));
    }

    header("Location: ../MiCuenta.php");
    exit();
}

// Si falló, no dejamos huérfana la foto que acabamos de subir
if ($rutaNueva !== '') {
    @unlink('../' . $rutaNueva);
}

if ($fila['resultado'] == '1') {
    echo "<script>
    alert('Ese correo ya lo usa otra cuenta. Usa otro.');
    window.location.href = '../EditarPerfil.php';
    </script>";
} else {
    echo "<script>
    alert('Ese teléfono ya lo usa otra cuenta. Usa otro.');
    window.location.href = '../EditarPerfil.php';
    </script>";
}
?>
