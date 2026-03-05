package com.tributaria.service;

import com.tributaria.dao.ContribuyenteImpuestoDAO;
import com.tributaria.entity.Usuario;
import org.mindrot.jbcrypt.BCrypt;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

public class ContribuyentePortalService {

    private final ContribuyenteImpuestoDAO dao = new ContribuyenteImpuestoDAO();
    private final FuncionarioCuotaService cuotaService = new FuncionarioCuotaService();

    public List<Object[]> listarCuotas(int idPersona) {
        return dao.listarCuotasPorPersona(idPersona);
    }

    public List<Object[]> listarPagos(int idPersona) {
        return dao.listarPagosPorPersona(idPersona);
    }

    public List<Object[]> listarInmuebles(int idPersona) {
        return dao.listarInmueblesPorPersona(idPersona);
    }

    public List<Object[]> listarVehiculos(int idPersona) {
        return dao.listarVehiculosPorPersona(idPersona);
    }

    public Object[] obtenerFraccionamiento(int idPersona, int idFraccionamiento) {
        return dao.obtenerFraccionamientoPorPersona(idPersona, idFraccionamiento);
    }

    public List<Object[]> listarDetalleFraccionamiento(int idPersona, int idFraccionamiento) {
        return dao.listarDetalleFraccionamientoPorPersona(idPersona, idFraccionamiento);
    }

    public int contarCuotasPendientes(int idPersona) {
        return dao.listarCuotasPendientesPorPersona(idPersona).size();
    }

    public BigDecimal sumarMontos(List<Object[]> rows, int index) {
        BigDecimal total = BigDecimal.ZERO;
        if (rows == null) {
            return total;
        }

        for (Object[] row : rows) {
            if (row == null || index < 0 || index >= row.length || row[index] == null) {
                continue;
            }

            Object value = row[index];
            if (value instanceof BigDecimal) {
                total = total.add((BigDecimal) value);
                continue;
            }

            if (value instanceof Number) {
                total = total.add(new BigDecimal(value.toString()));
                continue;
            }

            try {
                total = total.add(new BigDecimal(value.toString().trim()));
            } catch (Exception ignored) {
                // Ignore malformed values from native query rows.
            }
        }

        return total;
    }

    public void registrarPagoCuota(int idPersona, int idCuota, String metodoPago) {
        Object[] cuota = dao.obtenerCuotaPendientePorPersona(idPersona, idCuota);
        if (cuota == null) {
            throw new IllegalArgumentException("La cuota no existe, no le pertenece o ya fue pagada.");
        }

        BigDecimal montoProgramado = obtenerBigDecimal(cuota, 7);
        String metodo = metodoPago == null || metodoPago.isBlank()
                ? "Pasarela web"
                : metodoPago.trim();

        cuotaService.registrarPagoCuota(
                idCuota,
                montoProgramado,
                LocalDate.now(),
                "Pago desde portal contribuyente - " + metodo
        );
    }

    public void actualizarDatosPerfil(Usuario usuario, String telefono, String direccion) {
        if (usuario == null || usuario.getPersona() == null) {
            throw new IllegalArgumentException("No se encontro la sesion del contribuyente.");
        }

        String telefonoLimpio = normalizarTexto(telefono, 20);
        String direccionLimpia = normalizarTexto(direccion, 255);

        dao.actualizarDatosContactoPersona(
                usuario.getPersona().getIdPersona(),
                telefonoLimpio,
                direccionLimpia
        );

        usuario.getPersona().setTelefono(telefonoLimpio);
        usuario.getPersona().setDireccion(direccionLimpia);
    }

    public void cambiarPasswordPerfil(Usuario usuario,
                                      String passwordActual,
                                      String nuevaPassword,
                                      String confirmarPassword) {

        if (usuario == null) {
            throw new IllegalArgumentException("No se encontro la sesion del contribuyente.");
        }

        String actual = passwordActual == null ? "" : passwordActual;
        String nueva = nuevaPassword == null ? "" : nuevaPassword;
        String confirmar = confirmarPassword == null ? "" : confirmarPassword;

        if (actual.isBlank()) {
            throw new IllegalArgumentException("Debe ingresar su contraseña actual.");
        }

        if (!BCrypt.checkpw(actual, usuario.getPasswordHash())) {
            throw new IllegalArgumentException("La contraseña actual no es correcta.");
        }

        if (nueva.isBlank()) {
            throw new IllegalArgumentException("Debe ingresar una nueva contraseña.");
        }

        if (nueva.length() < 8) {
            throw new IllegalArgumentException("La nueva contraseña debe tener al menos 8 caracteres.");
        }

        if (!nueva.equals(confirmar)) {
            throw new IllegalArgumentException("La confirmacion de contraseña no coincide.");
        }

        if (BCrypt.checkpw(nueva, usuario.getPasswordHash())) {
            throw new IllegalArgumentException("La nueva contraseña debe ser diferente a la actual.");
        }

        String nuevoHash = BCrypt.hashpw(nueva, BCrypt.gensalt());
        dao.actualizarPasswordUsuario(usuario.getIdUsuario(), nuevoHash);
        usuario.setPasswordHash(nuevoHash);
    }

    private String normalizarTexto(String value, int maxLength) {
        String texto = value == null ? "" : value.trim();
        if (texto.isEmpty()) {
            return null;
        }

        if (texto.length() > maxLength) {
            throw new IllegalArgumentException("El valor supera el limite permitido.");
        }

        return texto;
    }

    private BigDecimal obtenerBigDecimal(Object[] row, int index) {
        if (row == null || index < 0 || index >= row.length || row[index] == null) {
            return BigDecimal.ZERO;
        }

        Object value = row[index];
        if (value instanceof BigDecimal) {
            return (BigDecimal) value;
        }
        if (value instanceof Number) {
            return new BigDecimal(value.toString());
        }
        return new BigDecimal(value.toString().trim());
    }
}
