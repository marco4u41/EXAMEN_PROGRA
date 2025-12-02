package Control;

import Datos.Bitacora;
import Datos.BitacoraDAO;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet que permite al administrador consultar los registros de bitácora.
 */
@WebServlet("/admin/BitacoraServlet")
public class BitacoraServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private BitacoraDAO bitacoraDAO;

    @Override
    public void init() throws ServletException {
        this.bitacoraDAO = new BitacoraDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Verificar el rol de administrador (Seguridad crítica)
        String userRole = (String) request.getSession().getAttribute("user_role");
        if (userRole == null || !"administrador".equals(userRole)) {
            request.getSession().setAttribute("message", "Acceso denegado.");
            request.getSession().setAttribute("status", "error");
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }
        
        // 2. Obtener la lista de logs desde el DAO
        List<Bitacora> logs = bitacoraDAO.consultarBitacora();
        
        // 3. Pasar la lista a la vista
        request.setAttribute("logs", logs);
        
        // 4. Redirigir al JSP para que muestre los datos
        request.getRequestDispatcher("/admin/bitacora.jsp").forward(request, response);
    }
}