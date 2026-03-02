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

        // ✅ JSON detalle cuotas (para modal)
        // TU SP sp_listar_cuotas_por_impuesto devuelve: numero, vencimiento, monto, estado
        if ("detalle".equalsIgnoreCase(action)) {
            Integer idImpuesto = parseInt(request.getParameter("idImpuesto"));
            if (idImpuesto == null || idImpuesto <= 0) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().write("{\"error\":\"idImpuesto requerido\"}");
                return;
            }

            try {
                List<Object[]> cuotas = cuotaService.listarCuotasPorImpuesto(idImpuesto);

                response.setContentType("application/json;charset=UTF-8");

                int total = (cuotas == null) ? 0 : cuotas.size();

                StringBuilder json = new StringBuilder("[");
                if (cuotas != null) {
                    for (int i = 0; i < cuotas.size(); i++) {
                        Object[] c = cuotas.get(i);

                        // c[0]=numero, c[1]=vencimiento, c[2]=monto, c[3]=estado
                        String numero = safe(c, 0);
                        String venc = safe(c, 1);
                        String monto = safe(c, 2);
                        String estado = safe(c, 3);

                        json.append("{")
                                .append("\"numero\":\"").append(escapeJson(numero)).append("\",")
                                .append("\"total\":\"").append(total).append("\",")
                                .append("\"monto\":\"").append(escapeJson(monto)).append("\",")
                                .append("\"vencimiento\":\"").append(escapeJson(venc)).append("\",")
                                .append("\"estado\":\"").append(escapeJson(estado)).append("\"")
                                .append("}");

                        if (i < cuotas.size() - 1) json.append(",");
                    }
                }
                json.append("]");
                response.getWriter().write(json.toString());
                return;

            } catch (Exception e) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().write("{\"error\":\"No se pudo cargar el detalle\"}");
                return;
            }
        }

        // ✅ Lista principal (fraccionamientos agrupados)
        try {
            var lista = cuotaService.listarFraccionamientosAgrupados();
            request.setAttribute("lista", lista);
        } catch (Exception e) {
            request.setAttribute("lista", List.of());
            request.setAttribute("err", "No se pudo cargar la lista de fraccionamientos");
        }

        // ✅ Combo impuestos
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

                if (idImpuesto == null || idImpuesto <= 0 || numeroCuotas == null || numeroCuotas <= 0
                        || fechaStr == null || fechaStr.trim().isEmpty()) {
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
                        "err", "Error al crear fraccionamiento");
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

    private String safe(Object[] arr, int idx) {
        if (arr == null || idx < 0 || idx >= arr.length || arr[idx] == null) return "";
        return String.valueOf(arr[idx]);
    }
}