package Control;

import Datos.InteraccionDAO;
import Datos.InteraccionEstudiante;
import Datos.Usuario;
import Datos.UsuarioDAO;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet que permite al estudiante revisar su perfil e interacciones enviadas.
 */
@WebServlet("/estudiante/MisDatosServlet")
public class MisDatosServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private UsuarioDAO usuarioDAO;
    private InteraccionDAO interaccionDAO;

    @Override
    public void init() throws ServletException {
        this.usuarioDAO = new UsuarioDAO();
        this.interaccionDAO = new InteraccionDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Verificar sesión y rol
        String userRole = (String) request.getSession().getAttribute("user_role");
        Integer userIdObj = (Integer) request.getSession().getAttribute("user_id");

        if (userRole == null || !"estudiante".equals(userRole) || userIdObj == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }
        
        int userId = userIdObj.intValue(); // Convertir a primitivo para usar en el DAO (si el método lo requiere)
        
        // 2. Obtener perfil del usuario
        Usuario usuario = usuarioDAO.buscarPorEmail((String)request.getSession().getAttribute("user_email"));
        
        // 3. Obtener interacciones enviadas (CORRECCIÓN: Se asume que el DAO acepta int primitivo)
        List<InteraccionEstudiante> interacciones = interaccionDAO.consultarMisInteracciones(userId);
        
        // 4. Pasar los datos a la vista
        request.setAttribute("usuarioPerfil", usuario);
        request.setAttribute("interacciones", interacciones);
        
        // 5. Redirigir la petición al JSP
        request.getRequestDispatcher("/estudiante/mis_datos.jsp").forward(request, response);
    }
}