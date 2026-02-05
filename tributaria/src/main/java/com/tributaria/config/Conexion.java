package com.tributaria.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {

    private static Connection conexion;

    private static final String URL =
        "jdbc:mysql://localhost:3306/tributo?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";

    private static final String USER = "root";
    private static final String PASS = "";

    // Cargar driver solo una vez
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("[OK] Driver MySQL cargado correctamente");
        } catch (ClassNotFoundException e) {
            System.err.println("[ERROR] No se pudo cargar el driver MySQL");
            e.printStackTrace();
        }
    }

    private Conexion() { }

    public static Connection getConexion() throws SQLException {

        try {
            if (conexion == null || conexion.isClosed()) {
                conexion = DriverManager.getConnection(URL, USER, PASS);
                System.out.println("[OK] Conectado a MySQL");
            }
        } catch (SQLException e) {
            System.err.println("[ERROR] No se pudo conectar a MySQL");
            throw e;
        }

        return conexion;
    }
}
