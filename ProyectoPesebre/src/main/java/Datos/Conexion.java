package Datos;

import java.sql.*;

/**
 * Clase para manejar la conexión a la base de datos PostgreSQL, 
 * siguiendo la estructura solicitada por el usuario.
 * * AVISO DE SEGURIDAD: El uso de java.sql.Statement (métodos Ejecutar y Consulta) 
 * es vulnerable a inyección SQL. Se recomienda usar PreparedStatement en el DAO.
 */
public class Conexion {
    private Statement St;
    private String driver;
    private String user;
    private String pwd;
    private String cadena;
    private Connection con;

    // --- Getters según la estructura solicitada ---
    String getDriver() {
        return this.driver;
    }
    String getUser() {
        return this.user;
    }
    String getPwd() {
        return this.pwd;
    }
    String getCadena() {
        return this.cadena;
    }
    public Connection getConexion() {
        // Aseguramos que la conexión exista y esté abierta antes de devolverla
        try {
            if (this.con == null || this.con.isClosed()) {
                this.con = this.crearConexion();
            }
        } catch (SQLException e) {
            System.err.println("Error al verificar el estado de la conexión: " + e.getMessage());
        }
        return this.con;
    }
    
    // --- Constructor ---
    public Conexion() {
        this.driver ="org.postgresql.Driver";
        // *** DB CONFIGURATION: ENSURE THESE VALUES ARE CORRECT ***
        this.user="postgres";
        this.pwd="admin"; // CHANGE THIS FOR YOUR REAL POSTGRESQL PASSWORD
        this.cadena="jdbc:postgresql://localhost:5432/DB_Pesebre"; // Assuming port 5432 and DB "natividad_db"
        this.con=this.crearConexion();
    }
    
    // --- Connection Logic ---
    Connection crearConexion() {
        try {
            Class.forName(getDriver());
            Connection con = DriverManager.getConnection(getCadena(), getUser(), getPwd());
            return con;
        } catch (Exception ee) {
            System.err.println("Error al crear la conexión: " + ee.getMessage());
            // ee.printStackTrace(); // Uncomment for detailed debugging
            return null;
        }
    }

    // --- Statement Operations (NOT SAFE - Use only for testing) ---

    public String Ejecutar(String sql) {
        String result = "";
        // Statement is created and closed inside the method
        try (Statement St = getConexion().createStatement()) {
            St.execute(sql);
            result = "Operación realizada con éxito";
        } catch (Exception ex) {
            result = "Error: " + ex.getMessage();
            System.err.println("Error Ejecutar SQL: " + result);
        }
        return(result);
    }

    public ResultSet Consulta(String sql) {
        ResultSet reg = null;
        // NOTE: In this structure, the Statement and Connection must be explicitly 
        // closed by the method that calls Consulta after using the ResultSet.
        try {
            St = getConexion().createStatement();
            reg = St.executeQuery(sql);
        } catch (Exception ee) {
            System.err.println("Error Consulta SQL: " + ee.getMessage());
            reg = null;
        }
        return(reg);
    }
    
    /**
     * Closes the connection securely.
     */
    public void cerrarConexion() {
        try {
            if (con != null && !con.isClosed()) {
                con.close();
            }
        } catch (SQLException e) {
            System.err.println("Error al cerrar la conexión: " + e.getMessage());
        }
    }
}