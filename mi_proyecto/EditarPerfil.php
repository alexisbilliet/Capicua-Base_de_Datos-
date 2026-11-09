<?php
include 'php/auth.php';
include 'php/conexion.php';

$id = (int)$_SESSION['usuario_id'];

$stmt = $conexion->prepare("SELECT Nombre, Apellido, Correo, Telefono, Direccion, Ciudad, imagen FROM Usuarios WHERE IDUsuario = ?");
$stmt->bind_param("i", $id);
$stmt->execute();
$row = $stmt->get_result()->fetch_assoc();
$stmt->close();

if (!$row) {
    die("No se encontraron los datos del usuario.");
}

$imagenActual = !empty($row['imagen']) ? $row['imagen'] : 'img/perfil.png';
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="./css/navbar.css">
    <link rel="stylesheet" href="./css/formularios.css">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Editar Perfil</title>
</head>
<body>
    <!--NAVBAR-->
    <?php include 'navbar.php'; ?>
    <!--NAVBAR-->
    <!--FORM DE EDITAR PERFIL-->
    <div class="divtitle">
        <h1 id="title">Editar Perfil</h1>
        <h2 id="subtitle">Actualiza tu información</h2>
    </div>

    <form class="containerpadre" action="php/logicaeditar.php" method="POST" enctype="multipart/form-data">
        <div class="form-field" id="divNA">
            <div class="nombreapellido">
              <label for="nombre" class="form-label">Nombre</label>
              <input type="text" class="form-control" id="nombre" name="nombre" placeholder="Example: Jorge" autocomplete="given-name" maxlength="50" value="<?php echo htmlspecialchars($row['Nombre']); ?>" required>
            </div>
            <div class="nombreapellido">
              <label for="apellido" class="form-label">Apellido</label>
              <input type="text" class="form-control" id="apellido" name="apellido" placeholder="Example: Rodriguez" autocomplete="family-name" maxlength="50" value="<?php echo htmlspecialchars($row['Apellido']); ?>" required>
            </div>
         </div>

        <div class="form-field">
            <label for="correo" class="form-label">Direccion de Correo Electronico</label>
            <input type="email" class="form-control" id="correo" name="correo" placeholder="name@example.com" autocomplete="email" maxlength="50" value="<?php echo htmlspecialchars($row['Correo']); ?>" required>
        </div>

        <div class="form-field">
            <label for="contrasena" class="form-label">Contraseña</label>
            <input type="password" class="form-control" id="contrasena" name="contrasena" placeholder="Dejalo vacío para mantener la actual" autocomplete="new-password" maxlength="50">
        </div>

        <div class="form-field">
            <label for="telefono" class="form-label">Telefono</label>
            <input class="form-control" id="telefono" name="telefono" placeholder="Example: 11 6708 9209" autocomplete="tel" maxlength="50" value="<?php echo htmlspecialchars($row['Telefono']); ?>" required>
        </div>

        <div class="form-field">
            <label for="direccion" class="form-label">Direccion</label>
            <input type="text" class="form-control" id="direccion" name="direccion" placeholder="Example: Av. San Martin 6678" autocomplete="street-address" maxlength="50" value="<?php echo htmlspecialchars($row['Direccion']); ?>" required>
        </div>

        <div class="form-field">
            <label for="ciudad" class="form-label">Ciudad</label>
            <input type="text" class="form-control" id="ciudad" name="ciudad" placeholder="Example: Buenos Aires" autocomplete="address-level2" maxlength="50" value="<?php echo htmlspecialchars($row['Ciudad']); ?>" required>
        </div>
        <div class="form-field mb-3 text-center">
            <label class="form-label">Foto de Perfil</label>

            <label for="foto" class="selector-foto">
               <!-- Arranca mostrando la foto actual; si elige otra, se reemplaza la vista previa -->
               <img id="vista-previa" src="./<?php echo htmlspecialchars($imagenActual); ?>" alt="Foto actual" style="display:block;">
               <span id="texto-foto" style="display:none;">+</span>
            </label>

            <input type="file" id="foto" name="foto" accept="image/*" hidden>
        </div>
        <div class="text-center">
            <button type="submit" id="Btncontinue">Guardar cambios</button>
        </div>
    </form>
    <script>
    const inputFoto = document.getElementById('foto');
    const vistaPrevia = document.getElementById('vista-previa');
    const textoFoto = document.getElementById('texto-foto');

    inputFoto.addEventListener('change', function() {

        if (this.files && this.files[0]) {

            const lector = new FileReader();

            lector.onload = function(e) {
                vistaPrevia.src = e.target.result;
                vistaPrevia.style.display = 'block';
                textoFoto.style.display = 'none';
            };

            lector.readAsDataURL(this.files[0]);
        }
    });
    </script>
    <!--FORM DE EDITAR PERFIL-->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <!--Piedepagina-->
    <?php include 'PieDePagina.php'; ?>
    <!--Piedepagina-->
</body>
</html>
