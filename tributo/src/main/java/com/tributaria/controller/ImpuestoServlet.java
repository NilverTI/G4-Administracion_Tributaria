package com.tributaria.controller;

import com.tributaria.dao.ImpuestoDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

@WebServlet("/funcionario/impuesto")
public class ImpuestoServlet extends HttpServlet {

    private final ImpuestoDAO dao = new ImpuestoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = nvl(request.getParameter("action")).trim();

        // ✅ AJAX: cuotas en JSON
        if ("cuotas".equalsIgnoreCase(action)) {
            writeCuotasJson(request, response);
            return;
        }

        // ✅ LISTAR IMPUESTOS
        try {
            List<Object[]> lista = dao.listarImpuestos();
            request.setAttribute("lista", lista);
        } catch (Exception e) {
            request.setAttribute("lista", List.of());
            request.setAttribute("err", "No se pudo listar impuestos");
        }

        // ✅ COMBO contribuyentes
        try {
            List<Object[]> contribuyentes = dao.listarContribuyentesCombo();
            request.setAttribute("contribuyentes", contribuyentes);
        } catch (Exception e) {
            request.setAttribute("contribuyentes", List.of());
            request.setAttribute("err", "No se pudo cargar contribuyentes");
        }

        // mensajes flash por querystring
        if (request.getParameter("err") != null) request.setAttribute("err", request.getParameter("err"));
        if (request.getParameter("ok") != null) request.setAttribute("ok", request.getParameter("ok"));

        // ✅ ESTA ES TU RUTA REAL (según tu proyecto)
        request.getRequestDispatcher("/views/funcionario/impuestos/lista.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = nvl(request.getParameter("action")).trim();

        if ("generar".equalsIgnoreCase(action)) {
            handleGenerar(request, response);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/funcionario/impuesto");
    }

    // =========================
    // Generar impuesto (POST)
    // =========================
    private void handleGenerar(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            String idContribuyenteStr = request.getParameter("idContribuyente");
            String tipo = request.getParameter("tipo");
            String anioStr = request.getParameter("anio");

            if (isBlank(idContribuyenteStr) || isBlank(tipo) || isBlank(anioStr)) {
                redirectErr(request, response, "Campos incompletos");
                return;
            }

            int idContribuyente = Integer.parseInt(idContribuyenteStr.trim());
            int anio = Integer.parseInt(anioStr.trim());

            if (anio < 2000 || anio > 2100) {
                redirectErr(request, response, "Año inválido");
                return;
            }

            String tipoNorm = normalizeTipo(tipo);
            if (tipoNorm == null) {
                redirectErr(request, response, "Tipo inválido");
                return;
            }

            dao.generarImpuesto(idContribuyente, tipoNorm, anio);

            redirectOk(request, response, "Impuesto generado");
        } catch (NumberFormatException ex) {
            redirectErr(request, response, "Datos inválidos");
        } catch (Exception ex) {
            redirectErr(request, response, "Error al generar");
        }
    }

    private String normalizeTipo(String tipo) {
        if (tipo == null) return null;
        String t = tipo.trim().toUpperCase();
        return switch (t) {
            case "PREDIAL", "VEHICULAR", "ALCABALA" -> t;
            default -> null;
        };
    }

    // =========================
    // Cuotas JSON (GET)
    // =========================
    private void writeCuotasJson(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        String idStr = request.getParameter("id");
        if (isBlank(idStr)) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().print("[]");
            return;
        }

        int idImpuesto;
        try {
            idImpuesto = Integer.parseInt(idStr.trim());
        } catch (NumberFormatException ex) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().print("[]");
            return;
        }

        try (PrintWriter out = response.getWriter()) {
            List<Object[]> cuotas = dao.listarCuotasPorImpuesto(idImpuesto);

            // Esperado: (numero, vencimiento, monto, estado)
            out.print("[");
            for (int i = 0; i < cuotas.size(); i++) {
                Object[] c = cuotas.get(i);

                String numero = safe(c, 0);
                String venc = safe(c, 1);
                String monto = safe(c, 2);
                String estado = safe(c, 3);

                out.print("{");
                out.print("\"numero\":\"" + escapeJson(numero) + "\",");
                out.print("\"vencimiento\":\"" + escapeJson(venc) + "\",");
                out.print("\"monto\":\"" + escapeJson(monto) + "\",");
                out.print("\"estado\":\"" + escapeJson(estado) + "\"");
                out.print("}");

                if (i < cuotas.size() - 1) out.print(",");
            }
            out.print("]");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().print("[]");
        }
    }

    private String safe(Object[] arr, int idx) {
        if (arr == null || idx < 0 || idx >= arr.length || arr[idx] == null) return "";
        return String.valueOf(arr[idx]);
    }

    // =========================
    // Helpers
    // =========================
    private boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }

    private String nvl(String s) {
        return s == null ? "" : s;
    }

    private void redirectErr(HttpServletRequest request, HttpServletResponse response, String msg) throws IOException {
        String q = URLEncoder.encode(msg, StandardCharsets.UTF_8);
        response.sendRedirect(request.getContextPath() + "/funcionario/impuesto?err=" + q);
    }

    private void redirectOk(HttpServletRequest request, HttpServletResponse response, String msg) throws IOException {
        String q = URLEncoder.encode(msg, StandardCharsets.UTF_8);
        response.sendRedirect(request.getContextPath() + "/funcionario/impuesto?ok=" + q);
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r");
    }
}