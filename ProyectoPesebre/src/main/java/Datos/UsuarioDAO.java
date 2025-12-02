package Datos;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Objeto de Acceso a Datos (DAO) para la entidad Usuario.
 * Contiene los métodos puros Java con sentencias SQL para manipular la DB.
 */
public class UsuarioDAO {

    // Método de autenticación, se omite por brevedad.

    /**
     * Busca un usuario por email.
     * @param email El correo electrónico del usuario.
     * @return El objeto Usuario si se encuentra, o null si no existe.
     */
    public Usuario buscarPorEmail(String email) {
        String sql = "SELECT id, nombre, email, password_hash, rol, estado FROM usuarios WHERE email = ?";
        Conexion conexion = new Conexion();
        Usuario usuario = null;

        try (Connection con = conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    usuario = new Usuario();
                    usuario.setId(rs.getInt("id"));
                    usuario.setNombre(rs.getString("nombre"));
                    usuario.setEmail(rs.getString("email"));
                    usuario.setPasswordHash(rs.getString("password_hash"));
                    usuario.setRol(rs.getString("rol"));
                    usuario.setEstado(rs.getString("estado"));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al buscar usuario por email: " + e.getMessage());
        } finally {
            conexion.cerrarConexion();
        }
        return usuario;
    }
    
    /**
     * Método para el Login: Verifica las credenciales y el estado de bloqueo.
     * Se omite por brevedad.
     */
    public Usuario autenticarUsuario(String email, String password) {
        // Implementación de autenticación
        Usuario usuario = buscarPorEmail(email);

        if (usuario != null) {
            if (PasswordUtil.checkPassword(password, usuario.getPasswordHash())) {
                if ("bloqueado".equals(usuario.getEstado())) {
                    return null; // Usuario bloqueado
                }
                return usuario;
            }
        }
        return null;
    }
    
    /**
     * Método para el Registro: Inserta un nuevo usuario con la clave hasheada.
     * Se omite por brevedad.
     */
    public boolean registrarUsuario(String nombre, String email, String password) {
        String sql = "INSERT INTO usuarios (nombre, email, password_hash, rol, estado) VALUES (?, ?, ?, ?, ?)";
        Conexion conexion = new Conexion();
        String passwordHash = PasswordUtil.hashPassword(password);
        
        try (Connection con = conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, nombre);
            ps.setString(2, email);
            ps.setString(3, passwordHash);
            ps.setString(4, "estudiante"); 
            ps.setString(5, "activo");     

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            if ("23505".equals(e.getSQLState())) {
                System.err.println("Error de registro: El email ya existe.");
            } else {
                e.printStackTrace();
            }
            return false;
        } finally {
            conexion.cerrarConexion();
        }
    }


    /**
     * Consulta todos los usuarios (para la interfaz de administrador).
     * Se omite por brevedad.
     */
    public List<Usuario> consultarTodosUsuarios() {
        List<Usuario> listaUsuarios = new ArrayList<>();
        String sql = "SELECT id, nombre, email, rol, estado FROM usuarios ORDER BY id";
        Conexion conexion = new Conexion();

        try (Connection con = conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Usuario usuario = new Usuario();
                usuario.setId(rs.getInt("id"));
                usuario.setNombre(rs.getString("nombre"));
                usuario.setEmail(rs.getString("email"));
                usuario.setRol(rs.getString("rol"));
                usuario.setEstado(rs.getString("estado"));
                listaUsuarios.add(usuario);
            }
        } catch (SQLException e) {
            System.err.println("Error al consultar todos los usuarios: " + e.getMessage());
        } finally {
            conexion.cerrarConexion();
        }
        return listaUsuarios;
    }

    /**
     * Bloquea o activa un usuario por su ID.
     */
    public boolean actualizarEstado(int idUsuario, String nuevoEstado) {
        String sql = "UPDATE usuarios SET estado = ? WHERE id = ?";
        Conexion conexion = new Conexion();

        try (Connection con = conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, nuevoEstado);
            ps.setInt(2, idUsuario);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            conexion.cerrarConexion();
        }
    }

    // --- NUEVA FUNCIÓN: Actualizar información de usuario (Nombre, Email, Rol) ---
    /**
     * Actualiza el nombre, email y rol de un usuario existente.
     */
    public boolean actualizarUsuario(int idUsuario, String nombre, String email, String rol) {
        // Aseguramos que el ID y el rol no puedan ser modificados por un usuario no administrador
        String sql = "UPDATE usuarios SET nombre = ?, email = ?, rol = ? WHERE id = ?";
        Conexion conexion = new Conexion();

        try (Connection con = conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, nombre);
            ps.setString(2, email);
            ps.setString(3, rol);
            ps.setInt(4, idUsuario);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            // Error de unicidad (email duplicado)
            if ("23505".equals(e.getSQLState())) {
                System.err.println("Error de actualización: El email " + email + " ya está en uso.");
            } else {
                e.printStackTrace();
            }
            return false;
        } finally {
            conexion.cerrarConexion();
        }
    }
}