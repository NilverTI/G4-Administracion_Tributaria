package com.tributaria.controladores;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.CallableStatement;
import java.sql.Connection;

import com.tributaria.config.Conexion;

@WebServlet("/crearUsuario")
public class CrearUsuarioServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String codigo = req.getParameter("codigo");
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        try {
            Connection cn = Conexion.getConexion();

            CallableStatement cs = cn.prepareCall("{CALL crear_usuario_contribuyente(?,?,?)}");
            cs.setString(1, codigo);
            cs.setString(2, username);
            cs.setString(3, password);

            cs.execute();

            // Usuario creado correctamente
            req.setAttribute("exito", "Usuario creado correctamente. Ahora puede iniciar sesión.");
            req.getRequestDispatcher("views/crearUsuario.jsp").forward(req, resp);

        } catch (Exception e) {

            // Manejo de errores desde el procedimiento almacenado
            String msg = e.getMessage();

            if (msg.contains("Código de contribuyente no válido")) {
                req.setAttribute("error", "El código ingresado no existe.");
            } 
            else if (msg.contains("ya tiene usuario")) {
                req.setAttribute("error", "Este contribuyente ya tiene usuario.");
            }
            else if (msg.contains("username ya está en uso")) {
                req.setAttribute("error", "El nombre de usuario ya existe, elija otro.");
            }
            else {
                req.setAttribute("error", "Error inesperado: " + msg);
            }

            req.getRequestDispatcher("views/crearUsuario.jsp").forward(req, resp);
        }
    }
}