package com.tributaria.controller;

import com.tributaria.service.ContribuyenteService;
import com.tributaria.service.VehiculoService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/funcionario/vehiculo")
public class VehiculoServlet extends HttpServlet {

    private final VehiculoService vehiculoServ = new VehiculoService();
    private final ContribuyenteService contribServ = new ContribuyenteService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        try {
            if ("estado".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                String estado = nullToEmpty(req.getParameter("estado")).trim().toUpperCase();

                if (!"ACTIVO".equals(estado) && !"INACTIVO".equals(estado)) {
                    throw new IllegalArgumentException("Estado de vehiculo invalido.");
                }

                vehiculoServ.cambiarEstado(id, estado);
                flashOk(req, "Estado de vehiculo actualizado a " + estado + ".");
                resp.sendRedirect(req.getContextPath() + "/funcionario/vehiculo");
                return;
            }

            if ("ver".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                Object[] vehiculo = vehiculoServ.obtenerDetallePorId(id);
                if (vehiculo == null) {
                    flashError(req, "No se encontro el vehiculo.");
                    resp.sendRedirect(req.getContextPath() + "/funcionario/vehiculo");
                    return;
                }

                req.setAttribute("vehiculo", vehiculo);
                req.getRequestDispatcher("/views/funcionario/vehiculo/ver.jsp").forward(req, resp);
                return;
            }

            if ("editar".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                Object[] vehiculo = vehiculoServ.obtenerEditablePorId(id);
                if (vehiculo == null) {
                    flashError(req, "No se encontro el vehiculo.");
                    resp.sendRedirect(req.getContextPath() + "/funcionario/vehiculo");
                    return;
                }

                req.setAttribute("vehiculo", vehiculo);
                req.setAttribute("contribuyentes", contribServ.listarActivosCombo());
                req.getRequestDispatcher("/views/funcionario/vehiculo/editar.jsp").forward(req, resp);
                return;
            }

            List<Object[]> lista = vehiculoServ.listar();
            req.setAttribute("lista", lista);
            req.setAttribute("cantidad", lista.size());
            req.setAttribute("contribuyentes", contribServ.listarActivosCombo());
            req.getRequestDispatcher("/views/funcionario/vehiculo/lista.jsp").forward(req, resp);
        } catch (Exception e) {
            flashError(req, "No se pudo completar la operacion: " + extraerMensaje(e));
            resp.sendRedirect(req.getContextPath() + "/funcionario/vehiculo");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        String action = nullToEmpty(req.getParameter("action")).trim();

        try {
            if ("editar".equals(action)) {
                int idVehiculo = Integer.parseInt(req.getParameter("idVehiculo"));
                int idContribuyente = Integer.parseInt(req.getParameter("idContribuyente"));
                String placa = nullToEmpty(req.getParameter("placa")).trim().toUpperCase();
                String marca = nullToEmpty(req.getParameter("marca")).trim();
                String modelo = nullToEmpty(req.getParameter("modelo")).trim();
                int anio = Integer.parseInt(req.getParameter("anio"));
                String fechaInscripcion = nullToEmpty(req.getParameter("fechaInscripcion")).trim();
                BigDecimal valor = new BigDecimal(req.getParameter("valor"));

                if (placa.isBlank() || marca.isBlank() || modelo.isBlank() || fechaInscripcion.isBlank()) {
                    throw new IllegalArgumentException("Todos los datos del vehiculo son obligatorios.");
                }
                if (anio < 1900 || anio > 2100) {
                    throw new IllegalArgumentException("El anio del vehiculo no es valido.");
                }
                if (valor.compareTo(BigDecimal.ZERO) < 0) {
                    throw new IllegalArgumentException("El valor del vehiculo no puede ser negativo.");
                }

                vehiculoServ.actualizarDatosCompletos(
                        idVehiculo,
                        idContribuyente,
                        placa,
                        marca,
                        modelo,
                        anio,
                        fechaInscripcion,
                        valor
                );

                flashOk(req, "Vehiculo actualizado correctamente.");
                resp.sendRedirect(req.getContextPath() + "/funcionario/vehiculo");
                return;
            }

            int idContribuyente = Integer.parseInt(req.getParameter("idContribuyente"));
            String placa = req.getParameter("placa");
            String marca = req.getParameter("marca");
            String modelo = req.getParameter("modelo");
            int anio = Integer.parseInt(req.getParameter("anio"));
            String fechaInscripcion = req.getParameter("fechaInscripcion");
            BigDecimal valor = new BigDecimal(req.getParameter("valor"));

            int anioInscripcion = Integer.parseInt(fechaInscripcion.substring(0, 4));
            BigDecimal porcentaje = vehiculoServ.porcentajePorAnio(anioInscripcion);

            vehiculoServ.crear(
                    idContribuyente,
                    placa,
                    marca,
                    modelo,
                    anio,
                    fechaInscripcion,
                    valor,
                    porcentaje
            );

            flashOk(req, "Vehiculo registrado correctamente.");
        } catch (Exception e) {
            flashError(req, "No se pudo guardar el vehiculo: " + extraerMensaje(e));
            if ("editar".equals(action)) {
                String idVehiculo = nullToEmpty(req.getParameter("idVehiculo")).trim();
                if (!idVehiculo.isBlank()) {
                    resp.sendRedirect(req.getContextPath() + "/funcionario/vehiculo?action=editar&id=" + idVehiculo);
                    return;
                }
            }
        }

        resp.sendRedirect(req.getContextPath() + "/funcionario/vehiculo");
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

    private String extraerMensaje(Exception e) {
        Throwable cause = e;
        while (cause.getCause() != null) {
            cause = cause.getCause();
        }
        if (cause.getMessage() == null || cause.getMessage().isBlank()) {
            return e.getClass().getSimpleName();
        }
        return cause.getMessage();
    }
}
