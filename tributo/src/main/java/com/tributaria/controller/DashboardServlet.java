package com.tributaria.controller;

import java.io.IOException;

import com.tributaria.service.FuncionarioDashboardService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/funcionario/dashboard")
public class DashboardServlet extends HttpServlet {

    private final FuncionarioDashboardService dashboardService = new FuncionarioDashboardService();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("dashboard", dashboardService.obtenerResumen());

        request.getRequestDispatcher(
                "/views/funcionario/dashboard/index.jsp"
        ).forward(request, response);
    }
}
