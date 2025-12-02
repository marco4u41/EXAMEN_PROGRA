package Control;

import Datos.BitacoraDAO;
import Datos.InteraccionDAO;
import Datos.InteraccionEstudiante;
import Datos.UsuarioDAO; 
import Datos.Usuario;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet que maneja la interacción del perfil estudiante (envío de contenido).
 */
@WebServlet("/estudiante/InteraccionServlet")
public class InteraccionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private InteraccionDAO interaccionDAO;
    private BitacoraDAO bitacoraDAO;

    @Override
    public void init() throws ServletException {
        this.interaccionDAO = new InteraccionDAO();
        this.bitacoraDAO = new BitacoraDAO(); // Inicializar el DAO de Bitacora
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Verificar sesión y rol
        String userRole = (String) request.getSession().getAttribute("user_role");
        if (userRole == null || !"estudiante".equals(userRole)) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }
        
        // 2. Redirigir al formulario de envío
        request.getRequestDispatcher("/estudiante/interaccion.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Verificar sesión y rol
        String userRole = (String) request.getSession().getAttribute("user_role");
        Integer userId = (Integer) request.getSession().getAttribute("user_id");
        
        if (userRole == null || !"estudiante".equals(userRole) || userId == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }
        
        // 2. Obtener parámetros
        String titulo = request.getParameter("titulo");
        String contenido = request.getParameter("contenido");
        
        if (titulo == null || titulo.isEmpty() || contenido == null || contenido.isEmpty()) {
            request.getSession().setAttribute("message", "El título y el contenido son obligatorios.");
            request.getSession().setAttribute("status", "error");
            response.sendRedirect("InteraccionServlet");
            return;
        }

        // 3. Crear objeto y registrar
        InteraccionEstudiante nuevaInteraccion = new InteraccionEstudiante();
        nuevaInteraccion.setUsuarioId(userId);
        nuevaInteraccion.setTitulo(titulo);
        nuevaInteraccion.setContenidoEstudiante(contenido);
        // Ya NO establecemos estado.
        
        boolean success = interaccionDAO.enviarContenido(nuevaInteraccion);
        
        if (success) {
            request.getSession().setAttribute("message", "Contenido enviado exitosamente.");
            request.getSession().setAttribute("status", "success");
            
            // Registrar en bitácora
            bitacoraDAO.registrarAccion(userId, "Estudiante envió nuevo contenido: " + titulo);
            
        } else {
            request.getSession().setAttribute("message", "Error al guardar el contenido. Intenta de nuevo.");
            request.getSession().setAttribute("status", "error");
        }
        
        response.sendRedirect("InteraccionServlet");
    }
}