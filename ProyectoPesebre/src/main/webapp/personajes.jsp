<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Personajes Clave - Natividad</title>
    
    <!-- Carga de Bootstrap CSS y JS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Enlace al archivo CSS externo -->
    <link rel="stylesheet" href="css/style.css">
    
    <!-- Asegura el uso de íconos de Bootstrap -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <style>
        /* Estilos generales de la página */
        body { 
            background-color: var(--color-crema); 
            padding-top: 80px; 
        } 
        .content-title {
            font-family: var(--font-coquette); 
            color: var(--color-pino);
            font-size: 2.5rem;
        }

        /* --- ESTILOS DE LA TARJETA FLIP CARD --- */
        .flip-card {
            background-color: transparent;
            width: 100%;
            height: 400px; /* Altura fija para el efecto */
            perspective: 1000px; /* Necesario para la profundidad 3D */
            cursor: pointer;
            margin-bottom: 2rem;
        }

        .flip-card-inner {
            position: relative;
            width: 100%;
            height: 100%;
            text-align: center;
            transition: transform 0.8s;
            transform-style: preserve-3d;
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.4);
            border-radius: 1rem;
        }

        /* Cuando la tarjeta está volteada */
        .flip-card.flipped .flip-card-inner {
            transform: rotateY(180deg);
        }

        .flip-card-front, .flip-card-back {
            position: absolute;
            width: 100%;
            height: 100%;
            -webkit-backface-visibility: hidden; /* Oculta el reverso cuando no está volteado */
            backface-visibility: hidden;
            border-radius: 1rem;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }

        .flip-card-front {
            background-color: white;
        }

        .flip-card-back {
            background-color: var(--color-pino); 
            color: white;
            transform: rotateY(180deg);
            text-align: left;
            padding: 30px;
            overflow-y: auto; /* Permitir scroll si el texto es muy largo */
            border: 3px solid var(--color-oro); /* Borde dorado al voltear */
        }
        
        .flip-card-back h4 {
            font-family: var(--font-coquette);
            color: var(--color-oro);
            font-weight: bold;
            margin-bottom: 1rem;
            font-size: 1.8rem;
        }
        
        .personaje-img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 1rem;
        }

        .front-title {
            font-family: var(--font-coquette);
            font-size: 1.5rem;
            color: white;
            padding: 10px;
            width: 100%;
            text-align: center;
            position: absolute;
            bottom: 0;
            background: rgba(139, 0, 0, 0.85); /* Rojo oscuro semitransparente */
            border-radius: 0 0 1rem 1rem;
        }
        
        /* Estilos de la tabla */
        .tradiciones-table th {
            background-color: var(--color-rojo-oscuro);
            color: white;
        }
        .tradiciones-table td {
            background-color: #f7f7f7;
            color: var(--color-texto-oscuro);
        }
        .tradiciones-table tr:nth-child(even) td {
            background-color: #f0f0f0;
        }
    </style>
</head>
<body class="d-flex flex-column min-vh-100">
    <% 
        String contextPath = request.getContextPath(); 
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
                    <li class="nav-item"><a class="nav-link mx-2 text-uppercase active-link" href="<%= contextPath %>/index.jsp#contenido">Contenido</a></li>
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

    <!-- CONTENIDO PRINCIPAL (TARJETAS) -->
    <main class="flex-grow-1 container py-4">
        <div class="p-5 rounded-4 w-100 mt-5" style="background-color: var(--color-crema);">
            <h1 class="mb-2 content-title" style="color: var(--color-pino);">Personajes y Tradiciones</h1>
            <p class="text-xl text-secondary mb-5" style="color: var(--color-texto-oscuro);">Haz clic sobre las tarjetas para descubrir la historia de cada personaje clave de la Natividad.</p>
            
            <a href="<%= contextPath %>/index.jsp#contenido" class="inline-block mb-4 text-decoration-none fw-bold" style="color: var(--color-rojo-oscuro);">&larr; Volver a las Categorías</a>

            <div class="row g-4">
                
                <!-- Tarjeta 1: La Virgen María -->
                <div class="col-md-6 col-lg-3">
                    <div class="flip-card" onclick="this.classList.toggle('flipped');">
                        <div class="flip-card-inner">
                            <div class="flip-card-front">
                                <img src="<%= contextPath %>/multimedia/images/maria.png" alt="Virgen María" class="personaje-img">
                                <h3 class="front-title">LA VIRGEN MARÍA</h3>
                            </div>
                            <div class="flip-card-back">
                                <h4>La Madre de Dios</h4>
                                <p>Figura central de la Natividad. María encarna la fe y la obediencia, aceptando el anuncio del ángel Gabriel. Su vida es un testimonio de humildad y servicio, cumpliendo el rol profetizado para dar a luz al Salvador del mundo. Es un símbolo de esperanza y amor maternal.</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Tarjeta 2: San José -->
                <div class="col-md-6 col-lg-3">
                    <div class="flip-card" onclick="this.classList.toggle('flipped');">
                        <div class="flip-card-inner">
                            <div class="flip-card-front">
                                <img src="<%= contextPath %>/multimedia/images/jose.png" alt="San José" class="personaje-img">
                                <h3 class="front-title">SAN JOSÉ</h3>
                            </div>
                            <div class="flip-card-back">
                                <h4>El Custodio y Padre Adoptivo</h4>
                                <p>Descendiente del Rey David y carpintero de oficio. José demostró una fe inquebrantable al aceptar a María y al niño Jesús. Es el custodio de la Sagrada Familia, protegiéndolos del peligro y asegurando el cumplimiento de las profecías al viajar a Belén para el censo. Simboliza la justicia, el trabajo y la protección.</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Tarjeta 3: Los Pastores -->
                <div class="col-md-6 col-lg-3">
                    <div class="flip-card" onclick="this.classList.toggle('flipped');">
                        <div class="flip-card-inner">
                            <div class="flip-card-front">
                                <img src="<%= contextPath %>/multimedia/images/pastores.png" alt="Pastores" class="personaje-img">
                                <h3 class="front-title">LOS PASTORES</h3>
                            </div>
                            <div class="flip-card-back">
                                <h4>Los Primeros Adoradores</h4>
                                <p>Fueron los primeros en recibir la noticia del nacimiento por parte de un coro angelical. Representan la sencillez y la humildad de los que aceptan el mensaje de Dios. Su visita al pesebre es un recordatorio de que el mensaje de la Natividad está dirigido a todos, especialmente a los marginados.</p>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Tarjeta 4: Los Reyes Magos -->
                <div class="col-md-6 col-lg-3">
                    <div class="flip-card" onclick="this.classList.toggle('flipped');">
                        <div class="flip-card-inner">
                            <div class="flip-card-front">
                                <img src="<%= contextPath %>/multimedia/images/magos.png" alt="Reyes Magos" class="personaje-img">
                                <h3 class="front-title">REYES MAGOS</h3>
                            </div>
                            <div class="flip-card-back">
                                <h4>Melchor, Gaspar y Baltasar</h4>
                                <p>Sabios que viajaron desde el Oriente, siguiendo una estrella para encontrar al 'Rey de los Judíos'. Sus regalos (Oro, Incienso y Mirra) simbolizan la realeza de Jesús, su divinidad y su futuro sacrificio. Representan la universalidad de la Natividad, que atrae a todas las naciones y culturas.</p>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
            
            <!-- SECCIÓN DE TRADICIONES -->
            <div class="row mt-5 pt-4">
                <div class="col-12">
                    <h2 class="content-title mb-4" style="color: var(--color-rojo-oscuro);">Tradiciones Populares de la Natividad</h2>
                    <p class="text-secondary mb-4 fs-5" style="color: var(--color-texto-oscuro);">Estas prácticas culturales y religiosas acompañan la celebración del Nacimiento de Jesús a nivel mundial.</p>
                    
                    <div class="table-responsive">
                        <table class="table table-bordered table-striped tradiciones-table">
                            <thead>
                                <tr>
                                    <th style="width: 20%;">Tradición</th>
                                    <th style="width: 30%;">Fecha Clave</th>
                                    <th style="width: 50%;">Significado y Práctica</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>Corona de Adviento</td>
                                    <td>4 Domingos antes de Navidad</td>
                                    <td>Representa el tiempo de espera y preparación. Cada vela encendida simboliza una semana y un valor: Esperanza, Paz, Gozo y Amor.</td>
                                </tr>
                                <tr>
                                    <td>El Pesebre (Nacimiento)</td>
                                    <td>Todo el mes de Diciembre (Clímax el 24)</td>
                                    <td>Recreación de la escena del nacimiento con figuras de la Sagrada Familia, animales y los Reyes Magos. Es un recordatorio de la humildad del evento.</td>
                                </tr>
                                <tr>
                                    <td>Misa de Gallo</td>
                                    <td>Noche del 24 de Diciembre</td>
                                    <td>Servicio religioso nocturno que celebra el nacimiento de Jesús a medianoche. Es una tradición muy arraigada en países de habla hispana.</td>
                                </tr>
                                <tr>
                                    <td>Villancicos</td>
                                    <td>Diciembre</td>
                                    <td>Canciones populares con temática navideña, a menudo sobre el nacimiento del niño Jesús, cantadas para celebrar y traer alegría.</td>
                                </tr>
                                <tr>
                                    <td>Día de Reyes</td>
                                    <td>6 de Enero</td>
                                    <td>Conmemora la visita de los Reyes Magos a Jesús. Se intercambian regalos en muchos países, y se come la Roscón de Reyes.</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <!-- FIN SECCIÓN DE TRADICIONES -->
            
        </div>
    </main>
    <!-- FIN DEL CONTENIDO PRINCIPAL -->

    <!-- FOOTER (COPIA DE INDEX.JSP) -->
    <footer class="text-white p-4 text-center mt-auto" style="background-color: var(--color-pino);">
        <p class="mb-0">&copy; 2024 Proyecto Natividad Interactiva. Proyecto JSP/PostgreSQL.</p>
    </footer>
    <!-- FIN DEL FOOTER -->
    
    <!-- JavaScript para la funcionalidad del menú (Necesaria para el header copiado) -->
    <script>
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
    </script>
</body>
</html>