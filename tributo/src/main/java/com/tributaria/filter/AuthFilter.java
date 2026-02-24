package com.tributaria.filter;

import com.tributaria.entity.Usuario;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request,
                         ServletResponse response,
                         FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String path = req.getRequestURI();
        String context = req.getContextPath();

        HttpSession session = req.getSession(false);
        Usuario usuario = (session != null)
                ? (Usuario) session.getAttribute("usuario")
                : null;

        // 🔹 Rutas públicas
        boolean loginRequest = path.equals(context + "/login");
        boolean loginPage = path.contains("/views/auth/");
        boolean resources = path.contains("/css/")
                || path.contains("/js/")
                || path.contains("/images/");

        if (loginRequest || loginPage || resources) {
            chain.doFilter(request, response);
            return;
        }

        // 🔹 Si no hay sesión → login
        if (usuario == null) {
            System.out.println("NO HAY USUARIO EN SESION");
            res.sendRedirect(context + "/login");
            return;
        }

        System.out.println("------------");
        System.out.println("PATH: " + path);
        System.out.println("USUARIO EN SESION: " + (usuario != null));
        System.out.println("ROL: " + usuario.getRol().getNombre());
        System.out.println("------------");

        // 🔹 Validar acceso por rol
        String rol = usuario.getRol().getNombre();

        if (path.contains("/views/funcionario/")) {

            if (!rol.equalsIgnoreCase("ADMIN")
                    && !rol.equalsIgnoreCase("FUNCIONARIO")) {

                res.sendRedirect(context + "/login");
                return;
            }
        }

        if (path.contains("/views/contribuyente/")) {

            if (!rol.equalsIgnoreCase("CONTRIBUYENTE")) {

                res.sendRedirect(context + "/login");
                return;
            }
        }

        // 🔹 Si todo está correcto
        chain.doFilter(request, response);
    }
}
