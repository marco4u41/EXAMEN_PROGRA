package Control;

import Datos.Contenido;
import Datos.ContenidoDAO;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet que recupera y presenta el contenido multimedia basado en la categoría seleccionada.
 */
@WebServlet("/ContenidoServlet")
public class ContenidoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private ContenidoDAO contenidoDAO;

    @Override
    public void init() throws ServletException {
        this.contenidoDAO = new ContenidoDAO();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Obtener la categoría de la URL (ej: ContenidoServlet?categoria=Historia)
        String categoria = request.getParameter("categoria");
        
        if (categoria == null || categoria.trim().isEmpty()) {
            // Si no se especifica, redirigir a la página principal
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }
        
        // 2. Cargar el contenido para esa categoría
        List<Contenido> contenidoLista = contenidoDAO.consultarContenidoPorCategoria(categoria);
        
        // 3. Pasar los datos a la vista
        request.setAttribute("categoriaSeleccionada", categoria);
        request.setAttribute("contenidoLista", contenidoLista);
        
        // 4. Redirigir al JSP genérico de contenido
        request.getRequestDispatcher("/contenido_detalle.jsp").forward(request, response);
    }
}