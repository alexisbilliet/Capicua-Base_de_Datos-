<?php
include('./PHP/conexion.php');
include 'php/auth.php';


?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="./css/micuenta.css">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mi Cuenta</title>
</head>

<body>

    <!-- NAVBAR -->
   <?php include 'navbar.php'; ?>
<!-- NAVBAR -->
    <!-- TITULO -->
    <img src="./img/mi_cuenta.png" id="imgCuenta" alt="Mi Cuenta">

    <!-- PERFIL DEL USUARIO -->
    <?php
    $id = $_SESSION['usuario_id'];

    $query = "select * from Usuarios where IDUsuario = $id";
    $result = mysqli_query($conexion, $query);

    if (!$result) {
        die("Error al consultar datos: " . mysqli_error($conexion));
    }

    $row = mysqli_fetch_assoc($result);
    

    if (!$row) {
        die("No se encontraron los datos del usuario.");
    }
    ?>
    <div class="perfil-layout">

        <div class="ContainerMiCuenta">
            


            <div class="datos-usuario">

                <div class="perfilinfo">
                    <img src=<?php echo htmlspecialchars($row['imagen']); ?> id="fotoperfil1" alt="Perfil" class="rounded-circle" >

                    <div class="nombre-correo">
                        <p><?php echo htmlspecialchars($row['Nombre']); ?> <?php echo htmlspecialchars($row['Apellido']); ?></p>
                        <p><?php echo htmlspecialchars($row['Correo']); ?></p>
                    </div>
                </div>
                <a  href="./EditarPerfil.php"id="btnrojo" ><img src="./img/lapizeditar sinfondo.png" alt="Perfil" width="60" ></a>
            </div>

            <!-- TELEFONO -->
            <div class="dato-cuenta">
                <span id="datotitulo">Telefono</span>: <span id="datodato"><?php echo htmlspecialchars($row['Telefono']); ?></span>

            </div> 
            <!-- CIUDAD -->
            <div class="dato-cuenta">
                <span id="datotitulo">Ciudad</span>:  <span id="datodato"><?php echo htmlspecialchars($row['Ciudad']); ?></span>
                
            </div>
            
            <!-- DIRECCION -->
            <div class="dato-cuenta">
                <span id="datotitulo">Direccion</span>:  <span id="datodato"><?php echo htmlspecialchars($row['Direccion']); ?></span>
            </div>

           

        </div>

    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<!--Piedepagina-->
    <?php include 'PieDePagina.php'; ?>
    <!--Piedepagina-->
</body>
</html>
