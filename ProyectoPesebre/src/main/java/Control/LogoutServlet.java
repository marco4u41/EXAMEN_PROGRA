package Control;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet que maneja el cierre de sesión.
 * Invalida la sesión actual y redirige a la página principal.
 */
@WebServlet("/LogoutServlet")
public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false); // No crear sesión si no existe
        
        if (session != null) {
            session.invalidate(); // Invalida (destruye) la sesión
            
            // Mensaje de confirmación
            request.getSession().setAttribute("message", "Has cerrado la sesión exitosamente.");
            request.getSession().setAttribute("status", "success");
        }
        
        // Redirigir al inicio
        response.sendRedirect("index.jsp");
    }
}