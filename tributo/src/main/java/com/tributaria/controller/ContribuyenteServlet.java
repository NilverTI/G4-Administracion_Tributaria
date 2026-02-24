package com.tributaria.controller;

import com.tributaria.service.ContribuyenteService;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/funcionario/contribuyente")
public class ContribuyenteServlet extends HttpServlet {

    private ContribuyenteService service = new ContribuyenteService();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null) {
            // 📌 LISTAR
            request.setAttribute("lista", service.listar());

            request.getRequestDispatcher(
                    "/views/funcionario/contribuyente/lista.jsp"
            ).forward(request, response);

        } else if ("estado".equals(action)) {

            int id = Integer.parseInt(request.getParameter("id"));
            String estado = request.getParameter("estado");

            service.cambiarEstado(id, estado);

            response.sendRedirect(
                    request.getContextPath() +
                            "/funcionario/contribuyente"
            );
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws IOException {

        String tipoDoc = "DNI"; // por ahora fijo
        String numeroDoc = request.getParameter("numeroDoc");
        String nombres = request.getParameter("nombres");
        String apellidos = request.getParameter("apellidos");
        String telefono = request.getParameter("telefono");
        String email = request.getParameter("email");
        String direccion = request.getParameter("direccion");

        service.crear(
                tipoDoc,
                numeroDoc,
                nombres,
                apellidos,
                telefono,
                email,
                direccion
        );

        response.sendRedirect(
                request.getContextPath() +
                        "/funcionario/contribuyente"
        );
    }
}
