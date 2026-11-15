<link rel="stylesheet" href="./css/navbar.css">
<nav class="navbar navbar-expand-md bg-1">
  <div class="container-fluid">
    <a class="navbar-brand" href="home.php">
      <img id="imagen" src="./img/marketgo.png" width="150" alt="MarketGo">
    </a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarNav">
      <ul class="navbar-nav ms-auto align-items-center">
         <?php if (isset($_SESSION['usuario_id'])) { ?>
            <li class="nav-item vender" >
              <a class="nav-link" href="./vender.php" id="linkvender" >Vende Tu Producto!!</a>
            </li>
                <?php $rutaimagen = $_SESSION['imagen']; ?>
                <!-- CON SESIÓN: imagen de perfil y cerrar sesión -->
                <li class="nav-item d-flex align-items-center" >
                  <a href="MiCuenta.php" class="d-flex align-items-center"><img src="./<?php echo $rutaimagen; ?>" id="fotoperfil" alt="Perfil"  class="rounded-circle"  ></a>
                </li>
                <li class="nav-item"> 
                  <a class="nav-link" href="php/logout.php" id="cerrarsesion">Cerrar Sesion</a>
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