<?php include 'php/LogicaCatalogo.php'; ?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MarketGo - Productos</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="./css/estilo.css">
    <link rel="stylesheet" href="./css/catalogo.css">

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

    <div class="contenedor">
        <h1 class="titulo-pagina">Encontra tu proximo favorito.</h1>
        <p class="subtitulo-pagina">Todo lo que buscas, y algo que no sabias que necesitabas.</p>

        <!-- Un solo formulario: buscador + filtros se envian juntos -->
        <form method="GET" action="CatalogoProductos.php">

            <div class="buscador">
                <input type="text" name="buscar" placeholder="Buscar productos por nombre" value="<?php echo htmlspecialchars($buscar); ?>">
                <button type="submit" class="boton-negro">Buscar</button>
            </div>

            <div class="row">
                <!-- FILTROS -->
                <div class="col-12 col-md-3 mb-3">
                    <div class="filtros">
                        <h2>Filtros</h2>

                        <h3>Categorías</h3>
                        <label>
                            <input type="radio" name="categoria" value="" <?php if ($categoria == '') echo 'checked'; ?>> Todas
                        </label>
                        <?php while ($c = $categorias->fetch_assoc()) { ?>
                            <label>
                                <input type="radio" name="categoria" value="<?php echo $c['IDCategoria']; ?>"
                                    <?php if ($categoria == $c['IDCategoria']) echo 'checked'; ?>>
                                <?php echo htmlspecialchars($c['Nombre']); ?>
                            </label>
                        <?php } ?>

                        <h3>Calificación</h3>
                        <select name="promedio">
                            <option value="">Todas</option>
                            <option value="4" <?php if ($promedio == '4') echo 'selected'; ?>>4 estrellas o más</option>
                            <option value="3" <?php if ($promedio == '3') echo 'selected'; ?>>3 estrellas o más</option>
                            <option value="2" <?php if ($promedio == '2') echo 'selected'; ?>>2 estrellas o más</option>
                            <option value="1" <?php if ($promedio == '1') echo 'selected'; ?>>1 estrella o más</option>
                        </select>

                        <h3>Stock</h3>
                        <label>
                            <input type="checkbox" name="stock" value="1" <?php if ($constock != '') echo 'checked'; ?>> Solo con stock
                        </label>

                        <button type="submit" class="boton-negro">Aplicar filtros</button>
                        <a class="limpiar" href="CatalogoProductos.php">Limpiar filtros</a>
                    </div>
                </div>

                <!-- PRODUCTOS -->
                <div class="col-12 col-md-9">
                    <?php if ($resultado) { ?>
                        <p style="color:#737373;"><?php echo $resultado->num_rows; ?> productos para descubrir</p>
                        <div class="cuadricula">
                            <?php
                            while ($p = $resultado->fetch_assoc()) {
                                echo '<a class="tarjeta" href="#">';
                                echo '<img src="./img/perfil.png" alt="' . htmlspecialchars($p['Producto']) . '">';
                                echo '<div class="tarjeta-info">';
                                echo '<div class="categoria">' . htmlspecialchars($p['Categoria']) . '</div>';
                                echo '<div class="nombre">' . htmlspecialchars($p['Producto']) . '</div>';

                                if ($p['Cantidad'] > 0) {
                                    echo '<div class="resenas">★ ' . $p['Promedio'] . ' (' . $p['Cantidad'] . ')</div>';
                                } else {
                                    echo '<div class="resenas">Sin reseñas</div>';
                                }

                                echo '<div class="precio">$ ' . number_format($p['Precio'], 0, ',', '.') . '</div>';
                                echo '<div class="stock">Stock: ' . htmlspecialchars($p['Stock']) . '</div>';
                                echo '</div>';
                                echo '</a>';
                            }
                            ?>
                        </div>
                    <?php } else { ?>
                        <p style="color:red;">Error: <?php echo htmlspecialchars($conexion->error); ?></p>
                    <?php } ?>
                </div>
            </div>

        </form>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
