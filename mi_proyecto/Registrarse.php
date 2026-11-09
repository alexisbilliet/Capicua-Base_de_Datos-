<?php session_start(); ?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="./css/formularios.css">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <!--NAVBAR-->
    <?php include 'navbar.php'; ?>
    <!--NAVBAR-->
    <!--FORM DE REGISTRARSE-->
    <div class="divtitle">
        <h1 id="title">Registrarse</h1>
        <h2 id="subtitle">Crea tu Cuenta</h2>
    </div>

    <form class= "containerpadre" action="php/logica_registrarse.php" method="POST" enctype="multipart/form-data">
        <div class="form-field" id="divNA">
            <div class="nombreapellido">
              <label for="nombre" class="form-label">Nombre</label>
              <input type="text" class="form-control" id="nombre" name="nombre" placeholder="Example: Jorge" autocomplete="given-name" maxlength="50"required>
            </div>
            <div class="nombreapellido">
              <label for="nombre" class="form-label">Apellido</label>
              <input type="text" class="form-control" id="nombre" name="apellido" placeholder="Example: Rodriguez" autocomplete="family-name" maxlength="50"required>
            </div>
         </div>
            

        <div class="form-field">
            <label for="correo" class="form-label">Direccion de Correo Electronico</label>
            <input type="email" class="form-control" id="correo" name="correo" placeholder="name@example.com" autocomplete="email" maxlength="50" required>
        </div>

        <div class="form-field">
            <label for="contrasena" class="form-label">Contraseña</label>
            <input type="password" class="form-control" id="contrasena" name="contrasena" placeholder="Example: 12345" autocomplete="new-password" maxlength="50" required>
        </div>

        <div class="form-field">
            <label for="telefono" class="form-label">Telefono</label>
            <input class="form-control" id="telefono" name="telefono" placeholder="Example: 11 6708 9209" autocomplete="tel" rmaxlength="50" required>
        </div>

        <div class="form-field">
            <label for="direccion" class="form-label">Direccion</label>
            <input type="text" class="form-control" id="direccion" name="direccion" placeholder="Example: Av. San Martin 6678" autocomplete="street-address"  maxlength="50" required>
        </div>

        <div class="form-field">
            <label for="ciudad" class="form-label">Ciudad</label>
            <input type="text" class="form-control" id="ciudad" name="ciudad" placeholder="Example: Buenos Aires" autocomplete="address-level2" maxlength="50" required>
        </div>
        <div class="form-field mb-3 text-center">
            <label class="form-label">Foto de Perfil</label>

            <label for="foto" class="selector-foto">
               <img id="vista-previa" src="" alt="">
               <span id="texto-foto">+</span>
            </label>

            <input type="file" id="foto" name="foto" accept="image/*" hidden>
        </div>
        <div class="text-center">
            <button type="submit" id="Btncontinue">Continuar</button>
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
    <!--FORM DE REGISTRARSE-->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <!--Piedepagina-->
    <?php include 'PieDePagina.php'; ?>
    <!--Piedepagina-->
</body>
</html>
