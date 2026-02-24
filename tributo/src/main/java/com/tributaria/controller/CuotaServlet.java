package com.tributaria.controller;

import com.tributaria.service.CuotaService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/funcionario/cuota")
public class CuotaServlet extends HttpServlet {

    private final CuotaService cuotaService = new CuotaService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ✅ LISTA CUOTAS
        List<Object[]> lista = cuotaService.listarVista();
        request.setAttribute("lista", lista);

        // ✅ COMBO: impuestos disponibles para fraccionar
        try {
            List<Object[]> impuestos = cuotaService.listarImpuestosParaFraccionar();
            request.setAttribute("impuestos", impuestos);
        } catch (Exception e) {
            request.setAttribute("impuestos", List.of());
            request.setAttribute("err", "No se pudo cargar impuestos para fraccionar");
        }

        if (request.getParameter("err") != null) request.setAttribute("err", request.getParameter("err"));
        if (request.getParameter("ok") != null) request.setAttribute("ok", request.getParameter("ok"));

        request.getRequestDispatcher("/views/funcionario/cuota/lista.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("crearFraccionamiento".equalsIgnoreCase(action)) {
            try {
                Integer idImpuesto = parseInt(request.getParameter("idImpuesto"));
                Integer numeroCuotas = parseInt(request.getParameter("numeroCuotas"));
                String fechaStr = request.getParameter("fechaPrimeraCuota");

                if (idImpuesto == null || numeroCuotas == null || fechaStr == null || fechaStr.trim().isEmpty()) {
                    redirectMsg(response, request.getContextPath() + "/funcionario/cuota",
                            "err", "Completa todos los campos");
                    return;
                }

                LocalDate fechaPrimera = LocalDate.parse(fechaStr.trim());

                cuotaService.crearFraccionamiento(idImpuesto, numeroCuotas, fechaPrimera);

                redirectMsg(response, request.getContextPath() + "/funcionario/cuota",
                        "ok", "Fraccionamiento creado");
                return;

            } catch (Exception e) {
                redirectMsg(response, request.getContextPath() + "/funcionario/cuota",
                        "err", (e.getMessage() != null ? e.getMessage() : "Error al crear fraccionamiento"));
                return;
            }
        }

        response.sendRedirect(request.getContextPath() + "/funcionario/cuota");
    }

    private Integer parseInt(String s) {
        if (s == null || s.trim().isEmpty()) return null;
        return Integer.parseInt(s.trim());
    }

    private void redirectMsg(HttpServletResponse response, String baseUrl, String key, String msg) throws IOException {
        String enc = URLEncoder.encode(msg, StandardCharsets.UTF_8);
        response.sendRedirect(baseUrl + "?" + key + "=" + enc);
    }
}