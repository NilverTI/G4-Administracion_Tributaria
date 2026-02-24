package com.tributaria.controller;

import com.tributaria.service.InmuebleService;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/funcionario/inmueble")
public class InmuebleServlet extends HttpServlet {

    private InmuebleService service = new InmuebleService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        // cargar combos siempre
        request.setAttribute("zonas", service.listarZonas());
        request.setAttribute("contribuyentes", service.listarContribuyentes());

        if (action == null) {

            request.setAttribute("lista", service.listar());
            request.getRequestDispatcher("/views/funcionario/inmueble/lista.jsp")
                   .forward(request, response);
            return;
        }

        if ("estado".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String estado = request.getParameter("estado");

            service.cambiarEstado(id, estado);

            response.sendRedirect(request.getContextPath() + "/funcionario/inmueble");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int idContribuyente = Integer.parseInt(request.getParameter("idContribuyente"));
        int idZona = Integer.parseInt(request.getParameter("idZona"));
        String direccion = request.getParameter("direccion");
        BigDecimal valor = new BigDecimal(request.getParameter("valor"));

        service.crear(idContribuyente, idZona, direccion, valor);

        response.sendRedirect(request.getContextPath() + "/funcionario/inmueble");
    }
}
