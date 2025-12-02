package Datos;

/**
 * Clase Modelo (POJO) para la tabla de usuarios.
 */
public class Usuario {
    private int id;
    private String nombre;
    private String email;
    private String passwordHash; // Contraseña ya hasheada
    private String rol;         // administrador, estudiante
    private String estado;      // activo, bloqueado

    // Constructor vacío
    public Usuario() {
    }

    // Constructor con datos
    public Usuario(String nombre, String email, String passwordHash) {
        this.nombre = nombre;
        this.email = email;
        this.passwordHash = passwordHash;
        this.rol = "estudiante"; // Valor por defecto
        this.estado = "activo";  // Valor por defecto
    }

    // --- Getters y Setters ---

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getRol() {
        return rol;
    }

    public void setRol(String rol) {
        this.rol = rol;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }
}