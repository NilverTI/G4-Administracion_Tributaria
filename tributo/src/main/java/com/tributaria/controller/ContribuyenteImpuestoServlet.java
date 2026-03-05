package com.tributaria.controller;

import com.tributaria.dto.MiImpuestoDetalleDTO;
import com.tributaria.entity.Usuario;
import com.tributaria.service.ContribuyenteImpuestoService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/contribuyente/impuesto")
public class ContribuyenteImpuestoServlet extends HttpServlet {

    private final ContribuyenteImpuestoService impuestoService = new ContribuyenteImpuestoService();

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

        int idPersona = usuario.getPersona().getIdPersona();
        String filtroTipo = normalizarFiltro(request.getParameter("tipo"));

        request.setAttribute("filtroTipo", filtroTipo);
        request.setAttribute("items",
                impuestoService.listarMisImpuestos(idPersona, filtroTipo));

        String detalleTipo = request.getParameter("detalleTipo");
        int detalleId = parseInt(request.getParameter("detalleId"));

        MiImpuestoDetalleDTO detalle = null;
        if (detalleId > 0 && detalleTipo != null && !detalleTipo.isBlank()) {
            detalle = impuestoService.obtenerDetalle(idPersona, detalleTipo, detalleId);
        }

        request.setAttribute("detalle", detalle);
        request.getRequestDispatcher("/views/contribuyente/impuesto/lista.jsp")
                .forward(request, response);
    }

    private String normalizarFiltro(String filtro) {
        if (filtro == null) {
            return "TODOS";
        }
        String value = filtro.trim().toUpperCase();
        if ("PREDIAL".equals(value) || "VEHICULAR".equals(value)) {
            return value;
        }
        return "TODOS";
    }

    private int parseInt(String value) {
        if (value == null || value.isBlank()) {
            return -1;
        }
        try {
            return Integer.parseInt(value.trim());
        } catch (Exception ex) {
            return -1;
        }
    }
}
