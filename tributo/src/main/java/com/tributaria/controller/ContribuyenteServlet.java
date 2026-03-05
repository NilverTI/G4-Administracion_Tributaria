package com.tributaria.controller;

import com.tributaria.service.ContribuyenteService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;

@WebServlet("/funcionario/contribuyente")
public class ContribuyenteServlet extends HttpServlet {

    private final ContribuyenteService service = new ContribuyenteService();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null || action.isBlank()) {
            request.setAttribute("lista", service.listar());
            request.getRequestDispatcher("/views/funcionario/contribuyente/lista.jsp")
                    .forward(request, response);
            return;
        }

        if ("estado".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String estado = request.getParameter("estado");

            service.cambiarEstado(id, estado);
            response.sendRedirect(request.getContextPath() + "/funcionario/contribuyente");
            return;
        }

        if ("ver".equals(action) || "editar".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Object[] contribuyente = service.obtenerPorId(id);

            if (contribuyente == null) {
                response.sendRedirect(request.getContextPath() + "/funcionario/contribuyente");
                return;
            }

            request.setAttribute("contribuyente", contribuyente);

            String destino = "ver".equals(action)
                    ? "/views/funcionario/contribuyente/ver.jsp"
                    : "/views/funcionario/contribuyente/editar.jsp";

            request.getRequestDispatcher(destino).forward(request, response);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/funcionario/contribuyente");
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws IOException {

        String action = trim(request.getParameter("action"));
        String tipoDoc = "DNI";
        String numeroDoc = trim(request.getParameter("numeroDoc"));
        String nombres = trim(request.getParameter("nombres"));
        String apellidos = trim(request.getParameter("apellidos"));
        String telefono = trim(request.getParameter("telefono"));
        String email = trim(request.getParameter("email"));
        String direccion = trim(request.getParameter("direccion"));
        String fechaNacimientoParam = trim(request.getParameter("fechaNacimiento"));
        LocalDate fechaNacimiento = (fechaNacimientoParam == null || fechaNacimientoParam.isBlank())
                ? null
                : LocalDate.parse(fechaNacimientoParam);

        if ("editar".equals(action)) {
            int idContribuyente = Integer.parseInt(request.getParameter("idContribuyente"));
            service.actualizar(
                    idContribuyente,
                    numeroDoc,
                    nombres,
                    apellidos,
                    telefono,
                    email,
                    direccion,
                    fechaNacimiento
            );
        } else {
            service.crear(
                    tipoDoc,
                    numeroDoc,
                    nombres,
                    apellidos,
                    telefono,
                    email,
                    direccion,
                    fechaNacimiento
            );
        }

        response.sendRedirect(request.getContextPath() + "/funcionario/contribuyente");
    }

    private String trim(String value) {
        return value == null ? null : value.trim();
    }
}
