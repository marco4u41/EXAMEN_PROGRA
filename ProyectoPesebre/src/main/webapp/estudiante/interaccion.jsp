<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 1. Verificar sesión y rol
    String contextPath = request.getContextPath();
    String userRole = (String) session.getAttribute("user_role");
    if (session.getAttribute("user_id") == null || !"estudiante".equals(userRole)) {
        session.setAttribute("message", "Acceso denegado. Debes ser estudiante.");
        session.setAttribute("status", "error");
        response.sendRedirect(contextPath + "/login.jsp");
        return;
    }

    // Mensajes de sesión
    String message = (String) session.getAttribute("message");
    String status = (String) session.getAttribute("status");
    if (message != null) {
        session.removeAttribute("message");
        session.removeAttribute("status");
    }

    // Lógica de sesión (necesaria para el header)
    String userName = (String) session.getAttribute("user_nombre");
    boolean loggedIn = userRole != null;
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Enviar Contenido - Estudiante</title>
    
    <!-- Carga de Bootstrap CSS y JS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Enlace al archivo CSS externo -->
    <link rel="stylesheet" href="../css/style.css">
    
    <!-- Asegura el uso de íconos de Bootstrap -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <style>
        body { 
            background-color: var(--color-crema); 
            padding-top: 80px; 
        } 
        .content-title {
            font-family: var(--font-coquette); 
            color: var(--color-pino);
            font-size: 2.5rem;
        }
    </style>
</head>
<body class="d-flex flex-column min-vh-100">

    <!-- HEADER (COPIA DE INDEX.JSP) -->
    <header class="header-moderno fixed-top shadow-lg">
        <nav class="navbar navbar-expand-lg container-xxl p-3">
            <!-- Logo -->
            <a class="navbar-brand fw-bold" href="<%= contextPath %>/index.jsp">
                <img src="<%= contextPath %>/multimedia/images/logo.png" alt="Logo Natividad" class="logo-img" onerror="this.onerror=null; this.src='../multimedia/images/logo.png'"> La Natividad
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
                                <a href="<%= contextPath %>/perfil.jsp" class="btn btn-register btn-sm fw-bold shadow btn-rounded-custom active-link">
                                    <%= userName %>
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

    <!-- CONTENIDO PRINCIPAL -->
    <main class="flex-grow-1 container pt-5 py-4">
        <!-- Tarjeta Central de Contenido -->
        <div class="bg-white p-5 rounded-4 shadow-lg w-100 mt-5" style="max-width: 800px; margin-left: auto; margin-right: auto; border-top: 5px solid var(--color-rojo-oscuro);">
            <h1 class="mb-2 content-title" style="color: var(--color-pino);">Zona de Interacción</h1>
            <p class="text-xl text-secondary mb-4" style="color: var(--color-texto-oscuro);">Envía tu reflexión o aporte para que sea revisado por el equipo administrativo.</p>
            
            <a href="<%= contextPath %>/perfil.jsp" class="inline-block mb-4 text-decoration-none fw-bold" style="color: var(--color-rojo-oscuro);">&larr; Volver a Mi Perfil</a>

            <!-- Mensajes de estado -->
            <% if (message != null) { %>
                <div class="alert alert-<%= "success".equals(status) ? "success" : "danger" %> fade show" role="alert">
                    <%= message %>
                </div>
            <% } %>

            <!-- Formulario de Envío -->
            <form action="<%= contextPath %>/estudiante/InteraccionServlet" method="POST" class="mt-4">
                <div class="mb-3">
                    <label for="titulo" class="form-label fw-semibold">Título de tu Contenido</label>
                    <input type="text" name="titulo" id="titulo" required class="form-control rounded-pill" placeholder="Ej: Mi Reflexión sobre la Paz Navideña">
                </div>
                
                <div class="mb-4">
                    <label for="contenido" class="form-label fw-semibold">Contenido (Máximo 500 palabras)</label>
                    <textarea name="contenido" id="contenido" rows="8" required class="form-control rounded-4" placeholder="Escribe aquí tu texto..."></textarea>
                </div>
                
                <button type="submit" class="btn btn-register btn-lg fw-bold btn-rounded-custom">
                    Enviar para Revisión <i class="bi bi-upload"></i>
                </button>
            </form>

            <div class="mt-5 pt-3 border-top">
                <h3 class="fs-4 fw-bold" style="color: var(--color-pino);">Revisa tus Envíos Anteriores</h3>
                <p class="text-secondary">Consulta el estado actual de tus contribuciones.</p>
                <a href="<%= contextPath %>/estudiante/MisDatosServlet" class="btn btn-sm btn-plata fw-bold btn-rounded-custom mt-2">
                    Ir a Consultar Mis Datos &rarr;
                </a>
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