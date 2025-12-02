<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Datos.InteraccionEstudiante" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    // 1. Verificar Sesión y Rol
    String userRole = (String) session.getAttribute("user_role");
    String contextPath = request.getContextPath();

    if (userRole == null || !"administrador".equals(userRole)) {
        response.sendRedirect(contextPath + "/index.jsp");
        return;
    }
    
    // 2. Obtener la lista de envíos del request
    @SuppressWarnings("unchecked")
    List<InteraccionEstudiante> listaEnvios = (List<InteraccionEstudiante>) request.getAttribute("envios");
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");

    // Lógica de sesión (necesaria para el header)
    String userName = (String) session.getAttribute("user_nombre");
    boolean loggedIn = userRole != null;
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Auditoría de Envíos - Admin</title>
    
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
        .admin-title {
            font-family: var(--font-coquette); 
            color: var(--color-pino);
            font-size: 2.5rem;
        }
        .admin-table thead th {
            background-color: var(--color-pino);
            color: white;
            border-bottom: 2px solid var(--color-oro);
        }
        .admin-table tbody tr:nth-child(even) {
            background-color: #f7f7f7;
        }
        .admin-table tbody tr {
            transition: background-color 0.2s ease;
        }
        .admin-table tbody tr:hover {
            background-color: var(--color-plata);
        }
        .content-preview {
            max-width: 300px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            font-style: italic;
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
                                <button onclick="toggleDropdown('admin-menu')" class="btn btn-register btn-sm text-uppercase fw-bold shadow btn-rounded-custom active-link">
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
    <main class="flex-grow-1 container pt-5 py-4">
        <!-- Tarjeta de Contenido -->
        <div class="bg-white p-5 rounded-4 shadow-lg w-100 mt-5" style="border-top: 5px solid var(--color-pino);">
            <h1 class="admin-title mb-2" style="color: var(--color-rojo-oscuro);">Auditoría de Envíos de Estudiantes</h1>
            <p class="text-secondary mb-4" style="color: var(--color-texto-oscuro);">Lista de todo el contenido enviado por los estudiantes (para auditoría).</p>
            
            <div class="d-flex justify-content-between align-items-center mb-4">
                <a href="<%= contextPath %>/perfil.jsp" class="text-decoration-none fw-bold" style="color: var(--color-pino);">&larr; Volver al Perfil</a>
            </div>

            <div class="table-responsive">
                <table class="table table-hover admin-table">
                    <thead>
                        <tr class="text-uppercase small">
                            <th scope="col" class="py-3 px-3">ID</th>
                            <th scope="col" class="py-3 px-3">Título</th>
                            <th scope="col" class="py-3 px-3">Estudiante</th>
                            <th scope="col" class="py-3 px-3">Fecha de Envío</th>
                            <th scope="col" class="py-3 px-3">Contenido (Preview)</th>
                            <th scope="col" class="py-3 px-3 text-center">Acción</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (listaEnvios != null && !listaEnvios.isEmpty()) { 
                            for (InteraccionEstudiante envio : listaEnvios) { %>
                        <tr>
                            <td class="py-3 px-3 small"><%= envio.getId() %></td>
                            <td class="py-3 px-3"><%= envio.getTitulo() %></td>
                            <td class="py-3 px-3 small"><%= envio.getNombreUsuario() %></td>
                            <td class="py-3 px-3 small"><%= sdf.format(envio.getFechaEnvio()) %></td>
                            <td class="py-3 px-3">
                                <div class="content-preview text-secondary">
                                    <%= envio.getContenidoEstudiante() %>
                                </div>
                            </td>
                            <td class="py-3 px-3 d-flex justify-content-center">
                                <button type="button" class="btn btn-sm btn-info btn-rounded-custom" data-bs-toggle="modal" data-bs-target="#viewContentModal" onclick="viewContent('<%= envio.getTitulo() %>', `<%= envio.getContenidoEstudiante().replace("\n", "\\n").replace("`", "\\`") %>`, '<%= envio.getNombreUsuario() %>')">
                                    <i class="bi bi-eye"></i> Ver Completo
                                </button>
                            </td>
                        </tr>
                        <% } 
                        } else { %>
                        <tr>
                            <td colspan="6" class="py-4 text-center text-secondary">No hay envíos de contenido para revisión.</td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
    <!-- FIN DEL CONTENIDO PRINCIPAL -->

    <!-- MODAL DE VISUALIZACIÓN DE CONTENIDO -->
    <div class="modal fade" id="viewContentModal" tabindex="-1" aria-labelledby="viewContentModalLabel" aria-hidden="true">
      <div class="modal-dialog modal-lg">
        <div class="modal-content">
          <div class="modal-header" style="background-color: var(--color-pino); color: white;">
            <h5 class="modal-title" id="viewContentModalLabel" style="font-family: var(--font-coquette);">Revisión de Envío</h5>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            <h4 id="contentTitle" class="fw-bold mb-1" style="color: var(--color-rojo-oscuro);"></h4>
            <p class="small text-secondary mb-3">Enviado por: <span id="contentAuthor" class="fw-semibold"></span></p>
            <hr>
            <pre id="contentText" class="p-3 border rounded" style="white-space: pre-wrap; font-family: var(--bs-font-sans-serif); color: var(--color-texto-oscuro);"></pre>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary btn-rounded-custom" data-bs-dismiss="modal">Cerrar</button>
          </div>
        </div>
      </div>
    </div>
    <!-- FIN MODAL -->


    <!-- FOOTER (COPIA DE INDEX.JSP) -->
    <footer class="text-white p-4 text-center mt-auto" style="background-color: var(--color-pino);">
        <p class="mb-0">&copy; 2024 Proyecto Natividad Interactiva. Proyecto JSP/PostgreSQL.</p>
    </footer>
    <!-- FIN DEL FOOTER -->

    <!-- JavaScript para la funcionalidad del menú y modal -->
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
        
        // Función para visualizar el contenido del envío en la modal
        function viewContent(title, content, author) {
            document.getElementById('contentTitle').textContent = title;
            document.getElementById('contentAuthor').textContent = author;
            // Usamos template literal para manejar los saltos de línea y el escape
            document.getElementById('contentText').textContent = content.replace(/\\n/g, '\n');
        }
    </script>
</body>
</html>