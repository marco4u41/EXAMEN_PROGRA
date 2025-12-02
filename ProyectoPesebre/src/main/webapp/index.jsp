<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page import="java.lang.reflect.Array" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>La Natividad - Proyecto Interactivo</title>
    
    <!-- Carga de Bootstrap CSS y JS --><link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Enlace al archivo CSS externo --><link rel="stylesheet" href="css/style.css">
    
    <!-- Asegura el uso de íconos de Bootstrap --><link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <style>
        /* Estilos del menú desplegable de Bootstrap para ser activado por JS */
        .dropdown-menu {
            display: none; 
            min-width: 12rem;
            border-radius: 0.5rem;
        }
        .dropdown-menu.active {
            display: block; 
        }
        .text-color-rojo { color: var(--color-rojo-oscuro); }
        
        /* Ajuste para el botón de galería 3D que ya no está en iframe */
        .iframe-3d-gallery-container {
            /* Eliminamos estilos de iframe ya que el componente ha sido quitado */
            display: none;
        }
    </style>
    
    <!-- JS DE NIEVE (MOVIDO AL HEAD PARA EJECUCIÓN TEMPRANA) -->
    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const SNOWFLAKE_COUNT = 200; // Aumentado drásticamente
            
            function createSnowflake() {
                const snowContainer = document.getElementById('snow-animation');
                if (!snowContainer) return; 

                const snow = document.createElement('div'); // VUELVE A DIV SIMPLE
                snow.classList.add('snowflake');
                
                const size = Math.random() * 5 + 2; // 2px a 7px
                snow.style.width = `${size}px`;
                snow.style.height = `${size}px`;
                snow.style.opacity = Math.random() * 0.7 + 0.3;
                
                // Posición horizontal
                snow.style.left = `${Math.random() * 100}vw`;
                
                // Posición vertical inicial fuera de la pantalla
                snow.style.top = `-${Math.random() * 100}vh`; 

                // Variables CSS para la animación
                snow.style.setProperty('--x', `${(Math.random() - 0.5) * 50}vw`); // Movimiento lateral
                snow.style.animationDuration = `${Math.random() * 10 + 5}s`; // Duración: 5s a 15s
                snow.style.animationDelay = `-${Math.random() * 15}s`; // Empieza en un punto aleatorio

                snowContainer.appendChild(snow);

                // Recrear el copo después de que termine la animación
                snow.addEventListener('animationiteration', () => {
                    snow.remove();
                    createSnowflake(); // Crea un nuevo copo para un flujo continuo
                });
            }
            
            // Generar copos iniciales
            for (let i = 0; i < SNOWFLAKE_COUNT; i++) {
                createSnowflake();
            }
        });
    </script>
</head>
<body>
    <%-- DECLARACIÓN DE contextPath movida aquí para asegurar que el script del head lo pueda usar --%>
    <% String contextPath = request.getContextPath(); %>

    <!-- Contenedor Principal --><div id="app" class="d-flex flex-column min-vh-100">

        <!-- Barra de Navegación (Header Verde Pino - SÓLIDO) --><header class="header-moderno fixed-top shadow-lg">
            <nav class="navbar navbar-expand-lg container-xxl p-3">
                <!-- Logo --><a class="navbar-brand fw-bold" href="<%= contextPath %>/index.jsp">
                    <!-- LOGO PNG (Reemplazo de la estrella SVG) --><img src="<%= contextPath %>/multimedia/images/logo.png" alt="Logo Natividad" class="logo-img" onerror="this.onerror=null; this.src='https://placehold.co/45x45/FFFFFF/004D40?text=LOG'"> La Natividad
                </a>
                
                <!-- Botón de Hamburguesa para Móviles --><button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>

                <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
                    <ul class="navbar-nav align-items-center fw-semibold">
                        <li class="nav-item"><a class="nav-link mx-2 text-uppercase active-link" href="#inicio">Inicio</a></li>
                        <li class="nav-item"><a class="nav-link mx-2 text-uppercase" href="#contenido">Contenido</a></li>
                        <li class="nav-item"><a class="nav-link mx-2 text-uppercase" href="#juego">Juego</a></li>
                        
                        <% 
                            String userRole = (String) session.getAttribute("user_role");
                            String userName = (String) session.getAttribute("user_nombre");
                            boolean loggedIn = userRole != null;
                        %>
                        
                        <!-- Lógica de Sesión y Menú Admin --><li class="nav-item ms-lg-3">
                            <% if (loggedIn) { %>
                                <!-- MENÚ DESPLEGABLE PARA ADMINISTRADOR --><% if ("administrador".equals(userRole)) { %>
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
                                <!-- ENLACE SIMPLE PARA ESTUDIANTE/OTROS --><a href="<%= contextPath %>/perfil.jsp" class="btn btn-register btn-sm fw-bold shadow btn-rounded-custom">
                                        <%= userName != null ? userName : userRole.substring(0, 1).toUpperCase() + userRole.substring(1) %>
                                    </a>
                                    <a href="<%= contextPath %>/LogoutServlet" class="btn btn-secondary btn-sm ms-2 fw-bold shadow btn-rounded-custom">
                                        Salir
                                    </a>
                                <% } %>
                                
                            <% } else { %>
                                <!-- Enlace a la página de login dedicada --><a href="<%= contextPath %>/login.jsp" class="btn btn-register btn-sm text-uppercase fw-bold shadow btn-rounded-custom">
                                    Iniciar Sesión
                                </a>
                            <% } %>
                        </li>
                    </ul>
                </div>
            </nav>
        </header>

        <!-- Contenido Principal --><main class="flex-grow-1">
            <!-- Mensajes de Alerta/Estado --><% 
                String message = (String) session.getAttribute("message");
                if (message != null) {
                    String status = (String) session.getAttribute("status");
            %>
                <div class="alert alert-<%= "success".equals(status) ? "success" : "danger" %> alert-dismissible fade show fixed-top mt-5" role="alert">
                    <div class="container">
                        <%= message %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </div>
            <% 
                    session.removeAttribute("message");
                    session.removeAttribute("status");
                }
            %>

            <!-- Sección de Inicio (HERO SECTION - FONDO CREMA) --><section id="inicio" class="py-5" style="background-color: var(--color-crema); position: relative;">
                <!-- ANIMACIÓN DE NEVADA --><div id="snow-animation"></div> 
                <div class="container py-5 mt-5">
                    <div class="row align-items-center">
                        
                        <!-- Columna 1: Texto Grande y Botón Redondeado (Texto Oscuro sobre Crema) --><div class="col-md-6 text-center text-md-start mb-4 mb-md-0">
                            <h1 class="hero-title mb-3">La Historia Vuelve a Brillar</h1>
                            <p class="hero-description-text mb-4">
                                Explora la profunda historia, los personajes y el significado de la Natividad a través de contenido interactivo.
                            </p>
                            <a href="#contenido" class="btn btn-dark text-uppercase fw-bold border-2 btn-rounded-custom mt-3" style="background-color: var(--color-pino) !important;">
                                Descubre las Categorías
                            </a>
                        </div>

                        <!-- Columna 2: Video Destacado --><div class="col-md-6">
                            <div class="ratio ratio-16x9 shadow-lg rounded-3 overflow-hidden" style="border: 3px solid var(--color-pino);">
                                <iframe 
                                    src="https://www.youtube.com/embed/fKcB1a9Vz7k?si=OUzx0KGxW47aRAo" 
                                    title="El Significado del Pesebre" 
                                    frameborder="0" 
                                    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" 
                                    referrerpolicy="strict-origin-when-cross-origin" 
                                    allowfullscreen>
                                </iframe>
                            </div>
                        </div>
                        
                    </div>
                </div>
            </section>

            <!-- Categorías de Contenido (FONDO ROJO OSCURO - ALTO CONTRASTE) --><section id="contenido" class="py-5" style="background-color: var(--color-rojo-oscuro);">
                <div class="container py-5">
                    <!-- Título de Categorías en PLATA --><h2 class="text-4xl fw-bold text-center mb-5 section-title-light">Explora las Categorías</h2>
                    <div class="row g-4">
                        
                        <% 
                            String catPersonajes = URLEncoder.encode("Personajes", StandardCharsets.UTF_8.toString());
                            String catInteractivo = URLEncoder.encode("Interactivo", StandardCharsets.UTF_8.toString());
                            
                            // Rutas de las imágenes subidas por el usuario
                            String imgHistoria = contextPath + "/multimedia/images/cat1.jpg"; 
                            String imgPersonajes = contextPath + "/multimedia/images/cat2.jpg";
                            String imgInteractivo = contextPath + "/multimedia/images/cat3.jpg";
                        %>
                        
                        <!-- Categoría 1: Historia y Profecía --><div class="col-md-4">
                            <div class="card h-100 shadow border-0 category-card">
                                <!-- Imagen Superior con Fondo Verde --><div class="card-image-top-container">
                                    <img src="<%= imgHistoria %>" class="card-image-top" alt="Icono de Historia" 
                                         onerror="this.onerror=null; this.src='https://placehold.co/400x180/004D40/FFD700?text=HISTORIA+IMAGEN'">
                                </div>
                                <div class="card-body d-flex flex-column">
                                    <h3 class="card-title fw-bold mb-3"><i class="bi bi-journal-text me-2"></i> 1. Historia y Profecía</h3>
                                    <p class="card-text mb-3">Línea de tiempo interactiva sobre los eventos cronológicos del nacimiento.</p>
                                    <div class="mt-auto text-center">
                                         <a href="<%= contextPath %>/historia_timeline.jsp" class="btn btn-sm btn-plata fw-bold btn-rounded-custom">
                                            Ver Más
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Categoría 2: Personajes Centrales --><div class="col-md-4">
                            <div class="card h-100 shadow border-0 category-card">
                                <!-- Imagen Superior con Fondo Verde --><div class="card-image-top-container">
                                    <img src="<%= imgPersonajes %>" class="card-image-top" alt="Icono de Personajes" 
                                         onerror="this.onerror=null; this.src='https://placehold.co/400x180/004D40/FFD700?text=PERSONAJES+IMAGEN'">
                                </div>
                                <div class="card-body d-flex flex-column">
                                    <h3 class="card-title fw-bold mb-3"><i class="bi bi-people-fill me-2"></i> 2. Personajes y Tradiciones</h3>
                                    <p class="card-text mb-3">Perfiles de María, José, los Pastores y los Magos. Iconografía histórica.</p>
                                    <div class="mt-auto text-center">
                                         <a href="<%= contextPath %>/personajes.jsp" class="btn btn-sm btn-plata fw-bold btn-rounded-custom">
                                            Ver Más
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Categoría 3: Belén Interactivo (3D/RA) --><div class="col-md-4">
                            <div class="card h-100 shadow border-0 category-card">
                                <!-- Imagen Superior con Fondo Verde --><div class="card-image-top-container">
                                    <img src="<%= imgInteractivo %>" class="card-image-top" alt="Icono Interactivo" 
                                         onerror="this.onerror=null; this.src='https://placehold.co/400x180/004D40/FFD700?text=INTERACTIVO+IMAGEN'">
                                </div>
                                <div class="card-body d-flex flex-column">
                                    <h3 class="card-title fw-bold mb-3"><i class="bi bi-controller me-2"></i> 3. Belén Interactivo (3D/RA)</h3>
                                    <p class="card-text mb-3">Simulación 3D: Explora el entorno del pesebre usando WASD y el ratón.</p>
                                    <div class="mt-auto text-center">
                                         <a href="<%= contextPath %>/belen_3d.jsp" class="btn btn-sm btn-plata fw-bold btn-rounded-custom">
                                            Ver Más
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
            
            <!-- Sección de Juego: ROMPECABEZAS Y GALERÍA 3D (2 COLUMNAS) -->
            <section id="juego" class="py-5" style="background-color: var(--color-crema);">
                <div class="container py-5 text-center">
                    <h2 class="text-4xl fw-bold mb-4 section-title-dark">Juego Interactivo: Rompecabezas del Pesebre</h2>
                    <p class="text-secondary mb-4 fs-5" style="color: var(--color-texto-oscuro);">
                        Reordena las piezas para restaurar la escena de la Natividad.
                    </p>
                    
                    <div id="game-container" class="card mx-auto p-4 shadow-lg border-2" style="max-width: 500px; border-color: var(--color-pino) !important; border-radius: 1rem;">
                        <canvas id="puzzleCanvas" class="w-100 rounded shadow-sm border border-secondary"></canvas>
                        <div class="mt-4 d-flex justify-content-between align-items-center">
                            <button id="shuffle-btn" class="btn btn-register btn-sm text-uppercase fw-bold shadow btn-rounded-custom">
                                Barajar
                            </button>
                            <div id="message" class="fs-6 fw-bold" style="color: var(--color-pino);"></div>
                        </div>
                    </div>
                    
                    <!-- ENLACE DIRECTO A LA GALERÍA 3D -->
                    <div class="mt-5 pt-3 border-top">
                        <h3 class="fs-4 fw-bold mb-3 section-title-dark">Galería de Adornos 3D</h3>
                        <p class="text-secondary mb-4 fs-5" style="color: var(--color-texto-oscuro);">
                            Explora los objetos navideños en 360 grados en una ventana completa.
                        </p>
                        <a href="<%= contextPath %>/galeria_3d.jsp" class="btn btn-lg btn-plata fw-bold btn-rounded-custom">
                           Abrir Galería 3D
                        </a>
                    </div>

                </div>
            </section>

        </main>

        <!-- Footer (Fondo Pino) --><footer class="text-white p-4 text-center mt-auto" style="background-color: var(--color-pino);">
            <p class="mb-0">&copy; 2024 Proyecto Natividad Interactiva. Proyecto JSP/PostgreSQL.</p>
        </footer>
    </div>

    <!-- JavaScript para Lógica del Menú, Juego y Animación de Nieve --><script>
        // --- Lógica del Menú Admin (Activado por clic) ---
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
        
        // --- Lógica de la Animación de Nieve ---
        function createSnowflake() {
            const snowContainer = document.getElementById('snow-animation');
            if (!snowContainer) return; 

            const snow = document.createElement('div'); // VUELVE A DIV
            snow.classList.add('snowflake');
            
            const size = Math.random() * 5 + 2; // 2px a 7px
            snow.style.width = `${size}px`;
            snow.style.height = `${size}px`;
            snow.style.opacity = Math.random() * 0.7 + 0.3;
            
            snow.style.left = `${Math.random() * 100}vw`;
            snow.style.top = `-${Math.random() * 100}vh`; 

            snow.style.setProperty('--x', `${(Math.random() - 0.5) * 50}vw`); // Movimiento lateral
            snow.style.animationDuration = `${Math.random() * 10 + 5}s`; 
            snow.style.animationDelay = `-${Math.random() * 15}s`; 

            snowContainer.appendChild(snow);

            snow.addEventListener('animationiteration', () => {
                snow.remove();
                createSnowflake(); 
            });
        }
        
        // --- Lógica del Rompecabezas (Sliding Tile Puzzle) ---
        
        const PUZZLE_DIMENSION = 3; 
        const TILE_COUNT = PUZZLE_DIMENSION * PUZZLE_DIMENSION;
        const EMPTY_TILE_INDEX = TILE_COUNT - 1;
        const PUZZLE_IMAGE_URL = '<%= contextPath %>/multimedia/images/puzzle_game.jpg'; 
        
        let tiles = []; 
        let canvas, ctx, img;
        let tileWidth, tileHeight;

        /**
         * Inicializa el canvas y carga la imagen para el puzzle.
         */
        function initPuzzle() {
            canvas = document.getElementById('puzzleCanvas');
            ctx = canvas.getContext('2d');
            img = new Image();
            
            img.onload = () => {
                initPuzzleDynamicSize(); // Llamar a la función de dimensionamiento dinámico
                resetPuzzle();
                canvas.addEventListener('click', handleTileClick);
            };
            img.onerror = () => {
                showGameMessage('Error: Imagen del puzzle no cargada. (Verifica multimedia/images/puzzle_game.jpg)');
                // Dibuja un cuadrado de color para que el juego sea jugable incluso sin imagen
                ctx.fillStyle = '#f0f0f0';
                ctx.fillRect(0, 0, canvas.width, canvas.height);
                resetPuzzle();
            };
            img.src = PUZZLE_IMAGE_URL;
        }
        
        /**
         * Calcula y establece el ancho y alto del canvas basado en la proporción de la imagen.
         */
        function initPuzzleDynamicSize() {
            const gameContainer = document.getElementById('game-container');
            if (!gameContainer || !img.complete) return;

            const maxWidth = gameContainer.offsetWidth - 32; // Ancho máximo del contenedor interno

            let finalWidth = Math.min(img.naturalWidth, maxWidth);
            const imageRatio = img.naturalHeight / img.naturalWidth;
            let finalHeight = finalWidth * imageRatio;

            // Limitar la altura para evitar overflows en móviles si la imagen es muy vertical
            if (finalHeight > 600) { 
                finalHeight = 600;
                finalWidth = finalHeight / imageRatio;
            }

            canvas.width = finalWidth;
            canvas.height = finalHeight;
            
            // Calculamos el tamaño de la baldosa basado en el nuevo tamaño del canvas
            tileWidth = canvas.width / PUZZLE_DIMENSION;
            tileHeight = canvas.height / PUZZLE_DIMENSION; 

            // Aplicar el tamaño al contenedor del canvas 
            canvas.style.width = `${finalWidth}px`;
            canvas.style.height = `${finalHeight}px`;

            drawPuzzle();
        }


        function showGameMessage(msg, isWin = false) {
             const messageEl = document.getElementById('message');
             messageEl.textContent = msg;
             if (isWin) {
                 messageEl.classList.add('text-success'); // Clase Bootstrap
                 setTimeout(() => messageEl.classList.remove('text-success'), 5000);
             }
        }
        
        function resetPuzzle() {
            tiles = Array.from({ length: TILE_COUNT }, (_, i) => i);
            showGameMessage('Listo para jugar!');
            shuffleTiles(300); // Más movimientos para 4x4
            drawPuzzle();
        }
        
        function drawPuzzle() {
            ctx.clearRect(0, 0, canvas.width, canvas.height);

            // Calculamos los tamaños de las baldosas de la imagen original
            const imageTileWidth = img.naturalWidth / PUZZLE_DIMENSION;
            const imageTileHeight = img.naturalHeight / PUZZLE_DIMENSION;

            for (let i = 0; i < TILE_COUNT; i++) {
                const tileIndex = tiles[i];

                if (tileIndex === EMPTY_TILE_INDEX) {
                    const [currentCol, currentRow] = getCoords(i);
                    ctx.fillStyle = '#C0B59E'; 
                    ctx.fillRect(currentCol * tileWidth, currentRow * tileHeight, tileWidth, tileHeight);
                    continue;
                }

                const [originalCol, originalRow] = getCoords(tileIndex);
                const [currentCol, currentRow] = getCoords(i);

                // FIX CRÍTICO: Usar los tamaños de la imagen original (naturalWidth/Height)
                // como origen (sx, sy, sWidth, sHeight)
                // y los tamaños del canvas como destino (dx, dy, dWidth, dHeight).

                ctx.drawImage(
                    img,
                    // Parámetros de ORIGEN (Source) en la imagen real
                    originalCol * imageTileWidth, // sx
                    originalRow * imageTileHeight, // sy
                    imageTileWidth, // sWidth
                    imageTileHeight, // sHeight
                    
                    // Parámetros de DESTINO (Destination) en el canvas
                    currentCol * tileWidth, // dx
                    currentRow * tileHeight, // dy
                    tileWidth, // dWidth
                    tileHeight // dHeight
                );
                
                ctx.strokeStyle = 'rgba(255, 255, 255, 0.6)';
                ctx.lineWidth = 2;
                ctx.strokeRect(currentCol * tileWidth, currentRow * tileHeight, tileWidth, tileHeight);
            }
        }

        function getCoords(index) {
            const col = index % PUZZLE_DIMENSION;
            const row = Math.floor(index / PUZZLE_DIMENSION);
            return [col, row];
        }

        function handleTileClick(event) {
            const rect = canvas.getBoundingClientRect();
            const x = event.clientX - rect.left;
            const y = event.clientY - rect.top;

            const clickedCol = Math.floor(x / tileWidth);
            const clickedRow = Math.floor(y / tileHeight);
            const clickedIndex = clickedRow * PUZZLE_DIMENSION + clickedCol;
            
            let emptyIndex = -1;
            for (let i = 0; i < TILE_COUNT; i++) {
                if (tiles[i] === EMPTY_TILE_INDEX) {
                    emptyIndex = i;
                    break;
                }
            }

            if (emptyIndex !== -1 && isAdjacent(clickedIndex, emptyIndex)) {
                [tiles[clickedIndex], tiles[emptyIndex]] = [tiles[emptyIndex], tiles[clickedIndex]];
                drawPuzzle();
                checkWin();
            }
        }

        function isAdjacent(idx1, idx2) {
            const [c1, r1] = getCoords(idx1);
            const [c2, r2] = getCoords(idx2);
            
            return (r1 === r2 && Math.abs(c1 - c2) === 1) || (c1 === c2 && Math.abs(r1 - r2) === 1);
        }

        function shuffleTiles(moves) {
            let emptyIndex = -1;
            for (let i = 0; i < TILE_COUNT; i++) {
                if (tiles[i] === EMPTY_TILE_INDEX) {
                    emptyIndex = i;
                    break;
                }
            }
            if (emptyIndex === -1) return;

            let lastMove = -1; 

            for (let i = 0; i < moves; i++) {
                const possibleMoves = [];
                const [eCol, eRow] = getCoords(emptyIndex);

                const adjacents = [
                    (eRow > 0) ? emptyIndex - PUZZLE_DIMENSION : -1, 
                    (eRow < PUZZLE_DIMENSION - 1) ? emptyIndex + PUZZLE_DIMENSION : -1, 
                    (eCol > 0) ? emptyIndex - 1 : -1, 
                    (eCol < PUZZLE_DIMENSION - 1) ? emptyIndex + 1 : -1  
                ].filter(idx => idx !== -1 && idx !== lastMove);

                possibleMoves.push(...adjacents);

                if (possibleMoves.length > 0) {
                    const moveIndex = possibleMoves[Math.floor(Math.random() * possibleMoves.length)];
                    
                    [tiles[moveIndex], tiles[emptyIndex]] = [tiles[emptyIndex], tiles[moveIndex]];
                    lastMove = emptyIndex;
                    emptyIndex = moveIndex;
                }
            }
        }

        function checkWin() {
            for (let i = 0; i < TILE_COUNT; i++) {
                if (tiles[i] !== i) {
                    return false;
                }
            }
            showGameMessage('¡Felicidades, has resuelto el rompecabezas!', true);
            return true;
        }

        window.onload = function() {
            initPuzzle();
            const shuffleBtn = document.getElementById('shuffle-btn');
            if (shuffleBtn) {
                shuffleBtn.addEventListener('click', resetPuzzle);
            }

            // Manejar redimensionamiento de la ventana para recalcular el tamaño del canvas
            window.addEventListener('resize', () => {
                initPuzzleDynamicSize();
            });
            window.dispatchEvent(new Event('resize')); 
            
            // --- FIX DE LA NIEVE ---
            // Asegurar el ciclo continuo (gestionado dentro de createSnowflake ahora)
            const SNOWFLAKE_COUNT = 100;

            // Generar copos iniciales
            for (let i = 0; i < SNOWFLAKE_COUNT; i++) {
                createSnowflake();
            }
        };
    </script>
</body>
</html>