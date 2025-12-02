<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Belen 3D - Simulación Interactiva</title>

    <!-- Carga de Bootstrap CSS y JS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Enlace al archivo CSS externo -->
    <link rel="stylesheet" href="css/style.css">

    <!-- Asegura el uso de íconos de Bootstrap -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <script src="https://cdn.jsdelivr.net/npm/three@0.147.0/build/three.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/three@0.147.0/examples/js/loaders/GLTFLoader.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/three@0.147.0/examples/js/loaders/RGBELoader.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/three@0.147.0/examples/js/pmrem/PMREMGenerator.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/three@0.147.0/examples/js/controls/OrbitControls.js"></script>

    <style>
        /* Estilos específicos de la página 3D */
        body {
            margin: 0;
            overflow: hidden;
            background: #000;
            padding-top: 60px; /* Espacio para el header */
        }
        canvas {
            display: block;
            width: 100vw;
            height: 100vh; /* Asegura que el canvas cubra toda la vista */
            position: fixed; /* Mantiene el canvas como fondo */
            top: 0;
            left: 0;
            z-index: 0;
        }

        /* Overlay de Instrucciones (Ahora usa estilos Bootstrap temáticos) */
        .overlay-instructions {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.75);
            z-index: 100;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
        }
        
        .overlay-instructions h1 {
            font-family: var(--font-coquette);
            color: var(--color-oro);
        }
    </style>
</head>

<body class="d-flex flex-column min-vh-100">

    <% 
        String contextPath = request.getContextPath();
        String modelPath = contextPath + "/multimedia/models/belen.glb";
        String hdrPath   = contextPath + "/multimedia/hdr/spruit_sunrise_1k_HDR.hdr";
        
        // Lógica de sesión (necesaria para el header)
        String userRole = (String) session.getAttribute("user_role");
        String userName = (String) session.getAttribute("user_nombre");
        boolean loggedIn = userRole != null;
    %>

    <!-- HEADER (COPIA DE INDEX.JSP) -->
    <header class="header-moderno fixed-top shadow-lg">
        <nav class="navbar navbar-expand-lg container-xxl p-3">
            <!-- Logo -->
            <a class="navbar-brand fw-bold" href="<%= contextPath %>/index.jsp">
                <img src="<%= contextPath %>/multimedia/images/logo.png" alt="Logo Natividad" class="logo-img" onerror="this.onerror=null; this.src='https://placehold.co/45x45/FFFFFF/004D40?text=LOG'"> La Natividad
            </a>
            
            <!-- Botón de Hamburguesa para Móviles -->
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
                <ul class="navbar-nav align-items-center fw-semibold">
                    <li class="nav-item"><a class="nav-link mx-2 text-uppercase" href="<%= contextPath %>/index.jsp#inicio">Inicio</a></li>
                    <li class="nav-item"><a class="nav-link mx-2 text-uppercase" href="<%= contextPath %>/index.jsp#contenido">Contenido</a></li>
                    <li class="nav-item"><a class="nav-link mx-2 text-uppercase" href="<%= contextPath %>/index.jsp#juego">Juego</a></li>
                    
                    <!-- Lógica de Sesión y Menú Admin -->
                    <li class="nav-item ms-lg-3">
                        <% if (loggedIn) { %>
                            <% if ("administrador".equals(userRole)) { %>
                                <div class="dropdown">
                                    <button onclick="toggleDropdown('admin-menu')" class="btn btn-register btn-sm text-uppercase fw-bold shadow btn-rounded-custom">
                                        Admin: Panel <i class="bi bi-caret-down-fill"></i>
                                    </button>
                                    <div id="admin-menu" class="dropdown-menu dropdown-menu-end shadow">
                                        <a href="<%= contextPath %>/perfil.jsp" class="dropdown-item">Mi Perfil</a>
                                        <div class="dropdown-divider"></div>
                                        <a href="<%= contextPath %>/GestionUsuarioServlet" class="dropdown-item">Gestión de Usuarios</a>
                                        <a href="<%= contextPath %>/admin/BitacoraServlet" class="dropdown-item">Ver Bitácora</a>
                                        <div class="dropdown-divider"></div>
                                        <a href="<%= contextPath %>/LogoutServlet" class="dropdown-item text-danger">Cerrar Sesión</a>
                                    </div>
                                </div>
                            <% } else { %>
                                <a href="<%= contextPath %>/perfil.jsp" class="btn btn-register btn-sm fw-bold shadow btn-rounded-custom">
                                    <%= userName != null ? userName : userRole.substring(0, 1).toUpperCase() + userRole.substring(1) %>
                                </a>
                                <a href="<%= contextPath %>/LogoutServlet" class="btn btn-secondary btn-sm ms-2 fw-bold shadow btn-rounded-custom">
                                    Salir
                                </a>
                            <% } %>
                        <% } else { %>
                            <a href="<%= contextPath %>/login.jsp" class="btn btn-register btn-sm text-uppercase fw-bold shadow btn-rounded-custom">
                                Iniciar Sesión
                            </a>
                        <% } %>
                    </li>
                </ul>
            </div>
        </nav>
    </header>
    <!-- FIN DEL HEADER -->


    <!-- Overlay de Instrucciones -->
    <div id="loading-overlay" class="overlay-instructions">
        <div class="card p-4 text-center" style="background-color: var(--color-pino); border: 3px solid var(--color-oro);">
            <h1 class="h2 mb-3">Simulación 3D (Orbital)</h1>
            <p class="text-white">Usa el ratón para girar, el scroll para hacer zoom y WASD para mover el punto de vista.</p>
            <button id="start-button" class="btn btn-plata fw-bold btn-rounded-custom mt-3">Iniciar Simulación</button>
            <a href="<%= contextPath %>/index.jsp#contenido" class="mt-3 text-white text-decoration-none small">Volver a Categorías</a>
        </div>
    </div>
    <!-- El Canvas se adjuntará aquí como fondo por JS -->

    <!-- CONTENIDO PRINCIPAL (El Main es casi vacío, solo contiene el JS) -->
    <main class="flex-grow-1">
        <!-- Contenedor vacío para que el body pueda recibir el canvas de Three.js -->
    </main>
    <!-- FIN DEL CONTENIDO PRINCIPAL -->


    <!-- FOOTER (COPIA DE INDEX.JSP) -->
    <footer class="text-white p-4 text-center mt-auto" style="background-color: var(--color-pino); z-index: 1;">
        <p class="mb-0">&copy; 2024 Proyecto Natividad Interactiva. Proyecto JSP/PostgreSQL.</p>
    </footer>
    <!-- FIN DEL FOOTER -->

<script>
    // --- Lógica Three.js ---

    let scene, camera, renderer, controls, pmrem;
    const keys = {};
    const moveSpeed = 0.05; 
    
    // Función de despliegue del menú Admin (Necesaria para el header copiado)
    function toggleDropdown(menuId) {
        const menu = document.getElementById(menuId);
        const allDropdowns = document.querySelectorAll('.dropdown-menu');

        allDropdowns.forEach(item => {
            if (item.id !== menuId) {
                item.classList.remove('active');
            }
        });
        menu.classList.toggle('active');
    }

    document.addEventListener('click', (event) => {
        if (!event.target.closest('.dropdown')) {
            const openDropdowns = document.querySelectorAll('.dropdown-menu.active');
            openDropdowns.forEach(menu => {
                menu.classList.remove('active');
            });
        }
    });

    function init() {
        // --------------------------
        // ESCENA
        // --------------------------
        scene = new THREE.Scene();

        // --------------------------
        // CÁMARA
        // --------------------------
        camera = new THREE.PerspectiveCamera(
            75,
            window.innerWidth / window.innerHeight,
            0.1,
            1000
        );
        camera.position.set(0, 1.5, 4);

     // --------------------------
        // RENDERER
        // --------------------------
        renderer = new THREE.WebGLRenderer({ antialias: true });
        renderer.setSize(window.innerWidth, window.innerHeight);
        
        // Configuración para mejor visualización de modelos GLB/HDR
        renderer.toneMapping = THREE.ACESFilmicToneMapping;
        renderer.toneMappingExposure = 3; 
        
        // CRÍTICO: Adjuntar el canvas al body
        document.body.appendChild(renderer.domElement);


        // --------------------------
        // ORBIT CONTROLS
        // --------------------------
        // Usamos OrbitControls para la navegación intuitiva (ratón + teclado)
        controls = new THREE.OrbitControls(camera, renderer.domElement);
        controls.target.set(0, 1, 0);
        controls.enableDamping = true;

        // --------------------------
        // PMREM para HDR
        // --------------------------
        pmrem = new THREE.PMREMGenerator(renderer);
        pmrem.compileEquirectangularShader();

        // --------------------------
        // CARGAR HDR
        // --------------------------
        new THREE.RGBELoader()
            .load("<%= hdrPath %>", function (texture) {
                const envMap = pmrem.fromEquirectangular(texture).texture;
                scene.environment = envMap;
                scene.background = envMap;
                texture.dispose(); // Liberar recursos de la textura original
                pmrem.dispose(); // Liberar recursos del generador
            });

        // --------------------------
        // CARGAR MODELO GLB
        // --------------------------
        const loader = new THREE.GLTFLoader();
        loader.load("<%= modelPath %>", function (gltf) {
            const model = gltf.scene;
            model.scale.set(1, 1, 1);
            scene.add(model);
        },
        undefined,
        function(error) {
            console.error('Error cargando GLB. Asegura la ruta y el archivo: ', error);
            alert('Error al cargar el modelo 3D. Revisa la consola.');
        });

        // --------------------------
        // LISTENERS DE TECLADO (Movimiento WASD/Flechas)
        // --------------------------
        document.addEventListener('keydown', onKeyDown, false);
        document.addEventListener('keyup', onKeyUp, false);
        
        // --------------------------
        // Listener de Redimensionamiento
        // --------------------------
        window.addEventListener('resize', onWindowResize);

        animate();
    }

    // Funciones para rastrear el estado de las teclas
    function onKeyDown(event) {
        if (event.key === ' ' || event.key === 'Control') {
            keys[event.key] = true;
        } else {
            keys[event.key.toUpperCase()] = true;
        }
    }

    function onKeyUp(event) {
        if (event.key === ' ' || event.key === 'Control') {
            keys[event.key] = false;
        } else {
            keys[event.key.toUpperCase()] = false;
        }
    }

    // Función para aplicar el movimiento de la cámara basado en las teclas presionadas
    function handleKeyboardInput() {
        const delta = moveSpeed; 
        
        const direction = new THREE.Vector3();
        camera.getWorldDirection(direction); 
        direction.y = 0; 
        direction.normalize();

        const sideDirection = new THREE.Vector3();
        sideDirection.crossVectors(camera.up, direction); 
        sideDirection.y = 0;
        sideDirection.normalize();

        // --- Movimiento Adelante / Atrás (W / S / Flechas) ---
        if (keys['W'] || keys['ARROWUP']) {
            camera.position.addScaledVector(direction, delta);
            controls.target.addScaledVector(direction, delta);
        }
        if (keys['S'] || keys['ARROWDOWN']) {
            camera.position.addScaledVector(direction, -delta);
            controls.target.addScaledVector(direction, -delta);
        }

        // --- Movimiento Lateral (A / D / Flechas) ---
        if (keys['A'] || keys['ARROWLEFT']) {
            camera.position.addScaledVector(sideDirection, delta);
            controls.target.addScaledVector(sideDirection, delta);
        }
        if (keys['D'] || keys['ARROWRIGHT']) {
            camera.position.addScaledVector(sideDirection, -delta);
            controls.target.addScaledVector(sideDirection, -delta);
        }

        // --- Subir / Bajar ---
        if (keys[' ']) { // Espacio
            camera.position.y += delta;
            controls.target.y += delta;
        }
        if (keys['CONTROL']) { // Control
            camera.position.y -= delta;
            controls.target.y -= delta;
        }
        
        // Actualiza los controles de órbita después del movimiento manual
        controls.update(); 
    }


    // Función para manejar el redimensionamiento de la ventana
    function onWindowResize() {
        camera.aspect = window.innerWidth / window.innerHeight;
        camera.updateProjectionMatrix();
        renderer.setSize(window.innerWidth, window.innerHeight);
    }

    // --------------------------
    // ANIMACIÓN
    // --------------------------
    function animate() {
        requestAnimationFrame(animate);
        
        handleKeyboardInput(); // Procesa el movimiento por teclado y actualiza controls.target
        
        renderer.render(scene, camera);
    }

    // Iniciar la simulación al hacer clic en el botón
    document.getElementById('start-button').addEventListener('click', function() {
        document.getElementById('loading-overlay').style.display = 'none';
        // Opcional: enfocar el cuerpo para que el teclado funcione de inmediato
        document.body.focus(); 
    });


    window.onload = init;
</script>

</body>
</html>