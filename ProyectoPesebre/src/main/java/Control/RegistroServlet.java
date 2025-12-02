package Control;

import Datos.UsuarioDAO;
import Datos.BitacoraDAO;

import java.io.IOException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet que maneja las peticiones de registro de nuevos usuarios.
 */
@WebServlet("/RegistroServlet")
public class RegistroServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private UsuarioDAO usuarioDAO;
    private BitacoraDAO bitacoraDAO;
    
    // REGEX para la validación de contraseña:
    // ^                 # inicio de la cadena
    // (?=.*[A-Z])       # debe contener al menos una mayúscula
    // (?=.*[0-9])       # debe contener al menos un número
    // .{8,}             # debe tener 8 o más caracteres
    // $                 # fin de la cadena
    private static final Pattern PASSWORD_PATTERN = Pattern.compile("^(?=.*[A-Z])(?=.*[0-9]).{8,}$");

    @Override
    public void init() throws ServletException {
        this.usuarioDAO = new UsuarioDAO();
        this.bitacoraDAO = new BitacoraDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Obtener parámetros del formulario
        String nombre = request.getParameter("nombre");
        String email = request.getParameter("email");
        String password = request.getParameter("password"); 
        
        // --- 2. VALIDACIÓN DEL LADO DEL SERVIDOR ---
        
        // 2a. Validación de Campos Vacíos (aunque HTML lo hace, el servidor debe re-validar)
        if (nombre == null || nombre.isEmpty() || email == null || email.isEmpty() || password == null || password.isEmpty()) {
            request.setAttribute("message", "Error: Todos los campos son obligatorios.");
            request.setAttribute("status", "error");
            bitacoraDAO.registrarAccion(null, "Intento de registro fallido: Campos vacíos.");
            request.getRequestDispatcher("registro.jsp").forward(request, response);
            return;
        }
        
        // 2b. Validación de Fortaleza de Contraseña (Mayúscula, Número, Mín. 8 chars)
        Matcher matcher = PASSWORD_PATTERN.matcher(password);
        if (!matcher.matches()) {
            request.setAttribute("message", "Error: La contraseña debe tener al menos 8 caracteres, una mayúscula y un número.");
            request.setAttribute("status", "error");
            bitacoraDAO.registrarAccion(null, "Intento de registro fallido: Contraseña débil. Email: " + email);
            request.getRequestDispatcher("registro.jsp").forward(request, response);
            return;
        }

        // --- 3. PROCESO DE REGISTRO ---
        
        boolean registroExitoso = usuarioDAO.registrarUsuario(nombre, email, password);

        if (registroExitoso) {
            // Éxito: Redirigir al login con mensaje
            request.getSession().setAttribute("message", "Registro exitoso! Por favor inicia sesión.");
            request.getSession().setAttribute("status", "success");
            
            bitacoraDAO.registrarAccion(null, "Registro de nuevo usuario exitoso. Email: " + email + ". Rol: estudiante."); 
            
            response.sendRedirect(request.getContextPath() + "/login.jsp"); 
        } else {
            // Falla (Probablemente email duplicado)
            request.setAttribute("message", "Error al registrar: El correo electrónico ya existe o hubo un fallo en DB.");
            request.setAttribute("status", "error");
            
            bitacoraDAO.registrarAccion(null, "Intento de registro fallido (email duplicado/DB). Email: " + email);
            
            request.getRequestDispatcher("registro.jsp").forward(request, response);
        }
    }
}