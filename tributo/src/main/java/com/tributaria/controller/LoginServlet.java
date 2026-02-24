package com.tributaria.controller;

import com.tributaria.entity.Usuario;
import com.tributaria.service.UsuarioService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet({"/login", "/logout"})
public class LoginServlet extends HttpServlet {

    private final UsuarioService usuarioService = new UsuarioService();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        // 🔴 LOGOUT
        if ("/logout".equals(path)) {

            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }

            // ✅ Anti-cache (evita volver con el botón atrás)
            response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            response.setHeader("Pragma", "no-cache");
            response.setDateHeader("Expires", 0);

            // ✅ Redirección limpia al servlet /login
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // 🟢 LOGIN (GET)
        // ✅ Anti-cache también para la vista login
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        request.getRequestDispatcher("/views/auth/login.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        Usuario usuario = usuarioService.autenticar(username, password);

        if (usuario != null) {

            HttpSession session = request.getSession(true);
            session.setAttribute("usuario", usuario);
            session.setMaxInactiveInterval(20 * 60);

            String nombreRol = (usuario.getRol() != null) ? usuario.getRol().getNombre() : "";

            if ("ADMIN".equalsIgnoreCase(nombreRol) || "FUNCIONARIO".equalsIgnoreCase(nombreRol)) {

                response.sendRedirect(request.getContextPath() + "/funcionario/dashboard");
                return;

            } else if ("CONTRIBUYENTE".equalsIgnoreCase(nombreRol)) {

                // Mejor práctica: redirigir a un servlet, pero si tu vista es directa lo dejamos así
                response.sendRedirect(request.getContextPath() + "/views/contribuyente/dashboard/index.jsp");
                return;

            } else {
                session.invalidate();
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

        } else {

            request.setAttribute("error", "Usuario o contraseña incorrectos");

            request.getRequestDispatcher("/views/auth/login.jsp")
                   .forward(request, response);
        }
    }
}