<?php session_start(); ?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MarketGo - Home</title>
   <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="./css/estilo.css">
    <!-- Estilos añadidos para replicar las tarjetas de Mercado Libre -->
    <style>
       body {
    background-color: #f5f5f5; /* Gris claro de fondo de ML */
}

/* Contenedor principal para centrar todo */
.container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 0 16px;
}

/* Cuadrícula para acomodar las tarjetas de forma uniforme */
.cuadricula-productos {
    display: grid;
    /* En computadoras: acomoda todas las tarjetas de 224px que quepan y reparte el espacio con 1fr */
    grid-template-columns: repeat(auto-fill, minmax(224px, 1fr));
    gap: 16px;
    margin: 30px auto;
}

/* Tarjeta con diseño de Mercado Libre */
.tarjeta-ml {
    background-color: #ffffff;
    border-radius: 4px;
    border: 1px solid #ffffff;
    box-shadow: 0 1px 2px 0 rgba(0,0,0,0.1);
    overflow: hidden;
    display: flex;
    flex-direction: column;
    height: 100%;
    cursor: pointer;
    transition: box-shadow 0.2s ease-in-out, border-color 0.2s ease-in-out;
    text-decoration: none;
}

.tarjeta-ml:hover {
    box-shadow: 0 4px 16px 0 rgba(0,0,0,0.1);
    border-color: #e6e6e6;
}

/* Contenedor de la Imagen */
.tarjeta-imagen-wrapper {
    width: 100%;
    height: 224px; /* Proporción cuadrada para la foto */
    display: flex;
    align-items: center;
    justify-content: center;
    border-bottom: 1px solid #eeeeee;
    padding: 16px;
    background-color: #ffffff;
}

.tarjeta-imagen-wrapper img {
    max-width: 100%;
    max-height: 100%;
    object-fit: contain;
}

/* Información de la Tarjeta */
.tarjeta-info {
    padding: 16px;
    display: flex;
    flex-direction: column;
    flex-grow: 1;
}

.tarjeta-titulo {
    font-size: 14px;
    color: #333333;
    font-weight: 400;
    line-height: 1.3;
    margin-bottom: 8px;
    min-height: 36px;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
}

.tarjeta-precio {
    font-size: 22px;
    color: #333333;
    font-weight: 400;
    line-height: 1;
    margin-bottom: 2px;
}

.tarjeta-id {
    font-size: 12px;
    color: #737373;
    margin-bottom: 6px;
}

/* Envío gratis */
.tarjeta-envio {
    font-size: 13px;
    color: #00a650;
    font-weight: 600;
    margin-top: auto;
}

/* ==========================================
   📱 ADAPTACIÓN PARA CELULARES (Móvil First)
   ========================================== */
@media (max-width: 576px) {
    .cuadricula-productos {
        /* En celulares: divide la pantalla exactamente en 2 columnas iguales (50% y 50%) */
        grid-template-columns: repeat(2, 1fr);
        gap: 8px; /* Menos espacio de separación para aprovechar la pantalla chica */
        margin: 16px auto;
    }

    .tarjeta-imagen-wrapper {
        height: 140px; /* Hacemos la foto un poco más baja para que no ocupe toda la pantalla del celu */
        padding: 8px;
    }

    .tarjeta-info {
        padding: 10px; /* Reducimos márgenes internos */
    }

    .tarjeta-titulo {
        font-size: 13px; /* Texto un poquito más chico */
        min-height: 34px;
    }

    .tarjeta-precio {
        font-size: 18px; /* Precio adaptado para que no se corte */
    }
}
    </style>
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
                    </li>
                    <?php if (isset($_SESSION['usuario_id'])) { ?>
                        <li class="nav-item">
                            <a href="MiCuenta.php"><img src="./img/perfil.png" id="fotoperfil" alt="Perfil" width="42"></a>
                        </li>
                        <li class="nav-item"> 
                            <a class="nav-link" href="php/logout.php">Cerrar Sesion</a>
                        </li>
                    <?php } else { ?>
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

    <!-- CONTENEDOR PRINCIPAL DE PRODUCTOS EN TARJETAS -->
    <div class="container">
        <div class="cuadricula-productos">
            <?php
            include 'php/conexion.php'; 

            // Consulta simulando que traes datos para tus tarjetas
            $sql = "SELECT IDUsuario, Nombre FROM usuarios";
            $resultado = $conexion->query($sql);

            if ($resultado) {
                while ($usuario = $resultado->fetch_assoc()) {
                    echo '<div class="tarjeta-ml">';
                    
                    // 1. Imagen del producto (He colocado la de muestra de Joma, puedes apuntar a tu carpeta de imágenes)
                    echo '<div class="tarjeta-imagen-wrapper">';
                    echo '<img src="./img/perfil.png" alt="Imagen del usuario">';
                    echo '</div>';
                    
                    // 2. Bloque de información
                    echo '<div class="tarjeta-info">';
                    // Título/Nombre del producto
                    echo '<div class="tarjeta-titulo">' . htmlspecialchars($usuario['Nombre']) . '</div>';
                    // Pequeña etiqueta identificadora o ID debajo del título
                    echo '<div class="tarjeta-id">ID de usuario: #' . htmlspecialchars($usuario['IDUsuario']) . '</div>';
                    // Precio simulado dinámico basado en su ID para variar el aspecto visual
                    $precio_simulado = number_format(100000 + ($usuario['IDUsuario'] * 3500), 0, ',', '.');
                    echo '<div class="tarjeta-precio">$ ' . $precio_simulado . '</div>';
                    // Envío gratis característico
                    echo '<div class="tarjeta-envio">Llega gratis hoy</div>';
                    echo '</div>'; // Cierre tarjeta-info
                    
                    echo '</div>'; // Cierre tarjeta-ml
                }
                $resultado->free();
            } else {
                echo '<div style="padding: 16px; color: red;">Error: ' . htmlspecialchars($conexion->error) . '</div>';
            }
            ?>
        </div>
    </div>

    <!-- Bootstrap Bundle JS -->
   <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
