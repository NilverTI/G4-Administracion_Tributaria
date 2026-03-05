package com.tributaria.controller;

import com.tributaria.entity.Usuario;
import com.tributaria.service.UITService;
import com.tributaria.service.UsuarioService;
import com.tributaria.service.VehicularConfigService;
import com.tributaria.service.ZonaService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/funcionario/configuracion")
public class ConfiguracionServlet extends HttpServlet {

    private final ZonaService zonaServ = new ZonaService();
    private final UITService uitServ = new UITService();
    private final VehicularConfigService vehServ = new VehicularConfigService();
    private final UsuarioService usuarioServ = new UsuarioService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!esAdmin(req)) {
            resp.sendRedirect(req.getContextPath() + "/funcionario/dashboard");
            return;
        }

        String action = safe(req.getParameter("action"));
        String tab = normalizeTab(req.getParameter("tab"));

        if (action.isBlank()) {
            req.setAttribute("activeTab", tab);
            cargarConfiguracion(req);
            req.getRequestDispatcher("/views/funcionario/configuracion/index.jsp").forward(req, resp);
            return;
        }

        try {
            switch (action) {
                case "zonas.estado": {
                    int idZona = Integer.parseInt(req.getParameter("id"));
                    String estado = req.getParameter("estado");
                    zonaServ.cambiarEstado(idZona, estado);
                    flashOk(req, "Estado de zona actualizado.");
                    break;
                }
                case "uit.update": {
                    int anio = Integer.parseInt(req.getParameter("anio"));
                    double valor = Double.parseDouble(req.getParameter("valor"));
                    uitServ.actualizar(anio, valor);
                    flashOk(req, "UIT actualizada correctamente.");
                    break;
                }
                case "veh.estado": {
                    int anio = Integer.parseInt(req.getParameter("anio"));
                    String estado = req.getParameter("estado");
                    vehServ.cambiarEstado(anio, estado);
                    flashOk(req, "Estado vehicular actualizado.");
                    break;
                }
                default:
                    break;
            }
        } catch (Exception e) {
            flashError(req, "No se pudo completar la operacion: " + extraerMensaje(e));
        }

        resp.sendRedirect(req.getContextPath() + "/funcionario/configuracion?tab=" + resolveTabByAction(action, tab));
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        if (!esAdmin(req)) {
            resp.sendRedirect(req.getContextPath() + "/funcionario/dashboard");
            return;
        }

        String action = safe(req.getParameter("action"));
        String tab = normalizeTab(req.getParameter("tab"));

        try {
            switch (action) {
                case "zonas.crear":
                    zonaServ.crear(
                            req.getParameter("codigo"),
                            req.getParameter("nombre"),
                            Double.parseDouble(req.getParameter("tasa"))
                    );
                    flashOk(req, "Zona registrada correctamente.");
                    break;

                case "uit.crear":
                    uitServ.crear(
                            Integer.parseInt(req.getParameter("anio")),
                            Double.parseDouble(req.getParameter("valor"))
                    );
                    flashOk(req, "UIT registrada correctamente.");
                    break;

                case "uit.update":
                    uitServ.actualizar(
                            Integer.parseInt(req.getParameter("anio")),
                            Double.parseDouble(req.getParameter("valor"))
                    );
                    flashOk(req, "UIT actualizada correctamente.");
                    break;

                case "veh.crear":
                    vehServ.crear(
                            Integer.parseInt(req.getParameter("anio")),
                            Double.parseDouble(req.getParameter("porcentaje"))
                    );
                    flashOk(req, "Porcentaje vehicular registrado.");
                    break;
                case "func.crear":
                    usuarioServ.registrarCuentaFuncionario(
                            req.getParameter("correo"),
                            req.getParameter("password"),
                            req.getParameter("confirmarPassword")
                    );
                    flashOk(req, "Funcionario creado correctamente.");
                    break;
                default:
                    break;
            }
        } catch (Exception e) {
            flashError(req, "No se pudo guardar la operacion: " + extraerMensaje(e));
        }

        resp.sendRedirect(req.getContextPath() + "/funcionario/configuracion?tab=" + resolveTabByAction(action, tab));
    }

    private void cargarConfiguracion(HttpServletRequest req) {
        req.setAttribute("zonas", zonaServ.listar());
        req.setAttribute("uits", uitServ.listar());
        req.setAttribute("vehiculares", vehServ.listar());
        req.setAttribute("personasFuncionarios", usuarioServ.listarPersonasDisponiblesParaFuncionario());
    }

    private String normalizeTab(String tab) {
        String value = safe(tab).toLowerCase();
        if ("zonas".equals(value) || "uit".equals(value) || "veh".equals(value)) {
            return value;
        }
        return "zonas";
    }

    private String resolveTabByAction(String action, String fallbackTab) {
        String value = safe(action).toLowerCase();
        if (value.startsWith("zonas.")) {
            return "zonas";
        }
        if (value.startsWith("uit.")) {
            return "uit";
        }
        if (value.startsWith("veh.")) {
            return "veh";
        }
        if (value.startsWith("func.")) {
            return "zonas";
        }
        return normalizeTab(fallbackTab);
    }

    private boolean esAdmin(HttpServletRequest req) {
        Object usuarioSesion = req.getSession(false) == null ? null : req.getSession(false).getAttribute("usuario");
        if (!(usuarioSesion instanceof Usuario)) {
            return false;
        }

        Usuario usuario = (Usuario) usuarioSesion;
        return usuario.getRol() != null && "ADMIN".equalsIgnoreCase(usuario.getRol().getNombre());
    }

    private String safe(String value) {
        return value == null ? "" : value.trim();
    }

    private void flashOk(HttpServletRequest req, String message) {
        req.getSession().setAttribute("flashOk", message);
    }

    private void flashError(HttpServletRequest req, String message) {
        req.getSession().setAttribute("flashError", message);
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
}
