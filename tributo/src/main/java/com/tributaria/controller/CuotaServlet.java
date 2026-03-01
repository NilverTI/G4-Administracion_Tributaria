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

        String action = request.getParameter("action");

        // ✅ ENDPOINT JSON: detalle de cuotas por impuesto (para modal)
        if ("detalle".equalsIgnoreCase(action)) {
            Integer idImpuesto = parseInt(request.getParameter("idImpuesto"));
            if (idImpuesto == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().write("{\"error\":\"idImpuesto requerido\"}");
                return;
            }

            List<Object[]> cuotas = cuotaService.listarCuotasPorImpuesto(idImpuesto);

            response.setContentType("application/json;charset=UTF-8");
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < cuotas.size(); i++) {
                Object[] c = cuotas.get(i);

                // Esperado (ideal): 0=idCuota,1=numero,2=totalCuotas,3=monto,4=vencimiento,5=estado
                json.append("{")
                        .append("\"id\":").append(c[0]).append(",")
                        .append("\"numero\":").append(c[1]).append(",")
                        .append("\"total\":").append(c[2]).append(",")
                        .append("\"monto\":\"").append(String.valueOf(c[3])).append("\",")
                        .append("\"vencimiento\":\"").append(String.valueOf(c[4])).append("\",")
                        .append("\"estado\":\"").append(escapeJson(String.valueOf(c[5]))).append("\"")
                        .append("}");

                if (i < cuotas.size() - 1) json.append(",");
            }
            json.append("]");
            response.getWriter().write(json.toString());
            return;
        }

        // ✅ LISTA PRINCIPAL AGRUPADA (1 fila por impuesto fraccionado)
        var lista = cuotaService.listarFraccionamientosAgrupados();
        request.setAttribute("lista", lista);

        // ✅ COMBO: impuestos disponibles para fraccionar (SP)
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
        try {
            return Integer.parseInt(s.trim());
        } catch (Exception e) {
            return null;
        }
    }

    private void redirectMsg(HttpServletResponse response, String baseUrl, String key, String msg) throws IOException {
        String enc = URLEncoder.encode(msg, StandardCharsets.UTF_8);
        response.sendRedirect(baseUrl + "?" + key + "=" + enc);
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}