package Control;

import Datos.Usuario;
import Datos.UsuarioDAO;
import Datos.BitacoraDAO; // Importar el DAO de Bitacora
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet que maneja el inicio de sesión de los usuarios.
 */
@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private UsuarioDAO usuarioDAO;
    private BitacoraDAO bitacoraDAO; // Declarar el DAO de Bitacora

    @Override
    public void init() throws ServletException {
        // Inicializa los DAOs
        this.usuarioDAO = new UsuarioDAO();
        this.bitacoraDAO = new BitacoraDAO(); // Inicializar
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Obtener parámetros
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        // 2. Intentar autenticar el usuario
        Usuario usuarioAutenticado = usuarioDAO.autenticarUsuario(email, password);

        if (usuarioAutenticado != null) {
            // --- LOGIN EXITOSO ---
            
            // 3. Crear o obtener la sesión
            HttpSession session = request.getSession(true);
            
            // 4. Guardar información del usuario en la sesión
            session.setAttribute("user_id", usuarioAutenticado.getId());
            session.setAttribute("user_email", usuarioAutenticado.getEmail());
            session.setAttribute("user_role", usuarioAutenticado.getRol());
            session.setAttribute("user_nombre", usuarioAutenticado.getNombre());
            
            // 5. REGISTRO EN BITÁCORA: Inicio de sesión exitoso
            bitacoraDAO.registrarAccion(usuarioAutenticado.getId(), 
                                       "Inicio de sesión exitoso. Rol: " + usuarioAutenticado.getRol());

            // 6. Redirigir
            response.sendRedirect(request.getContextPath() + "/index.jsp");

        } else {
            // --- LOGIN FALLIDO ---
            
            String mensajeError;
            Usuario usuarioExistente = usuarioDAO.buscarPorEmail(email);
            Integer userId = (usuarioExistente != null) ? usuarioExistente.getId() : null;

            if (usuarioExistente != null) {
                if ("bloqueado".equals(usuarioExistente.getEstado())) {
                     mensajeError = "Tu cuenta ha sido bloqueada. Contacta al administrador.";
                } else {
                     mensajeError = "Credenciales incorrectas.";
                }
            } else {
                mensajeError = "Usuario no encontrado.";
            }

            // 6. REGISTRO EN BITÁCORA: Inicio de sesión fallido
            String accion = "Intento de inicio de sesión fallido para el email: " + email + ". Razón: " + mensajeError;
            bitacoraDAO.registrarAccion(userId, accion); // Si el usuario no existe, userId será null
            
            // 7. Guardar el mensaje de error para mostrarlo en login.jsp
            request.getSession().setAttribute("message", mensajeError);
            request.getSession().setAttribute("status", "error");
            
            // 8. Redirigir de vuelta al formulario de login
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
    }
}