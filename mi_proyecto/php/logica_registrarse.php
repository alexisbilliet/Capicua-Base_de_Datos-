<?php
include 'conexion.php';
session_start();

$nombre = $_POST['nombre'];
$correo = $_POST['correo'];
$contrasena = $_POST['contrasena'];
$telefono = $_POST['telefono'];
$direccion = $_POST['direccion'];
$ciudad = $_POST['ciudad'];
$apellido = $_POST['apellido'];

// --- INICIO LÓGICA DE LA IMAGEN ---
$rutaFotoPerfil = "img/perfil.png"; // Foto por defecto si no sube nada

if (isset($_FILES['foto']) && $_FILES['foto']['error'] === UPLOAD_ERR_OK) {
    $fileTmpPath = $_FILES['foto']['tmp_name'];
    $fileName    = $_FILES['foto']['name'];
    $fileSize    = $_FILES['foto']['size'];
    
    // Seguridad: Validar extensiones permitidas
    $infoArchivo = pathinfo($fileName);
    $extension   = strtolower($infoArchivo['extension']);
    $extensionesPermitidas = ['jpg', 'jpeg', 'png', 'webp'];

    // Seguridad: Validar tipo MIME real de la imagen
    $finfo = finfo_open(FILEINFO_MIME_TYPE);
    $mimeReal = finfo_file($finfo, $fileTmpPath);
    finfo_close($finfo);
    $mimesPermitidos = ['image/jpeg', 'image/png', 'image/webp'];

    if (in_array($extension, $extensionesPermitidas) && in_array($mimeReal, $mimesPermitidos)) {
        // Validar tamaño máximo (2MB)
        if ($fileSize <= 2097152) {
            
            // Carpeta destino (sube un nivel a la raíz del proyecto)
            $uploadFileDir = '../img/'; 
            if (!is_dir($uploadFileDir)) {
                mkdir($uploadFileDir, 0755, true);
            }

            // Generar nombre único basado en hash md5 para evitar duplicados
            $nuevoNombre = md5(time() . $fileName) . '.' . $extension;
            $dest_path   = $uploadFileDir . $nuevoNombre;

            // Mover el archivo temporal a la carpeta definitiva
            if(move_uploaded_file($fileTmpPath, $dest_path)) {
                // Guardamos la ruta que irá a la Base de Datos
                $rutaFotoPerfil = "img/" . $nuevoNombre; 
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

// Se agrega '$rutaFotoPerfil' como último parámetro enviado al procedimiento almacenado
$sql = "CALL NuevoUsuario('$correo','$telefono','$nombre', '$contrasena', '$direccion', '$ciudad', '$apellido', '$rutaFotoPerfil')";
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
?>