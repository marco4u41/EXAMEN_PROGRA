<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Datos.Usuario" %>
<%@ page import="Datos.InteraccionEstudiante" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>

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
    
    // 2. Obtener datos del request
    Usuario usuario = (Usuario) request.getAttribute("usuarioPerfil");
    @SuppressWarnings("unchecked")
    List<InteraccionEstudiante> interacciones = (List<InteraccionEstudiante>) request.getAttribute("interacciones");
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");

    // Lógica de sesión (necesaria para el header)
    String userName = (String) session.getAttribute("user_nombre");
    boolean loggedIn = userRole != null;
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mis Datos - Estudiante</title>
    
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
        .interaction-item {
            background-color: white;
            border: 1px solid var(--color-plata);
            border-radius: 0.5rem;
            transition: box-shadow 0.3s;
        }
        .interaction-item:hover {
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }
        .content-preview {
            background-color: var(--color-plata);
            padding: 0.75rem;
            border-radius: 0.5rem;
            margin-top: 0.5rem;
            font-size: 0.9rem;
            white-space: pre-wrap; /* Mantiene saltos de línea */
            max-height: 100px;
            overflow-y: auto;
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
                                    
                                    <!-- ENLACE CORREGIDO: Apunta al Servlet de Revisión -->
                                    <a href="<%= contextPath %>/admin/RevisionServlet" class="dropdown-item">Auditoría de Envíos</a>
                                    
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
                    </li>
                </ul>
            </div>
        </nav>
    </header>
    <!-- FIN DEL HEADER -->

    <!-- CONTENIDO PRINCIPAL -->
    <main class="flex-grow-1 container pt-5 py-4">
        <!-- Tarjeta Central de Contenido -->
        <div class="bg-white p-5 rounded-4 shadow-lg w-100 mt-5" style="border-top: 5px solid var(--color-rojo-oscuro);">
            <h1 class="profile-title mb-2" style="color: var(--color-pino);">Mis Datos y Aportes</h1>
            <p class="text-xl text-secondary mb-4" style="color: var(--color-texto-oscuro);">Consulta tu información personal y los contenidos que has compartido.</p>
            
            <a href="<%= contextPath %>/perfil.jsp" class="inline-block mb-4 text-decoration-none fw-bold" style="color: var(--color-rojo-oscuro);">&larr; Volver a Mi Perfil</a>

            <!-- Bloque de Información Personal (Verde Pino) -->
            <div class="p-4 info-card mb-5">
                <h2 class="fs-4 fw-bold mb-3" style="color: var(--color-oro);">Información de la Cuenta</h2>
                <% if (usuario != null) { %>
                    <div class="row">
                        <div class="col-md-6 mb-2">
                            <p class="mb-1 fw-semibold">Nombre:</p>
                            <p class="mb-0 small"><%= usuario.getNombre() %></p>
                        </div>
                        <div class="col-md-6 mb-2">
                            <p class="mb-1 fw-semibold">Email:</p>
                            <p class="mb-0 small"><%= usuario.getEmail() %></p>
                        </div>
                        <div class="col-md-6 mb-2">
                            <p class="mb-1 fw-semibold">ID:</p>
                            <p class="mb-0 small"><%= usuario.getId() %></p>
                        </div>
                        <div class="col-md-6 mb-2">
                            <p class="mb-1 fw-semibold">Estado:</p>
                            <p class="mb-0 small">
                                <span class="badge rounded-pill <%= "activo".equals(usuario.getEstado()) ? "bg-success" : "bg-danger" %>">
                                    <%= usuario.getEstado().toUpperCase() %>
                                </span>
                            </p>
                        </div>
                    </div>
                <% } else { %>
                    <p class="text-danger">Error: No se pudo cargar la información del perfil.</p>
                <% } %>
            </div>

            <!-- Historial de Interacciones Enviadas -->
            <div class="mb-3">
                <h3 class="fs-4 fw-bold mb-3" style="color: var(--color-pino);">Historial de Contenido Enviado</h3>
                
                <% if (interacciones != null && !interacciones.isEmpty()) { %>
                    <div class="d-grid gap-3">
                        <% for (InteraccionEstudiante i : interacciones) { %>
                        <div class="interaction-item p-3">
                            <p class="mb-0 fw-semibold" style="color: var(--color-pino);"><%= i.getTitulo() %></p>
                            <p class="mb-0 small text-secondary">Enviado el <%= sdf.format(i.getFechaEnvio()) %></p>
                            <div class="content-preview mt-2">
                                <%= i.getContenidoEstudiante() %>
                            </div>
                        </div>
                        <% } %>
                    </div>
                <% } else { %>
                    <p class="text-secondary">Aún no has enviado ninguna contribución.</p>
                    <a href="<%= contextPath %>/estudiante/InteraccionServlet" class="btn btn-sm btn-register fw-bold btn-rounded-custom mt-2">
                        Enviar mi primera Contribución &rarr;
                    </a>
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