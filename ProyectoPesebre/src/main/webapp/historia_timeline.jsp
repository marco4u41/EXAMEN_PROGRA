<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>          
<%@ page import="java.util.Arrays" %>         
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Historia y Profecía - Línea de Tiempo</title>
    
    <!-- Carga de Bootstrap CSS y JS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Enlace al archivo CSS externo -->
    <link rel="stylesheet" href="css/style.css">
    
    <!-- Asegura el uso de íconos de Bootstrap -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <style>
        /* Estilos específicos de esta página (Herencia del Body de Index) */
        body { 
            background-color: var(--color-rojo-oscuro); /* El fondo principal es el color de la sección de categorías */
            padding-top: 80px; /* Espacio para el header fijo */
        } 
        
        /* Asegura que el título del contenido tenga la fuente coquette */
        .content-title {
            font-family: var(--font-coquette); 
            color: var(--color-pino);
            font-size: 2.5rem;
        }

        /* Estilos específicos para la línea de tiempo basada en Accordion */
        .timeline-accordion .accordion-item {
            border: none;
            border-left: 4px solid var(--color-oro); /* Línea dorada sobre rojo oscuro */
            margin-bottom: 20px;
            border-radius: 0;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.5);
        }
        .timeline-accordion .accordion-button {
            background-color: white; 
            color: var(--color-pino);
            font-size: 1.25rem;
            padding: 1.3rem;
            font-weight: 700;
        }
        .timeline-accordion .accordion-body {
            background-color: var(--color-crema); /* Fondo crema dentro del acordeón */
            color: var(--color-texto-oscuro);
            font-family: var(--bs-font-sans-serif); /* Usar fuente Inter para lectura de párrafos */
            line-height: 1.6;
        }
    </style>
</head>
<body>
    <% 
        String contextPath = request.getContextPath(); 
        // Lógica de sesión (necesaria para el header)
        String userRole = (String) session.getAttribute("user_role");
        String userName = (String) session.getAttribute("user_nombre");
        boolean loggedIn = userRole != null;
    %>

    <!-- Contenedor Principal (Minimiza el div contenedor principal) -->
    <div id="app" class="d-flex flex-column min-vh-100">

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

        <!-- CONTENIDO PRINCIPAL (LÍNEA DE TIEMPO) -->
        <main class="flex-grow-1 container py-4">
            <div class="bg-white p-5 rounded-4 shadow-lg w-100 mt-5" style="border-top: 5px solid var(--color-pino);">
                <h1 class="mb-2 content-title" style="color: var(--color-rojo-oscuro);">Categoría: Historia y Profecía</h1>
                <p class="text-xl text-secondary mb-4" style="color: var(--color-texto-oscuro);">Línea de Tiempo Interactiva sobre la cronología del Nacimiento de Jesús.</p>
                
                <a href="<%= contextPath %>/index.jsp#contenido" class="inline-block mb-4 text-decoration-none fw-bold" style="color: var(--color-rojo-oscuro);">&larr; Volver a las Categorías</a>

                <hr class="mb-4">

                <!-- --- LÍNEA DE TIEMPO INTERACTIVA (Diseño Acordeón) --- -->
                <div class="accordion timeline-accordion" id="timelineAccordion">
                    
                    <%
                        // Definición de la clase interna para el JSP (Mantenemos los datos)
                        class TimelineItem {
                            String id;
                            String title;
                            String body;
                            String mediaType; 
                            String mediaUrl;

                            public TimelineItem(String id, String title, String body, String mediaType, String mediaUrl) {
                                this.id = id;
                                this.title = title;
                                this.body = body;
                                this.mediaType = mediaType;
                                this.mediaUrl = mediaUrl;
                            }
                        }

                        // CONTENIDO FIJO CON RUTAS LOCALES Y TEXTO AMPLIADO
                        List<TimelineItem> items = Arrays.asList(
                            new TimelineItem(
                                "1",
                                "Profecías de Isaías y Miqueas",
                                "Los profetas del Antiguo Testamento no solo predijeron la venida del Mesías, sino también detalles cruciales sobre su nacimiento. Isaías anunció que nacería de una virgen (Isaías 7:14), mientras que Miqueas especificó el lugar exacto: Belén de Judá (Miqueas 5:2). Estas profecías, dadas con siglos de antelación, actuaron como un mapa para la fe, confirmando la divinidad y el plan histórico detrás de la Natividad.",
                                "image",
                                "multimedia/images/profecia_isaias.jpeg" 
                            ),
                            new TimelineItem(
                                "2",
                                "La Anunciación a María",
                                "El evento de la Anunciación marca el inicio de la cronología del Nuevo Testamento. El ángel Gabriel se apareció a María en Nazaret, comunicándole que, por obra del Espíritu Santo, concebiría y daría a luz al Hijo de Dios. La respuesta de María, 'Hágase en mí según tu palabra', es vista como el acto supremo de obediencia y fe que permitió que el Salvador entrara en la historia humana. Este evento es fundamental en el arte sacro.",
                                "image",
                                "multimedia/images/virgen_jose.png" // Usamos tu imagen de virgen/José para la Anunciación
                            ),
                            new TimelineItem(
                                "3",
                                "El Edicto del Censo de Augusto",
                                "El emperador romano Augusto César decretó un censo en todo el Imperio, lo que obligó a cada ciudadano a registrarse en su ciudad de origen. José, descendiente del Rey David, tuvo que viajar desde Nazaret hasta Belén. Aunque fue un mandato político, este censo aseguró que Jesús naciera precisamente en Belén, tal como lo había profetizado Miqueas, entrelazando el destino político con el cumplimiento bíblico. El viaje fue largo y arduo para María, que estaba próxima a dar a luz.",
                                "audio",
                                "multimedia/audios/decreto_augusto.mp3" 
                            ),
                            new TimelineItem(
                                "4",
                                "El Nacimiento en Belén",
                                "Al llegar a Belén, María y José no encontraron alojamiento disponible debido a la afluencia de gente por el censo. Jesús nació en la humildad de un establo y fue recostado en un pesebre. La escena simboliza la encarnación, donde la divinidad se manifiesta en la condición más sencilla y vulnerable, marcando el inicio de la redención humana.",
                                "video",
                                "https://www.youtube.com/embed/fKcB1a9Vz7k?si=OUzxV0KGxW47aRAo" // Video de YouTube
                            ),
                            new TimelineItem(
                                "5",
                                "Visita de los Pastores",
                                "Mientras vigilaban sus rebaños en los campos cercanos a Belén, unos pastores recibieron la gloriosa visita de un ángel, seguido por una multitud del ejército celestial, que les anunció el nacimiento del Salvador. Los pastores, considerados los más humildes de la sociedad, fueron los primeros en adorar a Jesús, un evento que subraya el mensaje de inclusión y humildad de la Natividad.",
                                "image",
                                "multimedia/images/pastores.jpg" 
                            )
                        );

                        for (TimelineItem item : items) { 
                    %>
                    
                    <div class="accordion-item">
                        <h2 class="accordion-header" id="heading-<%= item.id %>">
                            <!-- El botón de acordeón -->
                            <button 
                                class="accordion-button <%= "1".equals(item.id) ? "" : "collapsed" %>" 
                                type="button" 
                                data-bs-toggle="collapse" 
                                data-bs-target="#collapse-<%= item.id %>" 
                                aria-expanded="<%= "1".equals(item.id) ? "true" : "false" %>" 
                                aria-controls="collapse-<%= item.id %>">
                                
                                <%= item.title %>
                            </button>
                        </h2>
                        
                        <!-- Cuerpo del acordeón (contenido desplegable) -->
                        <div 
                            id="collapse-<%= item.id %>" 
                            class="accordion-collapse collapse <%= "1".equals(item.id) ? "show" : "" %>" 
                            aria-labelledby="heading-<%= item.id %>">
                            
                            <div class="accordion-body">
                                <p class="mb-4 pt-2" style="color: var(--color-texto-oscuro);"><%= item.body %></p>

                                <!-- Multimedia Fijo -->
                                <% 
                                    String url = item.mediaUrl;
                                    if (url != null && !url.isEmpty()) {
                                        // Lógica para resolver rutas: añade contextPath si no es URL externa
                                        String finalUrl = url.startsWith("http") ? url : contextPath + "/" + url;
                                        
                                        if ("video".equals(item.mediaType)) { %>
                                            <div class="ratio ratio-16x9 w-100 mt-3">
                                                <iframe width="100%" height="200" src="<%= finalUrl %>" frameborder="0" allowfullscreen class="rounded-lg"></iframe>
                                            </div>
                                        <% } else if ("audio".equals(item.mediaType)) { %>
                                            <audio controls class="w-100 mt-3">
                                                <source src="<%= finalUrl %>" type="audio/mpeg">
                                                Tu navegador no soporta el elemento de audio.
                                            </audio>
                                        <% } else if ("image".equals(item.mediaType)) { %>
                                            <img src="<%= finalUrl %>" alt="<%= item.title %>" class="img-fluid rounded-lg mt-3" onerror="this.onerror=null; this.src='https://placehold.co/400x200/D4AF37/FFFFFF?text=Imagen+Histórica'">
                                        <% }
                                    }
                                %>
                            </div>
                        </div>
                    </div>
                    <% 
                        } 
                    %>
                </div>
                
            </div>
        </main>
        <!-- FIN DEL CONTENIDO PRINCIPAL -->

        <!-- FOOTER (COPIA DE INDEX.JSP) -->
        <footer class="text-white p-4 text-center mt-auto" style="background-color: var(--color-pino);">
            <p class="mb-0">&copy; 2024 Proyecto Natividad Interactiva. Proyecto JSP/PostgreSQL.</p>
        </footer>
        <!-- FIN DEL FOOTER -->
        
    </div>

    <!-- JavaScript para la funcionalidad de despliegue (Si fuera necesario, aunque Bootstrap lo maneja) -->
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