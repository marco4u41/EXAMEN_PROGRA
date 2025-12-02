package Datos;

import java.util.Date;

/**
 * Clase Modelo (POJO) para el contenido enviado por el estudiante.
 * Se utiliza para registrar y visualizar los aportes.
 */
public class InteraccionEstudiante {
    private int id;
    private int usuarioId;
    private String nombreUsuario; 
    private String titulo;
    private String contenidoEstudiante;
    private Date fechaEnvio;

    public InteraccionEstudiante() {
    }

    // --- Getters y Setters ---

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUsuarioId() {
        return usuarioId;
    }

    public void setUsuarioId(int usuarioId) {
        this.usuarioId = usuarioId;
    }
    
    public String getNombreUsuario() {
        return nombreUsuario;
    }

    public void setNombreUsuario(String nombreUsuario) {
        this.nombreUsuario = nombreUsuario;
    }


    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    public String getContenidoEstudiante() {
        return contenidoEstudiante;
    }

    public void setContenidoEstudiante(String contenidoEstudiante) {
        this.contenidoEstudiante = contenidoEstudiante;
    }

    public Date getFechaEnvio() {
        return fechaEnvio;
    }

    public void setFechaEnvio(Date fechaEnvio) {
        this.fechaEnvio = fechaEnvio;
    }
    
    // NOTA: El método getEstadoRevision() ha sido ELIMINADO para resolver el NoSuchMethodError.
}