<?php include 'php/auth.php'; ?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="./css/vender.css">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vender</title>
</head>
<body>
    <!--NAVBAR-->
    <?php include 'navbar.php'; ?>
    <!--NAVBAR-->

    <!--TITULO-->
    <div class="titulo-vender">
        <h1>Vender</h1>
    </div>

    <!--FORM DE VENDER-->
    <form class="form-vender" action="php/logicaVender.php" method="POST" enctype="multipart/form-data">

        <div class="columna-datos">
            <div class="campo">
                <label for="nombre">Nombre de producto</label>
                <input type="text" id="nombre" name="nombre" placeholder="Ej.: Celular Samsung A55 5G" maxlength="100" required>
            </div>

            <div class="campo">
                <label for="precio">Precio</label>
                <input type="number" id="precio" name="precio" placeholder="Ej.: $ 650.999" min="0" step="1" required>
            </div>

            <div class="campo">
                <label>Características del producto</label>
                <div id="lista-detalles">
                    <div class="detalle-fila">
                        <input type="text" name="detalle_titulo[]" placeholder="Título (Ej.: Memoria)" maxlength="50">
                        <input type="text" name="detalle_descripcion[]" placeholder="Descripción (Ej.: 128GB)" maxlength="100">
                    </div>
                </div>
                <button type="button" id="btn-agregar-detalle" class="btn-agregar">+ Agregar otra característica</button>
            </div>

            <div class="campo">
                <label for="descripcion">Descripción</label>
                <textarea id="descripcion" name="descripcion" rows="4" placeholder="Celular Samsung A55 5g&#10;Más de 80% de capacidad&#10;Pantalla sin detalles ni imperfecciones&#10;Color: Azul Oscuro" required></textarea>
            </div>

            <div class="campo">
                <label for="categoria">Categoría</label>
                <input type="text" id="categoria" name="categoria" placeholder="Nombre de categoría" maxlength="50" required>
            </div>

            <div class="campo">
                <label for="stock">Stock</label>
                <input type="number" id="stock" name="stock" placeholder="Número de cantidad del producto" min="0" required>
            </div>

            <button type="submit" class="btn-vender">Vender</button>
        </div>

        <div class="columna-foto">
            <label for="foto" class="selector-foto-producto">
                <img id="vista-previa" src="" alt="">
                <span id="texto-foto">Seleccionar<br>foto</span>
            </label>
            <input type="file" id="foto" name="foto" accept="image/*" hidden>
        </div>

    </form>
    <!--FORM DE VENDER-->

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

    // Agregar / quitar características
    const listaDetalles = document.getElementById('lista-detalles');

    document.getElementById('btn-agregar-detalle').addEventListener('click', function() {
        const fila = document.createElement('div');
        fila.className = 'detalle-fila';
        fila.innerHTML =
            '<input type="text" name="detalle_titulo[]" placeholder="Título" maxlength="50">' +
            '<input type="text" name="detalle_descripcion[]" placeholder="Descripción" maxlength="100">' +
            '<button type="button" class="btn-quitar" title="Quitar">&times;</button>';
        listaDetalles.appendChild(fila);
    });

    listaDetalles.addEventListener('click', function(e) {
        if (e.target.classList.contains('btn-quitar')) {
            e.target.parentElement.remove();
        }
    });
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <!--Piedepagina-->
    <?php include 'PieDePagina.php'; ?>
    <!--Piedepagina-->
</body>
</html>
