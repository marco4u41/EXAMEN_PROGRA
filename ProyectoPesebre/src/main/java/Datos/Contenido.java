package Datos;

import java.util.Date;

/**
 * Clase Modelo (POJO) para la tabla 'contenido'.
 */
public class Contenido {
    private int id;
    private String categoria;
    private String titulo;
    private String cuerpo;
    private String urlMultimedia;
    private Date fechaCreacion;

    public Contenido() {
    }

    // --- Getters y Setters ---

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getCategoria() {
        return categoria;
    }

    public void setCategoria(String categoria) {
        this.categoria = categoria;
    }

    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    public String getCuerpo() {
        return cuerpo;
    }

    public void setCuerpo(String cuerpo) {
        this.cuerpo = cuerpo;
    }

    public String getUrlMultimedia() {
        return urlMultimedia;
    }

    public void setUrlMultimedia(String urlMultimedia) {
        this.urlMultimedia = urlMultimedia;
    }

    public Date getFechaCreacion() {
        return fechaCreacion;
    }

    public void setFechaCreacion(Date fechaCreacion) {
        this.fechaCreacion = fechaCreacion;
    }
    
    /**
     * Determina si la URL es un video de YouTube (simplificado).
     */
    public boolean isYoutubeVideo() {
        return this.urlMultimedia != null && this.urlMultimedia.contains("youtube.com/embed");
    }
}