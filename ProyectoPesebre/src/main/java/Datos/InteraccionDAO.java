package Datos;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Objeto de Acceso a Datos (DAO) para la Interacción del Estudiante.
 */
public class InteraccionDAO {
    
    /**
     * Permite al estudiante enviar contenido.
     */
    public boolean enviarContenido(InteraccionEstudiante interaccion) {
        String sql = "INSERT INTO estudiante_interaccion (usuario_id, titulo, contenido_estudiante, fecha_envio) VALUES (?, ?, ?, NOW())";
        Conexion conexion = new Conexion();
        
        try (Connection con = conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, interaccion.getUsuarioId());
            ps.setString(2, interaccion.getTitulo());
            ps.setString(3, interaccion.getContenidoEstudiante());

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error al enviar contenido del estudiante: " + e.getMessage());
            return false;
        } finally {
            conexion.cerrarConexion();
        }
    }
    
    /**
     * Consulta todas las interacciones de un estudiante específico por ID.
     */
    public List<InteraccionEstudiante> consultarMisInteracciones(int userId) {
        List<InteraccionEstudiante> lista = new ArrayList<>();
        String sql = "SELECT id, titulo, contenido_estudiante, fecha_envio FROM estudiante_interaccion WHERE usuario_id = ? ORDER BY fecha_envio DESC";
        Conexion conexion = new Conexion();

        try (Connection con = conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    InteraccionEstudiante i = new InteraccionEstudiante();
                    i.setId(rs.getInt("id"));
                    i.setUsuarioId(userId);
                    i.setTitulo(rs.getString("titulo"));
                    i.setContenidoEstudiante(rs.getString("contenido_estudiante"));
                    i.setFechaEnvio(rs.getTimestamp("fecha_envio"));
                    lista.add(i);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al consultar interacciones: " + e.getMessage());
        } finally {
            conexion.cerrarConexion();
        }
        return lista;
    }
    
    // --- NUEVO MÉTODO PARA ADMINISTRADOR ---
    /**
     * Consulta todas las interacciones de TODOS los estudiantes.
     * Incluye el nombre del usuario asociado.
     */
    public List<InteraccionEstudiante> consultarTodasInteracciones() {
        List<InteraccionEstudiante> lista = new ArrayList<>();
        // JOIN para obtener el nombre del estudiante de la tabla usuarios
        String sql = "SELECT i.id, i.usuario_id, i.titulo, i.contenido_estudiante, i.fecha_envio, u.nombre " +
                     "FROM estudiante_interaccion i JOIN usuarios u ON i.usuario_id = u.id ORDER BY i.fecha_envio DESC";
        Conexion conexion = new Conexion();

        try (Connection con = conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                InteraccionEstudiante i = new InteraccionEstudiante();
                i.setId(rs.getInt("id"));
                i.setUsuarioId(rs.getInt("usuario_id"));
                i.setTitulo(rs.getString("titulo"));
                i.setContenidoEstudiante(rs.getString("contenido_estudiante"));
                i.setFechaEnvio(rs.getTimestamp("fecha_envio"));
                // Establecer el nombre del usuario para la vista
                i.setNombreUsuario(rs.getString("nombre")); 
                lista.add(i);
            }
        } catch (SQLException e) {
            System.err.println("Error al consultar todas las interacciones para admin: " + e.getMessage());
        } finally {
            conexion.cerrarConexion();
        }
        return lista;
    }
}