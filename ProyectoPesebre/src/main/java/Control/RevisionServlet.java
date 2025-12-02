package Control;

import Datos.InteraccionEstudiante;
import Datos.InteraccionDAO;
import Datos.BitacoraDAO;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet que permite al administrador consultar TODO el contenido enviado por los estudiantes.
 * Nota: Este servlet no maneja aprobación/rechazo, solo auditoría.
 */
@WebServlet("/admin/RevisionServlet")
public class RevisionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private InteraccionDAO interaccionDAO;
    private BitacoraDAO bitacoraDAO;

    @Override
    public void init() throws ServletException {
        this.interaccionDAO = new InteraccionDAO();
        this.bitacoraDAO = new BitacoraDAO();
    }

    // --- GET: Muestra la lista de contenido para auditoría ---
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String userRole = (String) request.getSession().getAttribute("user_role");
        if (userRole == null || !"administrador".equals(userRole)) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }
        
        // Cargar todos los envíos
        List<InteraccionEstudiante> envios = interaccionDAO.consultarTodasInteracciones();
        
        request.setAttribute("envios", envios);
        
        // Registrar acción en bitácora (opcional)
        Integer adminId = (Integer) request.getSession().getAttribute("user_id");
        bitacoraDAO.registrarAccion(adminId, "Admin accedió al panel de auditoría de envíos de estudiantes.");
        
        request.getRequestDispatcher("/admin/auditoria_envios.jsp").forward(request, response);
    }
    
    // El método doPost se omite ya que no hay acciones de aprobación/rechazo.
}