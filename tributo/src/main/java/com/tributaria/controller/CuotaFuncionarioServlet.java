package com.tributaria.controller;

import com.tributaria.service.FuncionarioCuotaService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;

@WebServlet("/funcionario/cuotas")
public class CuotaFuncionarioServlet extends HttpServlet {

    private final FuncionarioCuotaService cuotaService = new FuncionarioCuotaService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        if (action == null || action.isBlank()) {
            cargarVistaPrincipal(req);
            req.getRequestDispatcher("/views/funcionario/cuota/lista.jsp").forward(req, resp);
            return;
        }

        try {
            if ("crear".equalsIgnoreCase(action)) {
                req.setAttribute("impuestosActivos", cuotaService.listarImpuestosActivosFraccionables());
                req.setAttribute("preTipoImpuesto", nullToEmpty(req.getParameter("tipoImpuesto")).trim().toUpperCase());
                req.setAttribute("preIdReferencia", parseInt(req.getParameter("idReferencia"), 0));
                req.getRequestDispatcher("/views/funcionario/cuota/crear.jsp").forward(req, resp);
                return;
            }

            if ("ver".equalsIgnoreCase(action)) {
                int idFraccionamiento = parseInt(req.getParameter("id"), 0);
                if (idFraccionamiento <= 0) {
                    throw new IllegalArgumentException("Fraccionamiento invalido.");
                }

                Object[] fraccionamiento = cuotaService.obtenerFraccionamiento(idFraccionamiento);
                if (fraccionamiento == null) {
                    flashError(req, "No se encontro el fraccionamiento solicitado.");
                    resp.sendRedirect(req.getContextPath() + "/funcionario/cuotas");
                    return;
                }

                req.setAttribute("fraccionamiento", fraccionamiento);
                req.setAttribute("cuotas", cuotaService.listarCuotasPorFraccionamiento(idFraccionamiento));
                req.setAttribute("cuotaPagar", parseInt(req.getParameter("cuotaPagar"), 0));
                req.setAttribute("habilitadoPago", cuotaService.estaHabilitadoPagoFraccionamiento(idFraccionamiento));
                req.getRequestDispatcher("/views/funcionario/cuota/ver.jsp").forward(req, resp);
                return;
            }

            resp.sendRedirect(req.getContextPath() + "/funcionario/cuotas?tab=" + normalizeTab(req.getParameter("tab")));
        } catch (Exception e) {
            flashError(req, "No se pudo completar la operacion: " + extraerMensaje(e));
            resp.sendRedirect(req.getContextPath() + "/funcionario/cuotas?tab=" + normalizeTab(req.getParameter("tab")));
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        String action = nullToEmpty(req.getParameter("action")).trim();

        try {
            if ("crearFraccionamiento".equalsIgnoreCase(action)) {
                String tipoImpuesto = nullToEmpty(req.getParameter("tipoImpuesto")).trim().toUpperCase();
                int idReferencia = parseInt(req.getParameter("idReferencia"), 0);
                int mesesPorCuota = parseInt(req.getParameter("mesesPorCuota"), 0);

                cuotaService.crearFraccionamiento(tipoImpuesto, idReferencia, mesesPorCuota);
                flashOk(req, "Fraccionamiento creado correctamente.");
                resp.sendRedirect(req.getContextPath() + "/funcionario/cuotas?tab=cuotas");
                return;
            }

            if ("registrarPagoCuota".equalsIgnoreCase(action)) {
                int idCuota = parseInt(req.getParameter("idCuota"), 0);
                BigDecimal montoPagado = new BigDecimal(nullToEmpty(req.getParameter("montoPagado")).trim());
                LocalDate fechaPago = LocalDate.parse(nullToEmpty(req.getParameter("fechaPago")).trim());
                String metodoPago = nullToEmpty(req.getParameter("metodoPago")).trim();
                String observacion = nullToEmpty(req.getParameter("observacionPago")).trim();
                String detallePago = construirDetallePago(metodoPago, observacion);

                int idFraccionamiento = cuotaService.registrarPagoCuota(idCuota, montoPagado, fechaPago, detallePago);
                flashOk(req, "Pago registrado correctamente.");
                resp.sendRedirect(req.getContextPath() + "/funcionario/cuotas?action=ver&id=" + idFraccionamiento);
                return;
            }

            resp.sendRedirect(req.getContextPath() + "/funcionario/cuotas");
        } catch (Exception e) {
            flashError(req, "No se pudo guardar la operacion: " + extraerMensaje(e));

            if ("registrarPagoCuota".equalsIgnoreCase(action)) {
                int idFraccionamiento = parseInt(req.getParameter("idFraccionamiento"), 0);
                int idCuota = parseInt(req.getParameter("idCuota"), 0);
                if (idFraccionamiento > 0) {
                    String redirect = req.getContextPath() + "/funcionario/cuotas?action=ver&id=" + idFraccionamiento;
                    if (idCuota > 0) {
                        redirect += "&cuotaPagar=" + idCuota;
                    }
                    resp.sendRedirect(redirect);
                    return;
                }
            }

            if ("crearFraccionamiento".equalsIgnoreCase(action)) {
                String tipoImpuesto = nullToEmpty(req.getParameter("tipoImpuesto")).trim().toUpperCase();
                int idReferencia = parseInt(req.getParameter("idReferencia"), 0);
                resp.sendRedirect(req.getContextPath()
                        + "/funcionario/cuotas?action=crear&tipoImpuesto=" + tipoImpuesto
                        + "&idReferencia=" + idReferencia);
                return;
            }

            resp.sendRedirect(req.getContextPath() + "/funcionario/cuotas");
        }
    }

    private void cargarVistaPrincipal(HttpServletRequest req) {
        req.setAttribute("activeTab", normalizeTab(req.getParameter("tab")));
        boolean mostrarHistoricosFracc = "1".equals(nullToEmpty(req.getParameter("historicosFracc")).trim());
        boolean mostrarHistoricosPagos = "1".equals(nullToEmpty(req.getParameter("historicosPagos")).trim());

        req.setAttribute("mostrarHistoricosFracc", mostrarHistoricosFracc);
        req.setAttribute("mostrarHistoricosPagos", mostrarHistoricosPagos);
        req.setAttribute("fraccionamientos", cuotaService.listarFraccionamientos(mostrarHistoricosFracc));
        req.setAttribute("cuotasPendientes", cuotaService.listarCuotasPendientes(mostrarHistoricosPagos));
    }

    private String normalizeTab(String tab) {
        if ("pagos".equalsIgnoreCase(tab)) {
            return "pagos";
        }
        return "cuotas";
    }

    private void flashOk(HttpServletRequest req, String message) {
        req.getSession().setAttribute("flashOk", message);
    }

    private void flashError(HttpServletRequest req, String message) {
        req.getSession().setAttribute("flashError", message);
    }

    private String nullToEmpty(String value) {
        return value == null ? "" : value;
    }

    private int parseInt(String value, int fallback) {
        if (value == null || value.isBlank()) {
            return fallback;
        }
        try {
            return Integer.parseInt(value.trim());
        } catch (Exception ignored) {
            return fallback;
        }
    }

    private String extraerMensaje(Exception e) {
        Throwable cause = e;
        while (cause.getCause() != null) {
            cause = cause.getCause();
        }

        String msg = cause.getMessage();
        if (msg == null || msg.isBlank()) {
            return e.getClass().getSimpleName();
        }
        return msg;
    }

    private String construirDetallePago(String metodoPago, String observacion) {
        String metodo = (metodoPago == null || metodoPago.isBlank())
                ? "No especificado"
                : metodoPago.trim();

        String detalle = observacion == null ? "" : observacion.trim();
        if (detalle.isBlank()) {
            return "Metodo: " + metodo;
        }
        return "Metodo: " + metodo + " | " + detalle;
    }
}
