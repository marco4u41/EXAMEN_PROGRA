package Datos;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Objeto de Acceso a Datos (DAO) para la entidad Contenido.
 */
public class ContenidoDAO {

    /**
     * Consulta todo el contenido para una categoría específica.
     * @param categoria La categoría a buscar ('Historia', 'Personajes', 'Interactivo').
     * @return Lista de objetos Contenido.
     */
    public List<Contenido> consultarContenidoPorCategoria(String categoria) {
        List<Contenido> listaContenido = new ArrayList<>();
        String sql = "SELECT id, categoria, titulo, cuerpo, url_multimedia, fecha_creacion FROM contenido WHERE categoria = ? ORDER BY id";
        Conexion conexion = new Conexion();

        try (Connection con = conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, categoria);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Contenido c = new Contenido();
                    c.setId(rs.getInt("id"));
                    c.setCategoria(rs.getString("categoria"));
                    c.setTitulo(rs.getString("titulo"));
                    c.setCuerpo(rs.getString("cuerpo"));
                    c.setUrlMultimedia(rs.getString("url_multimedia"));
                    c.setFechaCreacion(rs.getTimestamp("fecha_creacion"));
                    listaContenido.add(c);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al consultar contenido por categoría: " + e.getMessage());
        } finally {
            conexion.cerrarConexion();
        }
        return listaContenido;
    }
}