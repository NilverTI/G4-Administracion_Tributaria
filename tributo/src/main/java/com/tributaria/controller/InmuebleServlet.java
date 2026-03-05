package com.tributaria.controller;

import com.tributaria.service.InmuebleService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/funcionario/inmueble")
public class InmuebleServlet extends HttpServlet {

    private final InmuebleService service = new InmuebleService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        request.setAttribute("zonas", service.listarZonas());
        request.setAttribute("contribuyentes", service.listarContribuyentes());

        try {
            if (action == null || action.isBlank()) {
                request.setAttribute("lista", service.listar());
                request.getRequestDispatcher("/views/funcionario/inmueble/lista.jsp").forward(request, response);
                return;
            }

            if ("estado".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                String estado = nullToEmpty(request.getParameter("estado")).trim().toUpperCase();
                if (!"ACTIVO".equals(estado) && !"INACTIVO".equals(estado)) {
                    throw new IllegalArgumentException("Estado invalido para inmueble.");
                }

                service.cambiarEstado(id, estado);
                flashOk(request, "Estado de inmueble actualizado a " + estado + ".");
                response.sendRedirect(request.getContextPath() + "/funcionario/inmueble");
                return;
            }

            if ("ver".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Object[] inmueble = service.obtenerPorId(id);
                if (inmueble == null) {
                    flashError(request, "No se encontro el inmueble.");
                    response.sendRedirect(request.getContextPath() + "/funcionario/inmueble");
                    return;
                }

                request.setAttribute("inmueble", inmueble);
                request.getRequestDispatcher("/views/funcionario/inmueble/ver.jsp").forward(request, response);
                return;
            }

            if ("editar".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Object[] inmueble = service.obtenerPorId(id);
                if (inmueble == null) {
                    flashError(request, "No se encontro el inmueble.");
                    response.sendRedirect(request.getContextPath() + "/funcionario/inmueble");
                    return;
                }

                request.setAttribute("inmueble", inmueble);
                request.getRequestDispatcher("/views/funcionario/inmueble/editar.jsp").forward(request, response);
                return;
            }

            response.sendRedirect(request.getContextPath() + "/funcionario/inmueble");
        } catch (Exception e) {
            flashError(request, "No se pudo completar la operacion: " + extraerMensaje(e));
            response.sendRedirect(request.getContextPath() + "/funcionario/inmueble");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String action = nullToEmpty(request.getParameter("action")).trim();

        try {
            if ("editar".equals(action)) {
                int idInmueble = Integer.parseInt(request.getParameter("idInmueble"));
                int idContribuyente = Integer.parseInt(request.getParameter("idContribuyente"));
                int idZona = Integer.parseInt(request.getParameter("idZona"));
                String direccion = nullToEmpty(request.getParameter("direccion")).trim();
                BigDecimal valor = new BigDecimal(request.getParameter("valor"));
                String tipoUso = normalizarTipoUso(request.getParameter("tipoUso"));
                BigDecimal areaTerreno = parseBigDecimal(request.getParameter("areaTerrenoM2"));
                BigDecimal areaConstruida = parseBigDecimal(request.getParameter("areaConstruidaM2"));
                String tipoMaterial = normalizarTipoMaterial(request.getParameter("tipoMaterial"));

                validarCampos(direccion, valor, tipoUso, areaTerreno, areaConstruida, tipoMaterial);

                if ("TERRENO".equals(tipoUso)) {
                    areaConstruida = null;
                    tipoMaterial = null;
                }

                service.actualizar(
                        idInmueble,
                        idContribuyente,
                        idZona,
                        direccion,
                        valor,
                        tipoUso,
                        areaTerreno,
                        areaConstruida,
                        tipoMaterial
                );

                flashOk(request, "Inmueble actualizado correctamente.");
                response.sendRedirect(request.getContextPath() + "/funcionario/inmueble");
                return;
            }

            int idContribuyente = Integer.parseInt(request.getParameter("idContribuyente"));
            int idZona = Integer.parseInt(request.getParameter("idZona"));
            String direccion = nullToEmpty(request.getParameter("direccion")).trim();
            BigDecimal valor = new BigDecimal(request.getParameter("valor"));
            String tipoUso = normalizarTipoUso(request.getParameter("tipoUso"));
            BigDecimal areaTerreno = parseBigDecimal(request.getParameter("areaTerrenoM2"));
            BigDecimal areaConstruida = parseBigDecimal(request.getParameter("areaConstruidaM2"));
            String tipoMaterial = normalizarTipoMaterial(request.getParameter("tipoMaterial"));

            validarCampos(direccion, valor, tipoUso, areaTerreno, areaConstruida, tipoMaterial);

            if ("TERRENO".equals(tipoUso)) {
                areaConstruida = null;
                tipoMaterial = null;
            }

            service.crear(
                    idContribuyente,
                    idZona,
                    direccion,
                    valor,
                    tipoUso,
                    areaTerreno,
                    areaConstruida,
                    tipoMaterial
            );

            flashOk(request, "Inmueble creado correctamente.");
        } catch (Exception e) {
            flashError(request, "No se pudo guardar el inmueble: " + extraerMensaje(e));
            if ("editar".equals(action)) {
                String id = nullToEmpty(request.getParameter("idInmueble")).trim();
                if (!id.isBlank()) {
                    response.sendRedirect(request.getContextPath() + "/funcionario/inmueble?action=editar&id=" + id);
                    return;
                }
            }
        }

        response.sendRedirect(request.getContextPath() + "/funcionario/inmueble");
    }

    private void validarCampos(
            String direccion,
            BigDecimal valor,
            String tipoUso,
            BigDecimal areaTerreno,
            BigDecimal areaConstruida,
            String tipoMaterial
    ) {
        if (direccion.isBlank()) {
            throw new IllegalArgumentException("La direccion es obligatoria.");
        }
        if (valor.compareTo(BigDecimal.ZERO) < 0) {
            throw new IllegalArgumentException("El valor catastral no puede ser negativo.");
        }
        if (areaTerreno == null || areaTerreno.compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalArgumentException("El area de terreno (m2) debe ser mayor a 0.");
        }

        if ("CONSTRUIDO".equals(tipoUso)) {
            if (areaConstruida == null || areaConstruida.compareTo(BigDecimal.ZERO) <= 0) {
                throw new IllegalArgumentException("Debe ingresar el area construida (m2) para inmueble construido.");
            }
            if (tipoMaterial == null || tipoMaterial.isBlank()) {
                throw new IllegalArgumentException("Debe seleccionar el tipo de material para inmueble construido.");
            }
        }
    }

    private BigDecimal parseBigDecimal(String value) {
        String val = nullToEmpty(value).trim();
        if (val.isBlank()) {
            return null;
        }
        return new BigDecimal(val);
    }

    private String normalizarTipoUso(String value) {
        String tipo = nullToEmpty(value).trim().toUpperCase();
        if (!"CONSTRUIDO".equals(tipo)) {
            return "TERRENO";
        }
        return tipo;
    }

    private String normalizarTipoMaterial(String value) {
        String material = nullToEmpty(value).trim().toUpperCase();
        if (material.isBlank()) {
            return null;
        }
        if (!"NOBLE".equals(material) && !"RUSTICO".equals(material) && !"MIXTO".equals(material)) {
            throw new IllegalArgumentException("Tipo de material invalido.");
        }
        return material;
    }

    private void flashOk(HttpServletRequest request, String msg) {
        request.getSession().setAttribute("flashOk", msg);
    }

    private void flashError(HttpServletRequest request, String msg) {
        request.getSession().setAttribute("flashError", msg);
    }

    private String nullToEmpty(String value) {
        return value == null ? "" : value;
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
