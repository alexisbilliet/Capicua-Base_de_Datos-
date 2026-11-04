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