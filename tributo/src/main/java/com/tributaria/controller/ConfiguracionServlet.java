package com.tributaria.controller;

import com.tributaria.service.ConfiguracionService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/funcionario/configuracion")
public class ConfiguracionServlet extends HttpServlet {

    private final ConfiguracionService configServ = new ConfiguracionService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        // DEFAULT → mostrar vista con datos
        if (action == null) {
            cargarConfiguracion(req);
            // ✅ tu vista real es lista.jsp (según tu estructura)
            req.getRequestDispatcher("/views/funcionario/configuracion/lista.jsp")
                    .forward(req, resp);
            return;
        }

        switch (action) {

            // ==========================
            //        Z O N A S
            // ==========================
            case "zonas.list":
                // solo refresca
                break;

            case "zonas.estado": {
                int idZ = Integer.parseInt(req.getParameter("id"));
                String estZ = req.getParameter("estado");
                configServ.cambiarEstadoZona(idZ, estZ);
                break;
            }

            // ==========================
            //  V E H I C U L A R   %
            // ==========================
            case "veh.estado": {
                // en tu JSP el parámetro se llama "anio"
                int anioV = Integer.parseInt(req.getParameter("anio"));
                String estV = req.getParameter("estado");
                configServ.cambiarEstadoVehicularConfig(anioV, estV);
                break;
            }

            default:
                break;
        }

        resp.sendRedirect(req.getContextPath() + "/funcionario/configuracion");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        String action = req.getParameter("action");

        if (action == null) {
            resp.sendRedirect(req.getContextPath() + "/funcionario/configuracion");
            return;
        }

        switch (action) {

            // ==========================
            //        Z O N A S
            // ==========================
            case "zonas.crear":
                configServ.crearZona(
                        req.getParameter("codigo"),
                        req.getParameter("nombre"),
                        Double.parseDouble(req.getParameter("tasa"))
                );
                break;

            // ==========================
            //          U I T
            // ==========================
            case "uit.crear":
                configServ.crearUIT(
                        Integer.parseInt(req.getParameter("anio")),
                        Double.parseDouble(req.getParameter("valor"))
                );
                break;

            case "uit.update":
                // ✅ esto llega por POST desde tu modal de editar UIT
                configServ.actualizarUIT(
                        Integer.parseInt(req.getParameter("anio")),
                        Double.parseDouble(req.getParameter("valor"))
                );
                break;

            // ==========================
            //  V E H I C U L A R   %
            // ==========================
            case "veh.crear":
                configServ.crearVehicularConfig(
                        Integer.parseInt(req.getParameter("anio")),
                        Double.parseDouble(req.getParameter("porcentaje"))
                );
                break;

            default:
                break;
        }

        resp.sendRedirect(req.getContextPath() + "/funcionario/configuracion");
    }

    private void cargarConfiguracion(HttpServletRequest req) {
        req.setAttribute("zonas", configServ.listarZonas());
        req.setAttribute("uits", configServ.listarUIT());
        req.setAttribute("vehiculares", configServ.listarVehicularConfig());
    }
}