package Datos;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Objeto de Acceso a Datos (DAO) para la entidad Bitacora.
 * Maneja las operaciones de registro y consulta de logs.
 */
public class BitacoraDAO {

    /**
     * Registra una acción en la tabla de bitácora.
     * @param usuarioId ID del usuario que realiza la acción (puede ser null).
     * @param accion Descripción del evento.
     * @return true si el registro fue exitoso.
     */
    public boolean registrarAccion(Integer usuarioId, String accion) {
        String sql = "INSERT INTO bitacora (usuario_id, accion) VALUES (?, ?)";
        Conexion conexion = new Conexion();
        
        try (Connection con = conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            if (usuarioId == null) {
                ps.setNull(1, java.sql.Types.INTEGER);
            } else {
                ps.setInt(1, usuarioId);
            }
            ps.setString(2, accion);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error al registrar acción en bitácora: " + e.getMessage());
            return false;
        } finally {
            conexion.cerrarConexion();
        }
    }

    /**
     * Consulta todas las acciones de la bitácora.
     * @return Lista de objetos Bitacora.
     */
    public List<Bitacora> consultarBitacora() {
        List<Bitacora> listaBitacora = new ArrayList<>();
        // Consulta más reciente primero
        String sql = "SELECT id, usuario_id, accion, fecha FROM bitacora ORDER BY fecha DESC";
        Conexion conexion = new Conexion();

        try (Connection con = conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Bitacora log = new Bitacora();
                log.setId(rs.getInt("id"));
                // El campo usuario_id puede ser nulo en la DB
                if (rs.getObject("usuario_id") != null) {
                     log.setUsuarioId(rs.getInt("usuario_id"));
                }
                log.setAccion(rs.getString("accion"));
                log.setFecha(rs.getTimestamp("fecha"));
                listaBitacora.add(log);
            }
        } catch (SQLException e) {
            System.err.println("Error al consultar bitácora: " + e.getMessage());
        } finally {
            conexion.cerrarConexion();
        }
        return listaBitacora;
    }
}