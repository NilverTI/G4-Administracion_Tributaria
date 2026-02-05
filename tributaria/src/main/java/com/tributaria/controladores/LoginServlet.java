package com.tributaria.controladores;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

import com.tributaria.Negocio.LoginService;
import com.tributaria.model.Usuario;

@WebServlet("/login")   // ← IMPORTANTE
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.sendRedirect("login.jsp");  
    }


    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String user = req.getParameter("usuario");
        String pass = req.getParameter("password");

        try {
            LoginService service = new LoginService();
            Usuario u = service.login(user, pass);

            if (u != null) {

                HttpSession session = req.getSession();
                session.setAttribute("usuarioLogeado", u);

                // Redirección por tipo de rol
                if (u.getIdRol() == 1) {
                    resp.sendRedirect("views/panelFuncionario.jsp");
                } 
                else if (u.getIdRol() == 2) {
                    resp.sendRedirect("views/panelContribuyente.jsp");
                } 
                else {
                    resp.sendRedirect("login.jsp?error=rol");
                }

            } else {
                resp.sendRedirect("login.jsp?error=credenciales");
            }

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("login.jsp?error=500");
        }
    }
}
