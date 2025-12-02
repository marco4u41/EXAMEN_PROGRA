package Datos;

import java.util.Date;

/**
 * Clase Modelo (POJO) para la tabla de bitacora (logs).
 */
public class Bitacora {
    private int id;
    private Integer usuarioId; // Puede ser NULL si la acción es anónima (ej: error de conexión)
    private String accion;
    private Date fecha;

    public Bitacora() {
    }

    // --- Getters y Setters ---

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Integer getUsuarioId() {
        return usuarioId;
    }

    public void setUsuarioId(Integer usuarioId) {
        this.usuarioId = usuarioId;
    }

    public String getAccion() {
        return accion;
    }

    public void setAccion(String accion) {
        this.accion = accion;
    }

    public Date getFecha() {
        return fecha;
    }

    public void setFecha(Date fecha) {
        this.fecha = fecha;
    }
}