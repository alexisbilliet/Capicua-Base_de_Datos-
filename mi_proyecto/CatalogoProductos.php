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
   <?php include 'navbar.php'; ?>
    <!--NAVBAR-->

    <div class="contenedor">
        <h1 class="titulo-pagina">Encontra tu proximo favorito.</h1>
        <p class="subtitulo-pagina">Todo lo que buscas, y algo que no sabias que necesitabas.</p>

        <!-- Un solo formulario: buscador + filtros se envian juntos -->
        <form method="GET" action="CatalogoProductos.php">

            

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
                    <div class="buscador">
                        <input type="text" name="buscar" placeholder="Buscar productos por nombre" value="<?php echo htmlspecialchars($buscar); ?>">
                        <button type="submit" class="boton-negro">Buscar</button>
                     </div>
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
