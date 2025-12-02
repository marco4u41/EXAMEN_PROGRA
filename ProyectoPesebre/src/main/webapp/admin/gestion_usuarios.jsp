<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Datos.Usuario" %>
<%@ page import="java.util.List" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.nio.charset.StandardCharsets" %>

<%
    // 1. Verificar Sesión y Rol (Seguridad)
    String userRole = (String) session.getAttribute("user_role");
    
    // 2. OBTENER DATOS: Si la lista de usuarios no está en el request, forzamos la redirección.
    if (request.getAttribute("usuarios") == null) {
        response.sendRedirect(request.getContextPath() + "/GestionUsuarioServlet");
        return;
    }
    
    if (userRole == null || !"administrador".equals(userRole)) {
        session.setAttribute("message", "Acceso denegado. Solo administradores pueden ver esta página.");
        session.setAttribute("status", "error");
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    
    // 3. Obtener la lista de usuarios del request (el Servlet ya la colocó aquí)
    @SuppressWarnings("unchecked")
    List<Usuario> listaUsuarios = (List<Usuario>) request.getAttribute("usuarios");

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
    <title>Gestión de Usuarios - Admin</title>
    
    <!-- Carga de Bootstrap CSS y JS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- FIX CRÍTICO: Usamos ruta absoluta para CSS para evitar fallos de resolución -->
    <link rel="stylesheet" href="<%= contextPath %>/css/style.css">
    
    <!-- Asegura el uso de íconos de Bootstrap -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <style>
        /* Estilos específicos para esta página */
        body { 
            background-color: var(--color-crema); 
        } 
        .admin-title {
            font-family: var(--font-coquette); 
            color: var(--color-pino);
            font-size: 2.5rem;
        }
        /* Estilo de la tabla de administración */
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
        /* Botones de acción en la tabla */
        .btn-status-toggle {
            font-weight: bold;
            border-radius: 50px !important;
            padding: 4px 12px;
            font-size: 0.85rem;
        }
        .status-badge-activo {
            background-color: #D4EDDA; 
            color: #155724; 
        }
        .status-badge-bloqueado {
            background-color: #F8D7DA; 
            color: #721C24; 
        }
    </style>
</head>
<body class="d-flex flex-column min-vh-100">
    
    <!-- HEADER (COPIA DE INDEX.JSP) -->
    <header class="header-moderno fixed-top shadow-lg">
        <nav class="navbar navbar-expand-lg container-xxl p-3">
            <!-- Logo -->
            <a class="navbar-brand fw-bold" href="<%= contextPath %>/index.jsp">
                <!-- FIX: Ruta absoluta para el logo -->
                <img src="<%= contextPath %>/multimedia/images/logo.png" alt="Logo Natividad" class="logo-img" onerror="this.onerror=null; this.src='<%= contextPath %>/multimedia/images/logo.png'"> La Natividad
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
                                    <a href="<%= contextPath %>/GestionUsuarioServlet" class="dropdown-item active">Gestión de Usuarios</a>
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
    <!-- Se añade pt-5 (padding superior) para empujar el contenido debajo del header fijo -->
    <main class="flex-grow-1 container pt-5 py-4">
        <!-- El mt-5 aquí empujará el contenido hacia abajo de forma robusta -->
        <div class="bg-white p-5 rounded-4 shadow-lg w-100 mt-5" style="border-top: 5px solid var(--color-pino);">
            <h1 class="admin-title mb-2" style="color: var(--color-rojo-oscuro);">Gestión de Usuarios</h1>
            <p class="text-secondary mb-4" style="color: var(--color-texto-oscuro);">Administra las cuentas de usuario y sus estados.</p>
            
            <!-- Mensajes de estado -->
            <% 
                String message = (String) session.getAttribute("message");
                if (message != null) {
                    String status = (String) session.getAttribute("status");
            %>
                <div class="alert alert-<%= "success".equals(status) ? "success" : "danger" %> fade show" role="alert">
                    <%= message %>
                    <% session.removeAttribute("message");
                       session.removeAttribute("status"); %>
                </div>
            <% } %>
            
            <div class="d-flex justify-content-between align-items-center mb-4">
                <a href="<%= contextPath %>/perfil.jsp" class="text-decoration-none fw-bold" style="color: var(--color-pino);">&larr; Volver al Perfil</a>
            </div>

            <div class="table-responsive">
                <table class="table table-hover admin-table">
                    <thead>
                        <tr class="text-uppercase small">
                            <th scope="col" class="py-3 px-3">ID</th>
                            <th scope="col" class="py-3 px-3">Nombre</th>
                            <th scope="col" class="py-3 px-3">Email</th>
                            <th scope="col" class="py-3 px-3 text-center">Rol</th>
                            <th scope="col" class="py-3 px-3 text-center">Estado</th>
                            <th scope="col" class="py-3 px-3 text-center">Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (listaUsuarios != null && !listaUsuarios.isEmpty()) { 
                            for (Usuario u : listaUsuarios) {
                                String estadoClass = "status-badge-activo";
                                String accionTexto = "Bloquear";
                                String accionClase = "btn-danger";
                                String proximoEstado = "bloqueado";

                                if ("bloqueado".equals(u.getEstado())) {
                                    estadoClass = "status-badge-bloqueado";
                                    accionTexto = "Activar";
                                    accionClase = "btn-success";
                                    proximoEstado = "activo";
                                }
                                // Evitar que el administrador se bloquee a sí mismo
                                boolean self = (int)session.getAttribute("user_id") == u.getId();
                        %>
                        <tr data-user-id="<%= u.getId() %>" data-user-nombre="<%= u.getNombre() %>" data-user-email="<%= u.getEmail() %>" data-user-rol="<%= u.getRol() %>">
                            <td class="py-3 px-3"><%= u.getId() %></td>
                            <td class="py-3 px-3"><%= u.getNombre() %></td>
                            <td class="py-3 px-3"><%= u.getEmail() %></td>
                            <td class="py-3 px-3 text-center"><%= u.getRol().toUpperCase() %></td>
                            <td class="py-3 px-3 text-center">
                                <span class="badge rounded-pill <%= estadoClass %>">
                                    <%= u.getEstado().toUpperCase() %>
                                </span>
                            </td>
                            <td class="py-3 px-3 text-center d-flex justify-content-center align-items-center gap-2">
                                
                                <button type="button" class="btn btn-status-toggle btn-sm btn-plata" data-bs-toggle="modal" data-bs-target="#editUserModal" 
                                        onclick="fillEditModal(<%= u.getId() %>, '<%= u.getNombre() %>', '<%= u.getEmail() %>', '<%= u.getRol() %>')">
                                    <i class="bi bi-pencil"></i> Editar
                                </button>
                                
                                <% if (self) { %>
                                    <span class="text-secondary small">Cuenta Propia</span>
                                <% } else { %>
                                    <!-- Formulario para la acción de bloqueo/activación -->
                                    <form action="<%= contextPath %>/GestionUsuarioServlet" method="POST" class="d-inline">
                                        <input type="hidden" name="action" value="updateStatus">
                                        <input type="hidden" name="userId" value="<%= u.getId() %>">
                                        <input type="hidden" name="newStatus" value="<%= proximoEstado %>">
                                        <button type="submit" class="btn btn-status-toggle <%= accionClase %>" onclick="return confirm('¿Estás seguro de cambiar el estado de <%= u.getNombre() %> a <%= proximoEstado %>?');">
                                            <%= accionTexto %>
                                        </button>
                                    </form>
                                <% } %>
                            </td>
                        </tr>
                        <% } 
                        } else { %>
                        <tr>
                            <td colspan="6" class="py-4 text-center text-secondary">No hay usuarios registrados.</td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
    <!-- FIN DEL CONTENIDO PRINCIPAL -->


    <!-- MODAL DE EDICIÓN DE USUARIO -->
    <div class="modal fade" id="editUserModal" tabindex="-1" aria-labelledby="editUserModalLabel" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header" style="background-color: var(--color-pino); color: white;">
            <h5 class="modal-title" id="editUserModalLabel" style="font-family: var(--font-coquette);">Editar Usuario</h5>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <form action="<%= contextPath %>/GestionUsuarioServlet" method="POST">
              <input type="hidden" name="action" value="editUser">
              <input type="hidden" name="userId" id="editUserId">
              
              <div class="modal-body">
                <div class="mb-3">
                  <label for="editNombre" class="form-label">Nombre</label>
                  <input type="text" class="form-control rounded-pill" id="editNombre" name="nombre" required>
                </div>
                <div class="mb-3">
                  <label for="editEmail" class="form-label">Email</label>
                  <input type="email" class="form-control rounded-pill" id="editEmail" name="email" required>
                </div>
                <div class="mb-3">
                  <label for="editRol" class="form-label">Rol</label>
                  <select class="form-select rounded-pill" id="editRol" name="rol" required>
                    <option value="estudiante">Estudiante</option>
                    <option value="administrador">Administrador</option>
                  </select>
                </div>
              </div>
              
              <div class="modal-footer">
                <button type="button" class="btn btn-secondary btn-rounded-custom" data-bs-dismiss="modal">Cancelar</button>
                <button type="submit" class="btn btn-register btn-rounded-custom">Guardar Cambios</button>
              </div>
          </form>
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
        
        // Función para llenar la modal de edición
        function fillEditModal(id, nombre, email, rol) {
            document.getElementById('editUserId').value = id;
            document.getElementById('editNombre').value = nombre;
            document.getElementById('editEmail').value = email;
            document.getElementById('editRol').value = rol;
        }
        
        // Función para reemplazar alert/confirm (usada en el botón de bloqueo)
        // Ya que alert/confirm no funcionan bien en iframes.
        window.confirm = function(message) {
            return prompt(message + " (Escribe 'si' para confirmar, o cualquier otra cosa para cancelar):") === 'si';
        };
    </script>
</body>
</html>