<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registro de Nuevo Usuario</title>
    
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
        String message = (String) request.getAttribute("message");
        String status = (String) request.getAttribute("status");
        
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
            <h1 class="login-title mb-4 text-center fw-bold">Registro de Nuevo Usuario</h1>
            <p class="text-center text-secondary mb-4">La clave debe ser de mínimo 8 caracteres y ser segura.</p>
            
            <!-- Mensajes de error/éxito de Servlet (si existen) -->
            <% if (message != null) { %>
                <div class="alert alert-<%= "success".equals(status) ? "success" : "danger" %> fade show" role="alert">
                    <%= message %>
                </div>
            <% } %>

            <!-- Formulario que envía datos al Servlet -->
            <form id="registrationForm" action="<%= contextPath %>/RegistroServlet" method="POST" onsubmit="return validateForm()">
                <div class="mb-3">
                    <label for="nombre" class="form-label fw-semibold">Nombre Completo</label>
                    <!-- Añadimos required para asegurar que no esté vacío -->
                    <input type="text" name="nombre" id="nombre" required class="form-control rounded-pill" placeholder="Tu Nombre">
                </div>
                <div class="mb-3">
                    <label for="email" class="form-label fw-semibold">Correo Electrónico Válido</label>
                    <!-- El tipo email y required se encargan de la validación básica de email y campo vacío -->
                    <input type="email" name="email" id="email" required class="form-control rounded-pill" placeholder="ejemplo@correo.com">
                </div>
                <div class="mb-4">
                    <label for="password" class="form-label fw-semibold">Contraseña</label>
                    <!-- minlength="8" es una validación básica de HTML5 -->
                    <input type="password" name="password" id="password" required minlength="8" class="form-control rounded-pill" placeholder="••••••••" onkeyup="checkPasswordStrength()">
                    <div id="passwordHelp" class="form-text mt-2">
                        Debe tener 8+ caracteres, 1 Mayúscula y 1 número.
                    </div>
                </div>
                
                <button type="submit" class="btn btn-register btn-lg w-100 fw-bold btn-rounded-custom">
                    Registrarse
                </button>
            </form>

            <p class="mt-4 text-center">
                <a href="login.jsp" class="text-decoration-none fw-semibold" style="color: var(--color-pino);">
                    &larr; Volver a Iniciar Sesión
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
    
    <!-- JavaScript para la funcionalidad del menú y validación de formulario -->
    <script>
        // Función para la validación de fortaleza de contraseña (Lado del cliente)
        function checkPasswordStrength() {
            const passwordInput = document.getElementById('password');
            const passwordHelp = document.getElementById('passwordHelp');
            const password = passwordInput.value;

            // Requisitos de seguridad (mín. 8 caracteres, 1 mayúscula, 1 número)
            const minLength = 8;
            const hasUpperCase = /[A-Z]/.test(password);
            const hasNumber = /[0-9]/.test(password);
            const isLongEnough = password.length >= minLength;

            let feedback = '';
            let isValid = true;
            
            if (!isLongEnough) {
                feedback += '• Mínimo 8 caracteres. ';
                isValid = false;
            }
            if (!hasUpperCase) {
                feedback += '• Falta 1 mayúscula. ';
                isValid = false;
            }
            if (!hasNumber) {
                feedback += '• Falta 1 número. ';
                isValid = false;
            }
            
            if (isValid && password.length > 0) {
                passwordHelp.innerHTML = '<span class="text-success fw-bold">Contraseña Segura <i class="bi bi-check-circle-fill"></i></span>';
                passwordInput.classList.remove('is-invalid');
                passwordInput.classList.add('is-valid');
            } else if (password.length > 0) {
                passwordHelp.innerHTML = '<span class="text-danger fw-bold">Debes cumplir con: </span>' + feedback;
                passwordInput.classList.add('is-invalid');
                passwordInput.classList.remove('is-valid');
            } else {
                 passwordHelp.innerHTML = 'Debe tener 8+ caracteres, 1 Mayúscula y 1 número.';
                 passwordInput.classList.remove('is-invalid', 'is-valid');
            }

            return isValid;
        }

        // Función de validación final al enviar el formulario (Cliente)
        function validateForm() {
            const isPasswordValid = checkPasswordStrength();
            
            if (!isPasswordValid) {
                 alert("Por favor, corrige la contraseña. Debe incluir 8+ caracteres, 1 mayúscula y 1 número.");
                 return false;
            }
            return true;
        }


        // --- Lógica de Header (Necesaria para el Header copiado) ---
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