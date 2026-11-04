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
      <?php include 'navbar.php'; ?>
    <!--NAVBAR-->
    <!--FORM DE LOGIN-->
<div class="divtitle">
  <h1 id="title">Iniciar Sesion</h1>
  <h2 id="subtitle">¿Ya tienes una cuenta? Inicia sesión aquí. Si no, crea una nueva cuenta en segundos.</h2>
</div>

<form class="containerpadre" action="php/logica_IniciarSesion.php" method="POST">

    <div class="form-field">
        <label for="user" class="form-label">Direccion de Correo Electronico</label>
        <input type="email" class="form-control" id="user" name="user" placeholder="name@example.com" required>
    </div>

    <div class="form-field">
        <label for="pass" class="form-label">Contraseña</label>
        <input type="password" class="form-control" id="pass" name="pass" placeholder="example:12345" required>
    </div>

    <div class="text-center">
        <button type="submit" id="Btncontinue">Continuar</button>
    </div>

</form>
<!--FORM DE LOGIN-->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>