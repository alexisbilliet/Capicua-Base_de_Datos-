<?php include 'php/logicaProducto.php'; ?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?php echo htmlspecialchars($p['Producto']); ?> - MarketGo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="./css/producto.css">
</head>
<body>
    <!--NAVBAR-->
    <?php include 'navbar.php'; ?>
    <!--NAVBAR-->

    <div class="producto-layout">

        <div class="producto-arriba">

            <div class="producto-foto">
                <img src="./<?php echo htmlspecialchars($imagen); ?>" alt="<?php echo htmlspecialchars($p['Producto']); ?>">
            </div>

            <div class="producto-info">
                <h1><?php echo htmlspecialchars($p['Producto']); ?></h1>

                <div class="producto-sub">
                    <span><?php echo $p['Cantidad'] > 0 ? ' ' . $p['Promedio'] . ' (' . $p['Cantidad'] . ')' : 'Sin reseñas'; ?></span>
                </div>

                <div class="producto-gris"><?php echo $p['Stock'] > 0 ? $p['Stock'] . ' Cantidad de stock' : 'Sin stock'; ?></div>
                <div class="producto-precio">$<?php echo number_format($p['Precio'], 0, ',', '.'); ?> ARS</div>
                <div class="producto-gris">Venderdor:    <?php echo htmlspecialchars($p['Vendedor'] . ' ' . $p['Apellido']); ?></div>
<br>
                <button type="button" class="btn-producto">Añadir al carrito</button>
                <button type="button" class="btn-producto">Comprar ahora</button>
                <h2 class="producto-caract">Características</h2>
                
                <ul>
                    <?php while ($d = $detalles->fetch_assoc()) { ?>
                        <li><?php echo htmlspecialchars($d['Titulo']); ?>  <?php echo htmlspecialchars($d['Descripcion']); ?></li>
                    <?php } ?>
                </ul>
            </div>

        </div>

        <div class="producto-descripcion">
            <h2>Descripción</h2>
            <p><?php echo nl2br(htmlspecialchars($p['Descripcion'])); ?></p>
        </div>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <!--Piedepagina-->
    <?php include 'PieDePagina.php'; ?>
    <!--Piedepagina-->
</body>
</html>
