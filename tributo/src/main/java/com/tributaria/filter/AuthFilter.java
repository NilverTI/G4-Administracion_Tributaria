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
        boolean registroRequest = path.equals(context + "/registro");
        boolean loginPage = path.contains("/views/auth/");
        boolean resources = path.contains("/css/")
                || path.contains("/js/")
                || path.contains("/images/");

        if (loginRequest || registroRequest || loginPage || resources) {
            chain.doFilter(request, response);
            return;
        }

        // 🔹 Si no hay sesión → login
        if (usuario == null) {
            System.out.println("NO HAY USUARIO EN SESION");
            res.sendRedirect(context + "/login");
            return;
        }

        // 🔹 Validar acceso por rol
        String rol = usuario.getRol().getNombre();

        boolean funcionarioPath = path.startsWith(context + "/funcionario/")
                || path.contains("/views/funcionario/");
        boolean contribuyentePath = path.startsWith(context + "/contribuyente/")
                || path.contains("/views/contribuyente/");

        if (funcionarioPath) {

            if (!rol.equalsIgnoreCase("ADMIN")
                    && !rol.equalsIgnoreCase("FUNCIONARIO")) {

                res.sendRedirect(context + "/login");
                return;
            }
        }

        if (contribuyentePath) {

            if (!rol.equalsIgnoreCase("CONTRIBUYENTE")) {

                res.sendRedirect(context + "/login");
                return;
            }
        }

        // 🔹 Si todo está correcto
        chain.doFilter(request, response);
    }
}
