package com.tributaria.controller;

import com.tributaria.entity.Usuario;
import com.tributaria.service.UsuarioService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private UsuarioService usuarioService = new UsuarioService();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/views/auth/login.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        // 1️⃣ Obtener datos del formulario
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // 2️⃣ Autenticar usuario
        Usuario usuario = usuarioService.autenticar(username, password);

        if (usuario != null) {

            // 3️⃣ Crear sesión
            HttpSession session = request.getSession(true);
            session.setAttribute("usuario", usuario);
            session.setMaxInactiveInterval(20 * 60); // 20 minutos

            // 4️⃣ Obtener nombre del rol
            String nombreRol = usuario.getRol().getNombre();

            // 5️⃣ Redirigir según rol
            if ("ADMIN".equalsIgnoreCase(nombreRol)
                    || "FUNCIONARIO".equalsIgnoreCase(nombreRol)) {

                response.sendRedirect(
                        request.getContextPath()
                                + "/funcionario/dashboard"
                );

            } else if ("CONTRIBUYENTE".equalsIgnoreCase(nombreRol)) {

                response.sendRedirect(
                        request.getContextPath()
                                + "/contribuyente/dashboard"
                );

            } else {
                // Rol desconocido → cerrar sesión por seguridad
                session.invalidate();
                response.sendRedirect(
                        request.getContextPath()
                                + "/views/auth/login.jsp"
                );
            }

        } else {

            // 6️⃣ Credenciales incorrectas
            request.setAttribute("error", "Usuario o contraseña incorrectos");

            request.getRequestDispatcher(
                    "/views/auth/login.jsp"
            ).forward(request, response);
        }
    }
}
