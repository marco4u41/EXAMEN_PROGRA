package Control;

import Datos.Usuario;
import Datos.UsuarioDAO;
import Datos.BitacoraDAO;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet para la gestión de usuarios por parte del Administrador.
 */
@WebServlet("/GestionUsuarioServlet")
public class GestionUsuarioServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private UsuarioDAO usuarioDAO;
    private BitacoraDAO bitacoraDAO;

    @Override
    public void init() throws ServletException {
        this.usuarioDAO = new UsuarioDAO();
        this.bitacoraDAO = new BitacoraDAO();
    }
    
    // --- MANEJO DE PETICIÓN GET (Consultar todos los usuarios) ---
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Verificar el rol de administrador
        String userRole = (String) request.getSession().getAttribute("user_role");
        if (userRole == null || !"administrador".equals(userRole)) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }
        
        // 2. Obtener la lista de usuarios desde el DAO
        List<Usuario> usuarios = usuarioDAO.consultarTodosUsuarios();
        
        // 3. Pasar la lista a la vista (gestion_usuarios.jsp)
        request.setAttribute("usuarios", usuarios);
        
        // 4. Redirigir la petición al JSP para que muestre los datos
        request.getRequestDispatcher("/admin/gestion_usuarios.jsp").forward(request, response);
    }

    // --- MANEJO DE PETICIÓN POST (Actualizar estado: Bloquear/Activar y Editar) ---
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Verificar el rol de administrador
        String userRole = (String) request.getSession().getAttribute("user_role");
        Integer adminId = (Integer) request.getSession().getAttribute("user_id");
        if (userRole == null || !"administrador".equals(userRole)) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        String userIdStr = request.getParameter("userId");
        
        if (userIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/GestionUsuarioServlet");
            return;
        }

        try {
            int userId = Integer.parseInt(userIdStr);
            boolean success = false;
            String message = "";
            String status = "error";

            // --- A. GESTIONAR CAMBIO DE ESTADO (BLOQUEAR/ACTIVAR) ---
            if ("updateStatus".equals(action)) {
                String newStatus = request.getParameter("newStatus");
                success = usuarioDAO.actualizarEstado(userId, newStatus);
                
                if (success) {
                    message = "Estado del usuario ID " + userId + " actualizado a " + newStatus + ".";
                    status = "success";
                    bitacoraDAO.registrarAccion(adminId, "Admin cambió el estado del usuario ID " + userId + " a " + newStatus);
                } else {
                    message = "Error al actualizar el estado del usuario ID " + userId + ".";
                }
            } 
            
            // --- B. GESTIONAR EDICIÓN DE INFORMACIÓN ---
            else if ("editUser".equals(action)) {
                String nombre = request.getParameter("nombre");
                String email = request.getParameter("email");
                String rol = request.getParameter("rol");

                // Validación básica
                if (nombre != null && !nombre.isEmpty() && email != null && !email.isEmpty() && rol != null) {
                    success = usuarioDAO.actualizarUsuario(userId, nombre, email, rol);
                    if (success) {
                        message = "Información del usuario ID " + userId + " actualizada exitosamente.";
                        status = "success";
                        bitacoraDAO.registrarAccion(adminId, "Admin editó la información del usuario ID " + userId);
                    } else {
                        message = "Error: El email ya existe o hubo un fallo en la DB.";
                    }
                } else {
                    message = "Error: Nombre, Email y Rol son obligatorios para la edición.";
                }
            }

            request.getSession().setAttribute("message", message);
            request.getSession().setAttribute("status", status);
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("message", "Error: ID de usuario inválido.");
            request.getSession().setAttribute("status", "error");
        }
        
        // 3. Redirigir al Servlet GET para que recargue la lista
        response.sendRedirect(request.getContextPath() + "/GestionUsuarioServlet");
    }
}