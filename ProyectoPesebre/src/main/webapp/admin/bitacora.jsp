<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Datos.Bitacora" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    // 1. Verificar Sesión y Rol: Solo Administradores pueden acceder.
    String userRole = (String) session.getAttribute("user_role");
    if (userRole == null || !"administrador".equals(userRole)) {
        session.setAttribute("message", "Acceso denegado. Solo administradores pueden ver esta página.");
        session.setAttribute("status", "error");
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    
    // 2. Obtener la lista de logs del request (colocada por BitacoraServlet)
    @SuppressWarnings("unchecked") // Para evitar warning de tipo
    List<Bitacora> listaLogs = (List<Bitacora>) request.getAttribute("logs");
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");

    String contextPath = request.getContextPath();
    
    // Lógica de sesión (necesaria para el header)
    String userName = (String) session.getAttribute("user_nombre");
    boolean loggedIn = userRole != null;
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bitácora del Sistema - Admin</title>
    
    <!-- Carga de Bootstrap CSS y JS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Enlace al archivo CSS externo -->
    <link rel="stylesheet" href="../css/style.css">
    
    <!-- Asegura el uso de íconos de Bootstrap -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <style>
        /* Estilos específicos para esta página */
        body { 
            background-color: var(--color-crema); 
            /* Quitamos el padding-top del body, lo manejamos en el main */
        } 
        .admin-title {
            font-family: var(--font-coquette); 
            color: var(--color-pino);
            font-size: 2.5rem;
        }
        /* Estilo de la tabla de bitácora */
        .admin-table thead th {
            background-color: var(--color-pino);
            color: white;
            border-bottom: 2px solid var(--color-oro);
        }
        .admin-table tbody tr {
            transition: background-color 0.2s ease;
        }
        .admin-table tbody tr:hover {
            background-color: var(--color-plata);
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
                                    <a href="<%= contextPath %>/admin/BitacoraServlet" class="dropdown-item active">Ver Bitácora</a>
                                    <div class="dropdown-divider"></div>
                                    <a href="<%= contextPath %>/LogoutServlet" class="dropdown-item text-danger">Cerrar Sesión</a>
                                </div>
                            </div>
                        <% } else if (loggedIn) { %>
                            <a href="<%= contextPath %>/perfil.jsp" class="btn btn-register btn-sm fw-bold shadow btn-rounded-custom">
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
        <div class="bg-white p-5 rounded-4 shadow-lg w-100 mt-5" style="border-top: 5px solid var(--color-pino);">
            <h1 class="admin-title mb-2" style="color: var(--color-rojo-oscuro);">Bitácora de Eventos</h1>
            <p class="text-secondary mb-4" style="color: var(--color-texto-oscuro);">Registro cronológico de las acciones importantes del sistema.</p>
            
            <div class="d-flex justify-content-between align-items-center mb-4">
                <a href="<%= contextPath %>/perfil.jsp" class="text-decoration-none fw-bold" style="color: var(--color-pino);">&larr; Volver al Perfil</a>
            </div>

            <div class="table-responsive">
                <table class="table table-hover admin-table">
                    <thead>
                        <tr class="text-uppercase small">
                            <th scope="col" class="py-3 px-3">ID Log</th>
                            <th scope="col" class="py-3 px-3">Fecha y Hora</th>
                            <th scope="col" class="py-3 px-3">Usuario ID</th>
                            <th scope="col" class="py-3 px-3">Acción Detallada</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (listaLogs != null && !listaLogs.isEmpty()) { 
                            for (Bitacora log : listaLogs) { %>
                        <tr>
                            <td class="py-3 px-3"><%= log.getId() %></td>
                            <td class="py-3 px-3"><%= sdf.format(log.getFecha()) %></td>
                            <td class="py-3 px-3"><%= log.getUsuarioId() != null ? log.getUsuarioId() : "N/A (Sistema/Invitado)" %></td>
                            <td class="py-3 px-3"><%= log.getAccion() %></td>
                        </tr>
                        <% } 
                        } else { %>
                        <tr>
                            <td colspan="4" class="py-4 text-center text-secondary">No hay registros en la bitácora.</td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
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