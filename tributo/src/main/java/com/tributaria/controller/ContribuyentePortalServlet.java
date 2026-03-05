package com.tributaria.controller;

import com.tributaria.entity.Usuario;
import com.tributaria.service.ContribuyentePortalService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@WebServlet({
        "/contribuyente/cuotas",
        "/contribuyente/pagos",
        "/contribuyente/bienes",
        "/contribuyente/perfil"
})
public class ContribuyentePortalServlet extends HttpServlet {

    private final ContribuyentePortalService portalService = new ContribuyentePortalService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Usuario usuario = session == null ? null : (Usuario) session.getAttribute("usuario");
        if (usuario == null || usuario.getPersona() == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int idPersona = usuario.getPersona().getIdPersona();
        String path = request.getServletPath();

        switch (path) {
            case "/contribuyente/cuotas":
                int detalleId = parseInt(request.getParameter("detalle"));
                if (detalleId > 0) {
                    if (cargarDetalleCuota(request, session, idPersona, detalleId)) {
                        request.getRequestDispatcher("/views/contribuyente/cuota/ver.jsp")
                                .forward(request, response);
                    } else {
                        response.sendRedirect(request.getContextPath() + "/contribuyente/cuotas");
                    }
                } else {
                    cargarVistaCuotas(request, idPersona);
                    request.getRequestDispatcher("/views/contribuyente/cuota/lista.jsp")
                            .forward(request, response);
                }
                return;
            case "/contribuyente/pagos":
                cargarVistaPagos(request, idPersona);
                request.getRequestDispatcher("/views/contribuyente/pago/lista.jsp")
                        .forward(request, response);
                return;
            case "/contribuyente/bienes":
                cargarVistaBienes(request, idPersona);
                request.getRequestDispatcher("/views/contribuyente/bien/lista.jsp")
                        .forward(request, response);
                return;
            case "/contribuyente/perfil":
                cargarVistaPerfil(request, idPersona, usuario);
                request.getRequestDispatcher("/views/contribuyente/perfil/index.jsp")
                        .forward(request, response);
                return;
            default:
                response.sendRedirect(request.getContextPath() + "/contribuyente/dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Usuario usuario = session == null ? null : (Usuario) session.getAttribute("usuario");
        if (usuario == null || usuario.getPersona() == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String path = request.getServletPath();
        String action = request.getParameter("action");

        if ("/contribuyente/pagos".equals(path)) {
            procesarPago(request, response, session, usuario, action);
            return;
        }

        if ("/contribuyente/perfil".equals(path)) {
            procesarPerfil(request, response, session, usuario, action);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/contribuyente/dashboard");
    }

    private void procesarPago(HttpServletRequest request,
                              HttpServletResponse response,
                              HttpSession session,
                              Usuario usuario,
                              String action) throws IOException {

        if (!"pagar".equalsIgnoreCase(action)) {
            response.sendRedirect(request.getContextPath() + "/contribuyente/pagos");
            return;
        }

        try {
            int idCuota = parseInt(request.getParameter("idCuota"));
            String metodoPago = request.getParameter("metodoPago");
            portalService.registrarPagoCuota(usuario.getPersona().getIdPersona(), idCuota, metodoPago);
            session.setAttribute("flashOk", "Pago registrado correctamente.");
        } catch (Exception ex) {
            session.setAttribute("flashError", ex.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/contribuyente/pagos");
    }

    private void procesarPerfil(HttpServletRequest request,
                                HttpServletResponse response,
                                HttpSession session,
                                Usuario usuario,
                                String action) throws IOException {

        try {
            if ("actualizar-datos".equalsIgnoreCase(action)) {
                String telefono = request.getParameter("telefono");
                String direccion = request.getParameter("direccion");
                portalService.actualizarDatosPerfil(usuario, telefono, direccion);
                session.setAttribute("flashOk", "Sus datos fueron actualizados.");
            } else if ("cambiar-password".equalsIgnoreCase(action)) {
                String passwordActual = request.getParameter("passwordActual");
                String nuevaPassword = request.getParameter("nuevaPassword");
                String confirmarPassword = request.getParameter("confirmarPassword");
                portalService.cambiarPasswordPerfil(usuario, passwordActual, nuevaPassword, confirmarPassword);
                session.setAttribute("flashOk", "Su contraseña fue actualizada.");
            } else {
                session.setAttribute("flashError", "Accion de perfil no valida.");
            }
        } catch (Exception ex) {
            session.setAttribute("flashError", ex.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/contribuyente/perfil");
    }

    private void cargarVistaCuotas(HttpServletRequest request, int idPersona) {
        List<Object[]> cuotas = portalService.listarCuotas(idPersona);
        int pendientes = 0;
        int pagadas = 0;

        for (Object[] cuota : cuotas) {
            String estado = texto(cuota, 8);
            if ("PAGADO".equalsIgnoreCase(estado)) {
                pagadas++;
            } else {
                pendientes++;
            }
        }

        request.setAttribute("items", cuotas);
        request.setAttribute("pendientes", pendientes);
        request.setAttribute("pagadas", pagadas);
    }

    private boolean cargarDetalleCuota(HttpServletRequest request, HttpSession session, int idPersona, int idFraccionamiento) {
        Object[] fraccionamiento = portalService.obtenerFraccionamiento(idPersona, idFraccionamiento);
        if (fraccionamiento == null) {
            session.setAttribute("flashError", "No se encontro el fraccionamiento solicitado.");
            return false;
        }

        request.setAttribute("fraccionamiento", fraccionamiento);
        request.setAttribute("cuotas", portalService.listarDetalleFraccionamiento(idPersona, idFraccionamiento));
        return true;
    }

    private void cargarVistaPagos(HttpServletRequest request, int idPersona) {
        List<Object[]> cuotas = portalService.listarCuotas(idPersona);
        List<Object[]> pagos = portalService.listarPagos(idPersona);
        List<Object[]> pendientes = new ArrayList<>();

        for (Object[] cuota : cuotas) {
            String estado = texto(cuota, 8);
            if (!"PAGADO".equalsIgnoreCase(estado)) {
                pendientes.add(cuota);
            }
        }

        request.setAttribute("pendingItems", pendientes);
        request.setAttribute("items", pagos);
        request.setAttribute("totalPendiente", portalService.sumarMontos(pendientes, 7));
        request.setAttribute("totalPagado", portalService.sumarMontos(pagos, 8));
    }

    private void cargarVistaBienes(HttpServletRequest request, int idPersona) {
        List<Object[]> inmuebles = portalService.listarInmuebles(idPersona);
        List<Object[]> vehiculos = portalService.listarVehiculos(idPersona);

        request.setAttribute("inmuebles", inmuebles);
        request.setAttribute("vehiculos", vehiculos);
        request.setAttribute("totalBienes", inmuebles.size() + vehiculos.size());
    }

    private void cargarVistaPerfil(HttpServletRequest request, int idPersona, Usuario usuario) {
        List<Object[]> inmuebles = portalService.listarInmuebles(idPersona);
        List<Object[]> vehiculos = portalService.listarVehiculos(idPersona);
        List<Object[]> pagos = portalService.listarPagos(idPersona);

        request.setAttribute("perfilUsuario", usuario);
        request.setAttribute("perfilInmuebles", inmuebles.size());
        request.setAttribute("perfilVehiculos", vehiculos.size());
        request.setAttribute("perfilCuotasPendientes", portalService.contarCuotasPendientes(idPersona));
        request.setAttribute("perfilPagos", pagos.size());
    }

    private String texto(Object[] row, int index) {
        if (row == null || index < 0 || index >= row.length || row[index] == null) {
            return "";
        }
        return row[index].toString().trim();
    }

    private int parseInt(String value) {
        if (value == null || value.isBlank()) {
            return -1;
        }
        try {
            return Integer.parseInt(value.trim());
        } catch (Exception ex) {
            return -1;
        }
    }
}
