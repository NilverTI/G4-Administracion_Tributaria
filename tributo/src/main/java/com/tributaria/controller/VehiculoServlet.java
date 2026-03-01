package com.tributaria.controller;

import com.tributaria.service.VehiculoService;
import com.tributaria.service.ContribuyenteService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/funcionario/vehiculo")
public class VehiculoServlet extends HttpServlet {

    private VehiculoService vehiculoServ = new VehiculoService();
    private ContribuyenteService contribServ = new ContribuyenteService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        if ("estado".equals(action)) {

            int id = Integer.parseInt(req.getParameter("id"));
            String estado = req.getParameter("estado");

            vehiculoServ.cambiarEstado(id, estado);

            resp.sendRedirect(req.getContextPath() + "/funcionario/vehiculo");
            return;
        }

        req.setAttribute("lista", vehiculoServ.listar());

        req.setAttribute("contribuyentes", contribServ.listarActivosCombo());

        req.getRequestDispatcher("/views/funcionario/vehiculo/lista.jsp")
                .forward(req, resp);

    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        int idContribuyente = Integer.parseInt(req.getParameter("idContribuyente"));
        String placa = req.getParameter("placa");
        String marca = req.getParameter("marca");
        String modelo = req.getParameter("modelo");
        int anio = Integer.parseInt(req.getParameter("anio"));
        String fechaInscripcion = req.getParameter("fechaInscripcion");
        BigDecimal valor = new BigDecimal(req.getParameter("valor"));

        // 🔥 Tomar AÑO de la fecha de inscripción
        int anioInscripcion = Integer.parseInt(fechaInscripcion.substring(0, 4));

        // 🔥 Obtener porcentaje según configuraciones
        BigDecimal porcentaje = vehiculoServ.porcentajePorAnio(anioInscripcion);

        vehiculoServ.crear(
                idContribuyente,
                placa,
                marca,
                modelo,
                anio,
                fechaInscripcion,
                valor,
                porcentaje);

        resp.sendRedirect(req.getContextPath() + "/funcionario/vehiculo");
    }

    

}