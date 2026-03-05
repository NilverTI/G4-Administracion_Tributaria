package com.tributaria.controller;

import com.tributaria.entity.Usuario;
import com.tributaria.service.ContribuyenteDashboardService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/contribuyente/dashboard")
public class ContribuyenteDashboardServlet extends HttpServlet {

    private final ContribuyenteDashboardService dashboardService = new ContribuyenteDashboardService();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Usuario usuario = session == null ? null : (Usuario) session.getAttribute("usuario");
        if (usuario == null || usuario.getPersona() == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.setAttribute(
                "dashboard",
                dashboardService.obtenerResumen(usuario.getPersona().getIdPersona())
        );

        request.getRequestDispatcher(
                "/views/contribuyente/dashboard/index.jsp"
        ).forward(request, response);
    }
}
