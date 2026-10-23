<?php session_start(); ?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="./css/estilo.css">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <!--NAVBAR-->
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
    <!--NAVBAR-->
    <!--FORM DE REGISTRARSE-->
    <div class="divtitle">
        <h1 id="title">Registrarse</h1>
        <h2 id="subtitle">Crea tu Cuenta</h2>
    </div>

    <form class= "containerpadre" action="php/logica_registrarse.php" method="POST">
        <div class="form-field" id="divNA">
            <div class="nombreapellido">
              <label for="nombre" class="form-label">Nombre</label>
              <input type="text" class="form-control" id="nombre" name="nombre" placeholder="Example: Jorge" autocomplete="given-name" required>
            </div>
            <div class="nombreapellido">
              <label for="nombre" class="form-label">Apellido</label>
              <input type="text" class="form-control" id="nombre" name="nombre" placeholder="Example: Rodriguez" autocomplete="family-name" required>
            </div>
         </div>
            

        <div class="form-field">
            <label for="correo" class="form-label">Direccion de Correo Electronico</label>
            <input type="email" class="form-control" id="correo" name="correo" placeholder="name@example.com" autocomplete="email" required>
        </div>

        <div class="form-field">
            <label for="contrasena" class="form-label">Contraseña</label>
            <input type="password" class="form-control" id="contrasena" name="contrasena" placeholder="Example: 12345" autocomplete="new-password" required>
        </div>

        <div class="form-field">
            <label for="telefono" class="form-label">Telefono</label>
            <input class="form-control" id="telefono" name="telefono" placeholder="Example: 11 6708 9209" autocomplete="tel" required>
        </div>

        <div class="form-field">
            <label for="direccion" class="form-label">Direccion</label>
            <input type="text" class="form-control" id="direccion" name="direccion" placeholder="Example: Av. San Martin 6678" autocomplete="street-address" required>
        </div>

        <div class="form-field">
            <label for="ciudad" class="form-label">Ciudad</label>
            <input type="text" class="form-control" id="ciudad" name="ciudad" placeholder="Example: Buenos Aires" autocomplete="address-level2" required>
        </div>

        <div class="text-center">
            <button type="submit" id="Btncontinue">Continuar</button>
        </div>

    </form>

    <!--FORM DE REGISTRARSE-->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
