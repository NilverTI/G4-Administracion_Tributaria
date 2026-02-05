package com.tributaria.dao;

import java.sql.*;
import com.tributaria.config.Conexion;
import com.tributaria.model.Usuario;

public class UsuarioDAO {

    // ===========================
    //   LOGIN
    // ===========================
    public Usuario login(String username, String password) throws Exception {

        String sql = "SELECT id_usuario, id_persona, id_rol, username, password_hash " +
                     "FROM usuario WHERE username = ? AND password_hash = ?";

        PreparedStatement ps = Conexion.getConexion().prepareStatement(sql);
        ps.setString(1, username);
        ps.setString(2, password);

        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            Usuario u = new Usuario();
            u.setIdUsuario(rs.getLong("id_usuario"));
            u.setIdPersona(rs.getLong("id_persona"));
            u.setIdRol(rs.getLong("id_rol"));
            u.setUsername(rs.getString("username"));
            u.setPasswordHash(rs.getString("password_hash"));
            return u;
        }

        return null; // Login fallido
    }


    // ===========================
    //   CREAR USUARIO (PA)
    // ===========================
    public void crearUsuarioContribuyente(String codigo, String username, String password) throws Exception {

        String sql = "{CALL crear_usuario_contribuyente(?,?,?)}";

        try (Connection con = Conexion.getConexion();
             CallableStatement cs = con.prepareCall(sql)) {

            cs.setString(1, codigo);
            cs.setString(2, username);
            cs.setString(3, password);

            cs.execute();

        } catch (SQLException e) {

            // Si MySQL lanzó un SIGNAL
            if ("45000".equals(e.getSQLState())) {
                throw new Exception(e.getMessage());
            }

            throw new Exception("Error al crear usuario: " + e.getMessage());
        }
    }
}