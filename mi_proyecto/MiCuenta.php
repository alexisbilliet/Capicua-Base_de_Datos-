<?php
include('./PHP/conexion.php');
include 'php/auth.php';


?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="./css/estilo.css">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mi Cuenta</title>
</head>

<body>

    <!-- NAVBAR -->
    <nav class="navbar navbar-expand-md bg-1">
  <div class="container-fluid">
    <a class="navbar-brand" href="home.php">
      <img id="imagen" src="./img/marketgo.png" width="150" alt="MarketGo">
    </a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarNav">
      <ul class="navbar-nav ms-auto">
        <li class="nav-item">
          <a class="nav-link active" aria-current="page" href="#">Home</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="#">Link</a>
        </li>
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">Menu</a>
          <ul class="dropdown-menu">
            <li><a class="dropdown-item" href="#">Action</a></li>
            <li><a class="dropdown-item" href="#">Another action</a></li>
            <li><hr class="dropdown-divider"></li>
            <li><a class="dropdown-item" href="#">Something else here</a></li>
          </ul>
         <?php if (isset($_SESSION['usuario_id'])) { ?>
                <!-- CON SESIÓN: imagen de perfil y cerrar sesión -->
                <li class="nav-item">
                  <a href="MiCuenta.php"><img src="./img/perfil.png" id="fotoperfil" alt="Perfil" width="42"></a>
                </li>
                <li class="nav-item"> 
                  <a class="nav-link" href="php/logout.php">Cerrar Sesion</a>
                </li>
            <?php } else { ?>
                <!-- SIN SESIÓN: los botones de siempre -->
                <li class="nav-item">
                  <a id="Sesion" class="nav-link" href="./IniciarSesion.php">Iniciar Sesion</a>
                </li>
                <li class="nav-item">
                  <a id="Registrarse" class="nav-link" href="./Registrarse.php">Registrarse</a>
                </li>
            <?php } ?>
      </ul>
    </div>
  </div>
</nav>

    <!-- TITULO -->
    <img src="./img/mi_cuenta.png" id="imgCuenta" alt="Mi Cuenta">

    <!-- PERFIL DEL USUARIO -->
    <?php
    $id = $_SESSION['usuario_id'];

    $query = "select * from Usuarios where IDUsuario = $id";
    $result = mysqli_query($conexion, $query);

    if (!$result) {
        die("Error al consultar datos: " . mysqli_error($conexion));
    }

    $row = mysqli_fetch_assoc($result);
    

    if (!$row) {
        die("No se encontraron los datos del usuario.");
    }
    ?>
    <div class="perfil-layout">

        <div class="ContainerMiCuenta">

            <div class="datos-usuario">

                <img src="./img/perfil.png" id="fotoperfil1" alt="Perfil">

                <div class="nombre-correo">
                    <p><?php echo htmlspecialchars($row['Nombre']); ?></p>
                    <p><?php echo htmlspecialchars($row['Correo']); ?></p>
                </div>

            </div>

            <!-- TELEFONO -->
            <div class="dato-cuenta">
                <span id="datotitulo">Telefono</span>: <span id="datodato"><?php echo htmlspecialchars($row['Telefono']); ?></span>
            </div> 
            <!-- CIUDAD -->
            <div class="dato-cuenta">
                <span id="datotitulo">Ciudad</span>:  <span id="datodato"><?php echo htmlspecialchars($row['Ciudad']); ?></span>
            </div>

            <!-- DIRECCION -->
            <div class="dato-cuenta">
                <span id="datotitulo">Direccion</span>:  <span id="datodato"><?php echo htmlspecialchars($row['Direccion']); ?></span>
            </div>

           

        </div>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>