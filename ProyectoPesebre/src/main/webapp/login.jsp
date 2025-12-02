<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Iniciar Sesión</title>
    
    <!-- Carga de Bootstrap CSS y JS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Enlace al archivo CSS externo -->
    <link rel="stylesheet" href="css/style.css">
    
    <!-- Asegura el uso de íconos de Bootstrap -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <style>
        /* Estilos específicos de esta página */
        body { 
            background-color: var(--color-crema); /* Fondo suave */
            padding-top: 80px; /* Espacio para el header fijo */
        } 
        .login-title {
            font-family: var(--font-coquette);
            color: var(--color-pino);
            font-size: 2.5rem;
        }
    </style>
</head>
<body class="d-flex flex-column min-vh-100">
    <% 
        String contextPath = request.getContextPath(); 
        String sessionMessage = (String) session.getAttribute("message");
        String sessionStatus = (String) session.getAttribute("status");
        
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
                            <a href="<%= contextPath %>/login.jsp" class="btn btn-register btn-sm text-uppercase fw-bold shadow btn-rounded-custom active-link">
                                Iniciar Sesión
                            </a>
                        <% } %>
                    </li>
                </ul>
            </div>
        </nav>
    </header>
    <!-- FIN DEL HEADER -->

    <!-- CONTENIDO PRINCIPAL (FORMULARIO) -->
    <main class="flex-grow-1 d-flex align-items-center justify-content-center">
        <div class="bg-white p-5 rounded-4 shadow-lg w-100 mt-5" style="max-width: 450px; border-top: 5px solid var(--color-rojo-oscuro);">
            <h1 class="login-title mb-4 text-center fw-bold">Acceso al Sistema</h1>
            <p class="text-center text-secondary mb-4">Ingresa tus credenciales.</p>
            
            <!-- Mensajes de error/éxito de Servlet (si existen) -->
            <% if (sessionMessage != null) { %>
                <div class="alert alert-<%= "success".equals(sessionStatus) ? "success" : "danger" %> fade show" role="alert">
                    <%= sessionMessage %>
                    <% session.removeAttribute("message");
                       session.removeAttribute("status"); %>
                </div>
            <% } %>

            <!-- Formulario que envía datos al Servlet de Login -->
            <form action="<%= contextPath %>/LoginServlet" method="POST">
                <div class="mb-3">
                    <label for="email" class="form-label fw-semibold">Correo Electrónico Válido</label>
                    <input type="email" name="email" id="email" required class="form-control rounded-pill" placeholder="ejemplo@correo.com">
                </div>
                <div class="mb-4">
                    <label for="password" class="form-label fw-semibold">Contraseña</label>
                    <input type="password" name="password" id="password" required class="form-control rounded-pill" placeholder="••••••••">
                </div>
                
                <button type="submit" class="btn btn-register btn-lg w-100 fw-bold btn-rounded-custom">
                    Acceder
                </button>
            </form>

            <p class="mt-4 text-center">
                <a href="registro.jsp" class="text-decoration-none fw-semibold" style="color: var(--color-pino);">
                    ¿No tienes cuenta? Regístrate aquí.
                </a>
            </p>
            <p class="mt-2 text-center text-sm">
                <a href="index.jsp" class="text-secondary text-decoration-none">
                    Volver a la página principal
                </a>
            </p>
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