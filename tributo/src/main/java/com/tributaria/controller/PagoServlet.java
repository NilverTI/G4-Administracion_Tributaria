package com.tributaria.controller;

import java.io.IOException;

import com.tributaria.entity.Cuota;
import com.tributaria.entity.Pago;
import com.tributaria.service.CuotaService;
import com.tributaria.service.PagoService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/funcionario/pago")
public class PagoServlet extends HttpServlet {

    private final PagoService pagoService = new PagoService();
    private final CuotaService cuotaService = new CuotaService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("lista", pagoService.listar());
        request.setAttribute("cuotas", cuotaService.listarPendientes());

        request.setAttribute("err", request.getParameter("err"));
        request.setAttribute("ok", request.getParameter("ok"));

        request.getRequestDispatcher("/views/funcionario/pago/lista.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idCuotaStr = request.getParameter("idCuota");
        String medioPago = request.getParameter("medioPago");

        // Validación mínima
        if (isBlank(idCuotaStr) || isBlank(medioPago)) {
            response.sendRedirect(request.getContextPath() + "/funcionario/pago?err=Campos%20incompletos");
            return;
        }

        int idCuota;
        try {
            idCuota = Integer.parseInt(idCuotaStr.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/funcionario/pago?err=Cuota%20inv%C3%A1lida");
            return;
        }

        Cuota cuota = cuotaService.buscarPorId(idCuota);
        if (cuota == null) {
            response.sendRedirect(request.getContextPath() + "/funcionario/pago?err=La%20cuota%20no%20existe");
            return;
        }

        // Evitar volver a pagar
        String est = (cuota.getEstado() == null) ? "" : cuota.getEstado().trim().toUpperCase();
        if ("PAGADO".equals(est) || "PAGADA".equals(est)) {
            response.sendRedirect(request.getContextPath() + "/funcionario/pago?err=La%20cuota%20ya%20est%C3%A1%20pagada");
            return;
        }

        Pago pago = new Pago();
        pago.setCuota(cuota);
        pago.setMonto(cuota.getMonto());
        pago.setMedioPago(medioPago.trim().toUpperCase());

        try {
            pagoService.registrar(pago);
            response.sendRedirect(request.getContextPath() + "/funcionario/pago?ok=Pago%20registrado");
        } catch (Exception ex) {
            response.sendRedirect(request.getContextPath() + "/funcionario/pago?err=Error%20al%20registrar%20pago");
        }
    }

    private boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }
}