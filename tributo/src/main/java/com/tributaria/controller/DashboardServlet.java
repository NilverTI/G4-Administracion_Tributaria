package com.tributaria.controller;

import java.io.IOException;

import com.tributaria.service.ContribuyenteService;
import com.tributaria.service.InmuebleService;
import com.tributaria.service.VehiculoService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/funcionario/dashboard")
public class DashboardServlet extends HttpServlet {

    private ContribuyenteService service = new ContribuyenteService();
    private InmuebleService inmuebleService = new InmuebleService();
    private VehiculoService vehiculoService = new VehiculoService();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        // 🔹 Contribuyentes (YA EXISTENTE)
        int total = service.contar();
        int activos = service.contarActivos();

        request.setAttribute("totalContribuyentes", total);
        request.setAttribute("totalActivos", activos);

        // 🔹 NUEVO: Inmuebles
        int totalInmuebles = inmuebleService.contar();
        request.setAttribute("totalInmuebles", totalInmuebles);

        // 🔹 NUEVO: Vehículos
        int totalVehiculos = vehiculoService.contar();
        request.setAttribute("totalVehiculos", totalVehiculos);

        // 🔹 Enviar al JSP
        request.getRequestDispatcher(
                "/views/funcionario/dashboard/index.jsp"
        ).forward(request, response);
    }
}