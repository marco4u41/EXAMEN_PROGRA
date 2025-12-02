<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Date" %>
<%
    // 1. Verificar la sesión: Si no hay sesión, redirigir al login.
    String contextPath = request.getContextPath();
    if (session.getAttribute("user_id") == null) {
        session.setAttribute("message", "Debes iniciar sesión para acceder a tu perfil.");
        session.setAttribute("status", "error");
        response.sendRedirect(contextPath + "/login.jsp");
        return;
    }

    // 2. Obtener datos de la sesión
    String userRole = (String) session.getAttribute("user_role");
    String userName = (String) session.getAttribute("user_nombre");
    String userEmail = (String) session.getAttribute("user_email");
    Integer userId = (Integer) session.getAttribute("user_id");

    // Configuración de bienvenida
    String bienvenida = "Bienvenido, " + userName + "!";
    boolean isAdmin = "administrador".equals(userRole);
    
    // Lógica de sesión (necesaria para el header)
    boolean loggedIn = userRole != null;
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Perfil de Usuario - <%= userName %></title>
    
    <!-- Carga de Bootstrap CSS y JS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Enlace al archivo CSS externo -->
    <link rel="stylesheet" href="css/style.css">
    
    <!-- Asegura el uso de íconos de Bootstrap -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <style>
        /* Estilos específicos para esta página */
        body { 
            background-color: var(--color-crema); 
            /* Quitamos el padding-top del body, lo manejamos en el main */
        } 
        .profile-title {
            font-family: var(--font-coquette); 
            color: var(--color-pino);
            font-size: 3rem;
        }
        .info-card {
            background-color: var(--color-pino);
            color: white;
            border-radius: 1rem;
            border: 2px solid var(--color-oro);
        }
        .access-card {
            border-radius: 1rem;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            border: 1px solid var(--color-plata);
        }
        .access-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
        }
        .access-card h3 {
            font-family: var(--font-coquette);
            color: var(--color-rojo-oscuro);
        }
        .btn-access {
            background-color: var(--color-rojo-oscuro);
            color: white;
            font-weight: bold;
        }
        .btn-access-secondary {
            background-color: var(--color-plata);
            color: var(--color-pino);
            font-weight: bold;
        }
    </style>
</head>
<body class="d-flex flex-column min-vh-100">
    
    <!-- HEADER (COPIA DE INDEX.JSP) -->
    <header class="header-moderno fixed-top shadow-lg">
        <nav class="navbar navbar-expand-lg container-xxl p-3">
            <!-- Logo -->
            <a class="navbar-brand fw-bold" href="<%= contextPath %>/index.jsp">
                <img src="<%= contextPath %>/multimedia/images/logo.png" alt="Logo Natividad" class="logo-img" onerror="this.onerror=null; this.src='images/logo.png'"> La Natividad
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
                        <% if (isAdmin) { %>
                            <div class="dropdown">
                                <button onclick="toggleDropdown('admin-menu')" class="btn btn-register btn-sm text-uppercase fw-bold shadow btn-rounded-custom active-link">
                                    Admin: Panel <i class="bi bi-caret-down-fill"></i>
                                </button>
                                <div id="admin-menu" class="dropdown-menu dropdown-menu-end shadow">
                                    <a href="<%= contextPath %>/perfil.jsp" class="dropdown-item active">Mi Perfil</a>
                                    <div class="dropdown-divider"></div>
                                    <a href="<%= contextPath %>/GestionUsuarioServlet" class="dropdown-item">Gestión de Usuarios</a>
                                    <a href="<%= contextPath %>/admin/BitacoraServlet" class="dropdown-item">Ver Bitácora</a>
                                    <div class="dropdown-divider"></div>
                                    <a href="<%= contextPath %>/LogoutServlet" class="dropdown-item text-danger">Cerrar Sesión</a>
                                </div>
                            </div>
                        <% } else if (loggedIn) { %>
                            <a href="<%= contextPath %>/perfil.jsp" class="btn btn-register btn-sm fw-bold shadow btn-rounded-custom active-link">
                                <%= userName %>
                            </a>
                            <a href="<%= contextPath %>/LogoutServlet" class="btn btn-secondary btn-sm ms-2 fw-bold shadow btn-rounded-custom">
                                Salir
                            </a>
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


    <!-- CONTENIDO PRINCIPAL -->
    <!-- CRÍTICO: Añadimos pt-5 (padding superior) para empujar el contenido debajo del header fijo -->
    <main class="flex-grow-1 container pt-5 py-4">
        <!-- El mt-5 aquí empujará el contenido hacia abajo de forma robusta -->
        <div class="bg-white p-5 rounded-4 shadow-lg w-100 mt-5" style="border-top: 5px solid var(--color-rojo-oscuro);">
            <h1 class="profile-title mb-2" style="color: var(--color-pino);">Dashboard de Usuario</h1>
            <p class="text-secondary mb-4" style="color: var(--color-texto-oscuro);">Gestión de tu información y acceso a herramientas.</p>
            
            <a href="<%= contextPath %>/index.jsp" class="text-decoration-none fw-bold mb-4 d-block" style="color: var(--color-rojo-oscuro);">&larr; Volver a la Página Principal</a>

            <!-- Tarjeta de Información Básica (Verde Pino) -->
            <div class="p-4 info-card mb-5">
                <h2 class="fs-4 fw-bold mb-3" style="color: var(--color-oro);">Tu Perfil (<%= userRole.toUpperCase() %>)</h2>
                <div class="row">
                    <div class="col-md-6 mb-2">
                        <p class="mb-1 fw-semibold">Nombre:</p>
                        <p class="mb-0 small"><%= userName %></p>
                    </div>
                    <div class="col-md-6 mb-2">
                        <p class="mb-1 fw-semibold">ID de Usuario:</p>
                        <p class="mb-0 small"><%= userId %></p>
                    </div>
                    <div class="col-md-6 mb-2">
                        <p class="mb-1 fw-semibold">Correo Electrónico:</p>
                        <p class="mb-0 small"><%= userEmail %></p>
                    </div>
                    <div class="col-md-6 mb-2">
                        <p class="mb-1 fw-semibold">Sesión Iniciada:</p>
                        <p class="mb-0 small"><%= new Date(session.getCreationTime()) %></p>
                    </div>
                </div>
            </div>
            
            <!-- Tarjetas de Acceso por Rol -->
            <div class="row g-4">
                
                <% if (isAdmin) { %>
                    <!-- ACCESOS DEL ADMINISTRADOR -->
                    <div class="col-md-6">
                        <div class="card p-4 h-100 access-card">
                            <h3 class="fs-4 mb-3"><i class="bi bi-person-gear me-2"></i> Gestión de Seguridad</h3>
                            <p class="text-secondary">Administra todos los usuarios, controla los accesos y revisa la bitácora de actividad.</p>
                            <div class="mt-auto pt-3 d-grid gap-2">
                                <a href="<%= contextPath %>/GestionUsuarioServlet" class="btn btn-sm btn-access btn-rounded-custom">
                                    <i class="bi bi-people me-1"></i> Gestionar Usuarios
                                </a>
                                <a href="<%= contextPath %>/admin/BitacoraServlet" class="btn btn-sm btn-access-secondary btn-rounded-custom">
                                    <i class="bi bi-journal-text me-1"></i> Ver Bitácora de Logs
                                </a>
                            </div>
                        </div>
                    </div>
                <% } else { %>
                    <!-- ACCESOS DEL ESTUDIANTE -->
                    <div class="col-md-6">
                        <div class="card p-4 h-100 access-card">
                            <h3 class="fs-4 mb-3"><i class="bi bi-pencil-square me-2"></i> Interacción y Contribución</h3>
                            <p class="text-secondary">Envía contenido para que sea revisado y potencialmente publicado por el administrador.</p>
                            <div class="mt-auto pt-3 d-grid gap-2">
                                <a href="<%= contextPath %>/estudiante/InteraccionServlet" class="btn btn-sm btn-access btn-rounded-custom">
                                    <i class="bi bi-upload me-1"></i> Enviar Contenido
                                </a>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                         <div class="card p-4 h-100 access-card">
                            <h3 class="fs-4 mb-3"><i class="bi bi-eye me-2"></i> Revisar Mis Envíos</h3>
                            <p class="text-secondary">Consulta el estado actual de tus envíos (aprobados, pendientes, rechazados).</p>
                            <div class="mt-auto pt-3 d-grid gap-2">
                                <a href="<%= contextPath %>/estudiante/MisDatosServlet" class="btn btn-sm btn-access-secondary btn-rounded-custom">
                                    <i class="bi bi-list-check me-1"></i> Consultar Mis Datos
                                </a>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>
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