<?php session_start(); ?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="./css/home.css">
    
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <!--NAVBAR-->
    <?php include 'navbar.php'; ?>
    <!--NAVBAR-->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<!--CARRUSEL-->
<div class="carrusel-contenedor">
  <div id="carouselExampleControls" class="carousel slide" data-bs-ride="carousel">
    <div class="carousel-inner">
      <div class="carousel-item active">
        <img class="d-block w-100" src="./img/carrusel1.png" alt="First slide">
      </div>
      <div class="carousel-item">
        <img class="d-block w-100" src="./img/carrusel2.png" alt="Second slide">
      </div>
      <div class="carousel-item">
        <img class="d-block w-100" src="./img/carrusel3.png" alt="Third slide">
      </div>
    </div>

    <button class="carousel-control-prev" type="button" data-bs-target="#carouselExampleControls" data-bs-slide="prev">
      <span class="carousel-control-prev-icon" aria-hidden="true"></span>
      <span class="visually-hidden">Anterior</span>
    </button>
    <button class="carousel-control-next" type="button" data-bs-target="#carouselExampleControls" data-bs-slide="next">
      <span class="carousel-control-next-icon" aria-hidden="true"></span>
      <span class="visually-hidden">Siguiente</span>
    </button>
  </div>
</div>
<!--CARRUSEL-->

<!--HERO-->
<section class="hero-mg">
  <h1 class="hero-titulo">¡Bienvenidos! A Market Go</h1>
  <p class="hero-texto">
    Todo lo que necesitás, en un solo lugar. ¡Descubrí una nueva forma de comprar con MarketGo!
  </p>
  <a href="CatalogoProductos.php" class="hero-boton">Explorar Productos</a>
</section>
<!--HERO-->

  </div>
</div>
    <!--CARRUSEL-->
    <!--Piedepagina-->
    <?php include 'PieDePagina.php'; ?>
    <!--Piedepagina-->
</body>
</html>