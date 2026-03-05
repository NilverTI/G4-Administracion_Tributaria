package com.tributaria.controller;

import com.tributaria.service.UsuarioService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/registro")
public class RegistroServlet extends HttpServlet {

    private final UsuarioService usuarioService = new UsuarioService();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/views/auth/registro.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String correo = request.getParameter("correo");
        String password = request.getParameter("password");
        String confirmar = request.getParameter("confirmarPassword");

        try {
            usuarioService.registrarCuentaContribuyente(correo, password, confirmar);

            HttpSession session = request.getSession();
            session.setAttribute("flashOk",
                    "Cuenta creada correctamente. Ya puede iniciar sesion con su correo.");

            response.sendRedirect(request.getContextPath() + "/login");

        } catch (IllegalArgumentException | IllegalStateException ex) {

            request.setAttribute("error", ex.getMessage());
            request.setAttribute("correo", correo);
            request.getRequestDispatcher("/views/auth/registro.jsp")
                    .forward(request, response);
        } catch (Exception ex) {
            request.setAttribute("error", "No se pudo crear la cuenta. Intente nuevamente.");
            request.setAttribute("correo", correo);
            request.getRequestDispatcher("/views/auth/registro.jsp")
                    .forward(request, response);
        }
    }
}
