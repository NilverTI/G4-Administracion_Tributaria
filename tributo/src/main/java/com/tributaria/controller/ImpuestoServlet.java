package com.tributaria.controller;

import com.tributaria.service.ContribuyenteService;
import com.tributaria.service.FuncionarioCuotaService;
import com.tributaria.service.ImpuestoService;
import com.tributaria.service.VehiculoService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

@WebServlet("/funcionario/impuesto")
public class ImpuestoServlet extends HttpServlet {

    private static final int EDAD_LIMITE_PREDIAL = 60;

    private final ImpuestoService impServ = new ImpuestoService();
    private final VehiculoService vehServ = new VehiculoService();
    private final ContribuyenteService contribServ = new ContribuyenteService();
    private final FuncionarioCuotaService cuotaServ = new FuncionarioCuotaService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        if (action == null || action.isBlank()) {
            cargarVistaPrincipal(req);
            req.getRequestDispatcher("/views/funcionario/impuesto/lista.jsp").forward(req, resp);
            return;
        }

        try {
            switch (action) {
                case "vehicular":
                    req.setAttribute("vehiculos", listarVehiculosDisponibles());
                    req.getRequestDispatcher("/views/funcionario/impuesto/asignar-vehicular.jsp").forward(req, resp);
                    return;

                case "predial":
                    req.setAttribute("inmuebles", impServ.listarInmueblesPredialDisponibles());
                    req.getRequestDispatcher("/views/funcionario/impuesto/asignar-predial.jsp").forward(req, resp);
                    return;

                case "ver": {
                    int id = Integer.parseInt(req.getParameter("id"));
                    List<Object[]> detalle = impServ.listarDetalle(id);
                    Object[] impuesto = impServ.obtenerPorId(id);
                    String estadoPago = cuotaServ.estadoPagoVehicularFuncionario(id, detalle);
                    req.setAttribute("imp", impuesto);
                    req.setAttribute("detalle", detalle);
                    req.setAttribute("estadoPagoGeneral", estadoPago);
                    req.setAttribute("estadoVehiculo", obtenerEstadoVehiculoPorPlaca(texto(valorEn(impuesto, 2))));
                    req.setAttribute("puedeGenerarCuotas", cuotaServ.puedeCrearFraccionamientoVehicular(id));
                    req.getRequestDispatcher("/views/funcionario/impuesto/ver.jsp").forward(req, resp);
                    return;
                }

                case "verPredial": {
                    int id = Integer.parseInt(req.getParameter("id"));
                    req.setAttribute("predial", impServ.obtenerPredialPorId(id));
                    req.setAttribute("historial", impServ.listarHistorialPredial(id));
                    req.getRequestDispatcher("/views/funcionario/impuesto/ver-predial.jsp").forward(req, resp);
                    return;
                }

                case "verAlcabala": {
                    int id = Integer.parseInt(req.getParameter("id"));
                    req.setAttribute("alcabala", impServ.obtenerAlcabalaPorId(id));
                    req.getRequestDispatcher("/views/funcionario/impuesto/ver-alcabala.jsp").forward(req, resp);
                    return;
                }

                case "vehicular.estado": {
                    int idVehiculo = Integer.parseInt(req.getParameter("idVehiculo"));
                    String estado = nullToEmpty(req.getParameter("estado")).trim().toUpperCase();

                    if (!"ACTIVO".equals(estado) && !"INACTIVO".equals(estado)) {
                        throw new IllegalArgumentException("Estado de vehiculo invalido.");
                    }

                    vehServ.cambiarEstado(idVehiculo, estado);
                    flashOk(req, "Estado del vehiculo actualizado a " + estado + ".");
                    resp.sendRedirect(req.getContextPath() + "/funcionario/impuesto?tab=vehicular");
                    return;
                }

                case "vehicular.editar": {
                    int idVehiculo = Integer.parseInt(req.getParameter("idVehiculo"));
                    Object[] vehiculoEdit = vehServ.obtenerEditablePorId(idVehiculo);
                    if (vehiculoEdit == null) {
                        flashError(req, "No se encontro el vehiculo solicitado.");
                        resp.sendRedirect(req.getContextPath() + "/funcionario/impuesto?tab=vehicular");
                        return;
                    }

                    req.setAttribute("vehiculoEdit", vehiculoEdit);
                    req.getRequestDispatcher("/views/funcionario/impuesto/editar-vehicular.jsp").forward(req, resp);
                    return;
                }

                case "predial.estado.rapido": {
                    int idPredial = Integer.parseInt(req.getParameter("idPredial"));
                    String estado = nullToEmpty(req.getParameter("estado")).trim().toUpperCase();

                    if (!"ACTIVO".equals(estado) && !"SUSPENDIDO".equals(estado) && !"CERRADO".equals(estado)) {
                        throw new IllegalArgumentException("Estado predial invalido.");
                    }

                    String motivo = null;
                    String detalle = null;
                    if ("SUSPENDIDO".equals(estado) || "CERRADO".equals(estado)) {
                        motivo = "OTRO";
                        detalle = "Cambio rapido desde listado de impuestos";
                    }

                    impServ.cambiarEstadoPredial(idPredial, estado, motivo, detalle);
                    flashOk(req, "Estado del impuesto predial actualizado a " + estado + ".");
                    resp.sendRedirect(req.getContextPath() + "/funcionario/impuesto?tab=predial");
                    return;
                }

                case "predial.editar": {
                    int idPredial = Integer.parseInt(req.getParameter("idPredial"));
                    Object[] predialEdit = impServ.obtenerPredialPorId(idPredial);
                    if (predialEdit == null) {
                        flashError(req, "No se encontro el impuesto predial solicitado.");
                        resp.sendRedirect(req.getContextPath() + "/funcionario/impuesto?tab=predial");
                        return;
                    }

                    req.setAttribute("predialEdit", predialEdit);
                    req.getRequestDispatcher("/views/funcionario/impuesto/editar-predial.jsp").forward(req, resp);
                    return;
                }

                case "alcabala.estado": {
                    int idAlcabala = Integer.parseInt(req.getParameter("idAlcabala"));
                    String estado = nullToEmpty(req.getParameter("estado")).trim().toUpperCase();

                    if (!"ACTIVO".equals(estado) && !"INACTIVO".equals(estado)) {
                        throw new IllegalArgumentException("Estado de alcabala invalido.");
                    }

                    impServ.cambiarEstadoAlcabala(idAlcabala, estado);
                    flashOk(req, "Estado de alcabala actualizado a " + estado + ".");
                    resp.sendRedirect(req.getContextPath() + "/funcionario/impuesto?tab=alcabala");
                    return;
                }

                case "alcabala.editar": {
                    int idAlcabala = Integer.parseInt(req.getParameter("idAlcabala"));
                    Object[] alcabalaEdit = impServ.obtenerAlcabalaEditablePorId(idAlcabala);
                    if (alcabalaEdit == null) {
                        flashError(req, "No se encontro el impuesto de alcabala solicitado.");
                        resp.sendRedirect(req.getContextPath() + "/funcionario/impuesto?tab=alcabala");
                        return;
                    }

                    req.setAttribute("alcabalaEdit", alcabalaEdit);
                    req.getRequestDispatcher("/views/funcionario/impuesto/editar-alcabala.jsp").forward(req, resp);
                    return;
                }

                case "crearVehicular": {
                    int idVehiculo = Integer.parseInt(req.getParameter("idVehiculo"));
                    if (!yaTieneImpuestoVehicular(idVehiculo)) {
                        impServ.crearVehicular(idVehiculo);
                        flashOk(req, "Impuesto vehicular generado correctamente.");
                    } else {
                        flashError(req, "El vehiculo ya tiene impuesto vehicular activo.");
                    }
                    resp.sendRedirect(req.getContextPath() + "/funcionario/impuesto?tab=vehicular");
                    return;
                }

                default:
                    resp.sendRedirect(req.getContextPath() + "/funcionario/impuesto?tab=" + normalizeTab(req.getParameter("tab")));
                    return;
            }

        } catch (Exception e) {
            flashError(req, "No se pudo completar la operacion: " + extraerMensaje(e));

            if ("predial.estado".equals(action)) {
                String idPredial = req.getParameter("idPredial");
                if (idPredial != null && !idPredial.isBlank()) {
                    resp.sendRedirect(req.getContextPath() + "/funcionario/impuesto?action=verPredial&id=" + idPredial);
                    return;
                }
            }

            if ("vehicular.editar".equals(action) || "vehicular.estado".equals(action)) {
                resp.sendRedirect(req.getContextPath() + "/funcionario/impuesto?tab=vehicular");
                return;
            }

            if ("predial.editar".equals(action) || "predial.estado.rapido".equals(action)) {
                resp.sendRedirect(req.getContextPath() + "/funcionario/impuesto?tab=predial");
                return;
            }

            if ("alcabala.editar".equals(action) || "alcabala.estado".equals(action)) {
                resp.sendRedirect(req.getContextPath() + "/funcionario/impuesto?tab=alcabala");
                return;
            }

            resp.sendRedirect(req.getContextPath() + "/funcionario/impuesto?tab=" + tabPorAccion(action));
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        String action = req.getParameter("action");

        try {
            if ("crearVehicular".equals(action)) {
                int idVehiculo = Integer.parseInt(req.getParameter("idVehiculo"));

                if (!yaTieneImpuestoVehicular(idVehiculo)) {
                    impServ.crearVehicular(idVehiculo);
                    flashOk(req, "Impuesto vehicular generado correctamente.");
                } else {
                    flashError(req, "El vehiculo ya tiene impuesto vehicular activo.");
                }

                resp.sendRedirect(req.getContextPath() + "/funcionario/impuesto?tab=vehicular");
                return;
            }

            if ("vehicular.editar".equals(action)) {
                int idVehiculo = Integer.parseInt(req.getParameter("idVehiculo"));
                String placa = nullToEmpty(req.getParameter("placa")).trim().toUpperCase();
                String marca = nullToEmpty(req.getParameter("marca")).trim();
                String modelo = nullToEmpty(req.getParameter("modelo")).trim();
                String fechaInscripcion = nullToEmpty(req.getParameter("fechaInscripcion")).trim();
                String valorRaw = nullToEmpty(req.getParameter("valor")).trim();
                String anioRaw = nullToEmpty(req.getParameter("anio")).trim();

                if (placa.isBlank() || marca.isBlank() || modelo.isBlank()
                        || fechaInscripcion.isBlank() || valorRaw.isBlank() || anioRaw.isBlank()) {
                    flashError(req, "Todos los campos del vehiculo son obligatorios.");
                    resp.sendRedirect(req.getContextPath() + "/funcionario/impuesto?action=vehicular.editar&idVehiculo=" + idVehiculo);
                    return;
                }

                int anio = Integer.parseInt(anioRaw);
                BigDecimal valor = new BigDecimal(valorRaw);

                if (anio < 1950 || anio > 2100) {
                    flashError(req, "El anio del vehiculo no es valido.");
                    resp.sendRedirect(req.getContextPath() + "/funcionario/impuesto?action=vehicular.editar&idVehiculo=" + idVehiculo);
                    return;
                }

                if (valor.compareTo(BigDecimal.ZERO) < 0) {
                    flashError(req, "El valor del vehiculo no puede ser negativo.");
                    resp.sendRedirect(req.getContextPath() + "/funcionario/impuesto?action=vehicular.editar&idVehiculo=" + idVehiculo);
                    return;
                }

                vehServ.actualizarDatosBasicos(idVehiculo, placa, marca, modelo, anio, fechaInscripcion, valor);
                flashOk(req, "Datos del vehiculo actualizados.");
                resp.sendRedirect(req.getContextPath() + "/funcionario/impuesto?tab=vehicular");
                return;
            }

            if ("predial.editar".equals(action)) {
                int idPredial = Integer.parseInt(req.getParameter("idPredial"));
                BigDecimal tasaAplicada = new BigDecimal(nullToEmpty(req.getParameter("tasaAplicada")).trim());
                BigDecimal montoAnual = new BigDecimal(nullToEmpty(req.getParameter("montoAnual")).trim());

                if (tasaAplicada.compareTo(BigDecimal.ZERO) < 0) {
                    flashError(req, "La tasa aplicada no puede ser negativa.");
                    resp.sendRedirect(req.getContextPath() + "/funcionario/impuesto?action=predial.editar&idPredial=" + idPredial);
                    return;
                }

                if (montoAnual.compareTo(BigDecimal.ZERO) < 0) {
                    flashError(req, "El monto anual no puede ser negativo.");
                    resp.sendRedirect(req.getContextPath() + "/funcionario/impuesto?action=predial.editar&idPredial=" + idPredial);
                    return;
                }

                impServ.actualizarPredialBasico(idPredial, tasaAplicada, montoAnual);
                flashOk(req, "Datos del impuesto predial actualizados.");
                resp.sendRedirect(req.getContextPath() + "/funcionario/impuesto?tab=predial");
                return;
            }

            if ("crearPredial".equals(action)) {
                int idInmueble = Integer.parseInt(req.getParameter("idInmueble"));
                impServ.crearPredial(idInmueble);
                flashOk(req, "Impuesto predial generado correctamente.");
                resp.sendRedirect(req.getContextPath() + "/funcionario/impuesto?tab=predial");
                return;
            }

            if ("predial.estado".equals(action)) {
                int idPredial = Integer.parseInt(req.getParameter("idPredial"));
                String estado = nullToEmpty(req.getParameter("estado")).trim().toUpperCase();
                String motivo = nullToEmpty(req.getParameter("motivo")).trim().toUpperCase();
                String detalleMotivo = nullToEmpty(req.getParameter("detalleMotivo")).trim();

                if (("SUSPENDIDO".equals(estado) || "CERRADO".equals(estado)) && motivo.isBlank()) {
                    flashError(req, "Debe seleccionar un motivo para cambiar a " + estado + ".");
                    resp.sendRedirect(req.getContextPath() + "/funcionario/impuesto?action=verPredial&id=" + idPredial);
                    return;
                }

                if ("OTRO".equals(motivo) && detalleMotivo.isBlank()) {
                    flashError(req, "Debe detallar el motivo cuando selecciona OTRO.");
                    resp.sendRedirect(req.getContextPath() + "/funcionario/impuesto?action=verPredial&id=" + idPredial);
                    return;
                }

                impServ.cambiarEstadoPredial(idPredial, estado, motivo, detalleMotivo);
                flashOk(req, "Estado del impuesto predial actualizado.");
                resp.sendRedirect(req.getContextPath() + "/funcionario/impuesto?action=verPredial&id=" + idPredial);
                return;
            }

            if ("crearAlcabala".equals(action)) {
                int idInmueble = Integer.parseInt(req.getParameter("idInmueble"));
                int idComprador = Integer.parseInt(req.getParameter("idComprador"));
                BigDecimal valorVenta = new BigDecimal(req.getParameter("valorVenta"));
                LocalDate fechaVenta = LocalDate.parse(req.getParameter("fechaVenta"));

                cuotaServ.validarPredialAlDiaParaVenta(idInmueble);
                impServ.crearAlcabala(idInmueble, idComprador, valorVenta, fechaVenta);
                flashOk(req, "Impuesto de alcabala registrado correctamente.");
                resp.sendRedirect(req.getContextPath() + "/funcionario/impuesto?tab=alcabala");
                return;
            }

            if ("alcabala.editar".equals(action)) {
                int idAlcabala = Integer.parseInt(req.getParameter("idAlcabala"));
                BigDecimal valorVenta = new BigDecimal(nullToEmpty(req.getParameter("valorVenta")).trim());
                LocalDate fechaVenta = LocalDate.parse(nullToEmpty(req.getParameter("fechaVenta")).trim());

                if (valorVenta.compareTo(BigDecimal.ZERO) < 0) {
                    flashError(req, "El valor de venta no puede ser negativo.");
                    resp.sendRedirect(req.getContextPath() + "/funcionario/impuesto?action=alcabala.editar&idAlcabala=" + idAlcabala);
                    return;
                }

                impServ.actualizarAlcabalaBasico(idAlcabala, valorVenta, fechaVenta);
                flashOk(req, "Datos de alcabala actualizados.");
                resp.sendRedirect(req.getContextPath() + "/funcionario/impuesto?tab=alcabala");
                return;
            }

            resp.sendRedirect(req.getContextPath() + "/funcionario/impuesto?tab=" + normalizeTab(req.getParameter("tab")));

        } catch (Exception e) {
            flashError(req, "No se pudo completar la operacion: " + extraerMensaje(e));

            if ("vehicular.editar".equals(action)) {
                String idVehiculo = nullToEmpty(req.getParameter("idVehiculo")).trim();
                if (!idVehiculo.isBlank()) {
                    resp.sendRedirect(req.getContextPath() + "/funcionario/impuesto?action=vehicular.editar&idVehiculo=" + idVehiculo);
                    return;
                }
            }

            if ("predial.editar".equals(action)) {
                String idPredial = nullToEmpty(req.getParameter("idPredial")).trim();
                if (!idPredial.isBlank()) {
                    resp.sendRedirect(req.getContextPath() + "/funcionario/impuesto?action=predial.editar&idPredial=" + idPredial);
                    return;
                }
            }

            if ("alcabala.editar".equals(action)) {
                String idAlcabala = nullToEmpty(req.getParameter("idAlcabala")).trim();
                if (!idAlcabala.isBlank()) {
                    resp.sendRedirect(req.getContextPath() + "/funcionario/impuesto?action=alcabala.editar&idAlcabala=" + idAlcabala);
                    return;
                }
            }

            resp.sendRedirect(req.getContextPath() + "/funcionario/impuesto?tab=" + tabPorAccion(action));
        }
    }

    private void cargarVistaPrincipal(HttpServletRequest req) {
        try {
            impServ.aplicarReglasPredial(EDAD_LIMITE_PREDIAL);
        } catch (Exception ignored) {
            // Si el SP no esta disponible aun, el listado no debe caer.
        }

        req.setAttribute("activeTab", normalizeTab(req.getParameter("tab")));
        req.setAttribute("listaVehicular", prepararListaVehicular());
        req.setAttribute("listaPredial", impServ.listarPrediales());
        req.setAttribute("listaAlcabala", impServ.listarAlcabalas());
        req.setAttribute("inmueblesAlcabala", impServ.listarInmueblesParaAlcabala());
        req.setAttribute("contribuyentesCombo", contribServ.listarActivosCombo());
    }

    private List<Object[]> prepararListaVehicular() {
        List<Object[]> impuestos = impServ.listarVehiculares();
        List<Object[]> vehiculos = vehServ.listar();

        Map<String, Object[]> vehiculoPorPlaca = new HashMap<>();
        for (Object[] vehiculo : vehiculos) {
            String placa = texto(valorEn(vehiculo, 1));
            if (placa != null) {
                vehiculoPorPlaca.put(placa.toUpperCase(), vehiculo);
            }
        }

        List<Object[]> resultado = new ArrayList<>();
        for (Object[] impuesto : impuestos) {
            int idImpuesto = toInt(valorEn(impuesto, 0), -1);
            List<Object[]> detalle = idImpuesto > 0 ? impServ.listarDetalle(idImpuesto) : new ArrayList<>();
            String estadoPagoGeneral = cuotaServ.estadoPagoVehicularFuncionario(idImpuesto, detalle);

            String placa = texto(valorEn(impuesto, 2));
            Object[] vehiculo = placa == null ? null : vehiculoPorPlaca.get(placa.toUpperCase());

            Object idVehiculo = valorEn(vehiculo, 0);
            String estadoVehiculo = texto(valorEn(vehiculo, 9));
            if (estadoVehiculo == null || estadoVehiculo.isBlank()) {
                estadoVehiculo = "ACTIVO";
            }

            Object[] fila = new Object[10];
            fila[0] = valorEn(impuesto, 0);
            fila[1] = valorEn(impuesto, 1);
            fila[2] = valorEn(impuesto, 2);
            fila[3] = valorEn(impuesto, 3);
            fila[4] = valorEn(impuesto, 4);
            fila[5] = valorEn(impuesto, 5);
            fila[6] = estadoPagoGeneral;
            fila[7] = valorEn(impuesto, 7);
            fila[8] = idVehiculo;
            fila[9] = estadoVehiculo;
            resultado.add(fila);
        }

        return resultado;
    }

    private String calcularEstadoPagoVehicular(List<Object[]> detalle) {
        if (detalle == null || detalle.isEmpty()) {
            return "PENDIENTE";
        }

        for (Object[] fila : detalle) {
            String estadoAnual = texto(valorEn(fila, 3));
            if (!"PAGADO".equalsIgnoreCase(estadoAnual)) {
                return "PENDIENTE";
            }
        }
        return "PAGADO";
    }

    private List<Object[]> listarVehiculosDisponibles() {
        List<Object[]> vehiculos = vehServ.listar();
        List<Object[]> impuestos = impServ.listarVehiculares();

        Set<String> placasConImpuesto = new HashSet<>();
        for (Object[] impuesto : impuestos) {
            if (impuesto.length > 2 && impuesto[2] != null) {
                placasConImpuesto.add(impuesto[2].toString().trim().toUpperCase());
            }
        }

        List<Object[]> disponibles = new ArrayList<>();
        for (Object[] vehiculo : vehiculos) {
            if (vehiculo.length > 1 && vehiculo[1] != null) {
                String placa = vehiculo[1].toString().trim().toUpperCase();
                if (!placasConImpuesto.contains(placa)) {
                    disponibles.add(vehiculo);
                }
            }
        }

        return disponibles;
    }

    private String obtenerEstadoVehiculoPorPlaca(String placa) {
        if (placa == null || placa.isBlank()) {
            return "ACTIVO";
        }

        for (Object[] vehiculo : vehServ.listar()) {
            String placaActual = texto(valorEn(vehiculo, 1));
            if (placaActual != null && placa.equalsIgnoreCase(placaActual)) {
                String estado = texto(valorEn(vehiculo, 9));
                return estado == null ? "ACTIVO" : estado.toUpperCase();
            }
        }

        return "ACTIVO";
    }

    private boolean yaTieneImpuestoVehicular(int idVehiculo) {
        List<Object[]> vehiculos = vehServ.listar();
        String placaVehiculo = null;

        for (Object[] vehiculo : vehiculos) {
            if (vehiculo.length > 1 && vehiculo[0] != null && vehiculo[1] != null) {
                int idActual = Integer.parseInt(vehiculo[0].toString());
                if (idActual == idVehiculo) {
                    placaVehiculo = vehiculo[1].toString().trim().toUpperCase();
                    break;
                }
            }
        }

        if (placaVehiculo == null) {
            return false;
        }

        List<Object[]> impuestos = impServ.listarVehiculares();
        for (Object[] impuesto : impuestos) {
            if (impuesto.length > 2 && impuesto[2] != null) {
                String placaConImpuesto = impuesto[2].toString().trim().toUpperCase();
                if (placaVehiculo.equals(placaConImpuesto)) {
                    return true;
                }
            }
        }

        return false;
    }

    private String normalizeTab(String tab) {
        if ("predial".equalsIgnoreCase(tab)) {
            return "predial";
        }
        if ("alcabala".equalsIgnoreCase(tab)) {
            return "alcabala";
        }
        return "vehicular";
    }

    private String tabPorAccion(String action) {
        if (action == null) {
            return "vehicular";
        }
        if (action.startsWith("predial") || "verPredial".equals(action)) {
            return "predial";
        }
        if (action.startsWith("vehicular")) {
            return "vehicular";
        }
        if (action.contains("Alcabala") || action.toLowerCase().contains("alcabala")) {
            return "alcabala";
        }
        return "vehicular";
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

    private Object valorEn(Object[] data, int index) {
        if (data == null || index < 0 || index >= data.length) {
            return null;
        }
        return data[index];
    }

    private String texto(Object value) {
        if (value == null) {
            return null;
        }
        String text = value.toString().trim();
        return text.isEmpty() ? null : text;
    }

    private int toInt(Object value, int defaultValue) {
        if (value == null) {
            return defaultValue;
        }
        if (value instanceof Number) {
            return ((Number) value).intValue();
        }
        try {
            return Integer.parseInt(value.toString().trim());
        } catch (Exception ignored) {
            return defaultValue;
        }
    }
}
