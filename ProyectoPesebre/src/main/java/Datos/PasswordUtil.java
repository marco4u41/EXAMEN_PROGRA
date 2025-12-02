package Datos;

/**
 * Clase de utilidad para manejar el hashing y verificación de contraseñas.
 * NOTA: En un proyecto real, DEBES usar librerías robustas como BCrypt o Argon2
 * y no esta simulación.
 */
public class PasswordUtil {

    /**
     * Simula el hashing de una contraseña.
     * @param password La clave en texto plano.
     * @return La clave "hasheada" (en esta simulación, con un prefijo).
     */
    public static String hashPassword(String password) {
        // En producción: return BCrypt.hashpw(password, BCrypt.gensalt());
        return "HASHED_" + password; 
    }

    /**
     * Simula la verificación de una contraseña.
     * @param plainPassword La clave ingresada por el usuario.
     * @param hashedPassword La clave hasheada guardada en la DB.
     * @return true si coinciden, false en caso contrario.
     */
    public static boolean checkPassword(String plainPassword, String hashedPassword) {
        // En producción: return BCrypt.checkpw(plainPassword, hashedPassword);
        return hashedPassword != null && hashedPassword.equals(hashPassword(plainPassword));
    }
}