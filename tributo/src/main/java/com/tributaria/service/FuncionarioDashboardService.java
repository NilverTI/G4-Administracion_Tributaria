package com.tributaria.service;

import com.tributaria.dto.DashboardPendienteItemDTO;
import com.tributaria.dto.FuncionarioDashboardDTO;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Date;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.Month;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class FuncionarioDashboardService {

    private static final String[] LABELS = {
            "Ene", "Feb", "Mar", "Abr", "May", "Jun",
            "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"
    };

    private final ContribuyenteService contribuyenteService = new ContribuyenteService();
    private final InmuebleService inmuebleService = new InmuebleService();
    private final VehiculoService vehiculoService = new VehiculoService();
    private final ImpuestoService impuestoService = new ImpuestoService();
    private final FuncionarioCuotaService cuotaService = new FuncionarioCuotaService();

    public FuncionarioDashboardDTO obtenerResumen() {
        LocalDate hoy = LocalDate.now();
        int anioActual = hoy.getYear();

        FuncionarioDashboardDTO dto = new FuncionarioDashboardDTO();
        dto.setAnioActual(anioActual);
        dto.setTotalContribuyentes(contribuyenteService.contar());
        dto.setTotalActivos(contribuyenteService.contarActivos());

        inicializarGrafico(dto);

        BigDecimal deudaPendiente = BigDecimal.ZERO;
        BigDecimal totalRegistrado = BigDecimal.ZERO;
        List<DashboardPendienteItemDTO> alertas = new ArrayList<>();

        List<Object[]> inmuebles = inmuebleService.listar();
        dto.setTotalInmuebles(inmuebles.size());
        dto.setInmueblesActivos(contarPorEstado(inmuebles, 9, "ACTIVO"));

        List<Object[]> vehiculos = vehiculoService.listar();
        dto.setTotalVehiculos(vehiculos.size());
        dto.setVehiculosActivos(contarPorEstado(vehiculos, 9, "ACTIVO"));

        List<Object[]> cuotasPendientes = cuotaService.listarCuotasPendientes(false);
        Set<String> impuestosConFraccionamientoActivo = new HashSet<>();
        for (Object[] row : cuotasPendientes) {
            String tipo = texto(valorEn(row, 1));
            int idReferencia = toInt(valorEn(row, 2), 0);
            impuestosConFraccionamientoActivo.add(key(tipo, idReferencia));

            BigDecimal saldoPendiente = toBigDecimal(valorEn(row, 11));
            deudaPendiente = deudaPendiente.add(saldoPendiente);

            DashboardPendienteItemDTO alerta = new DashboardPendienteItemDTO();
            alerta.setContribuyente(defaultText(texto(valorEn(row, 4)), "Sin contribuyente"));
            alerta.setDescripcion(descripcionFraccionamiento(texto(valorEn(row, 1))));
            alerta.setMonto(saldoPendiente);
            alerta.setFechaVencimiento(toLocalDate(valorEn(row, 10)));
            alerta.setEstado(resolverEstadoAlerta(alerta.getFechaVencimiento(), hoy));
            alertas.add(alerta);
        }

        List<Object[]> prediales = impuestoService.listarPrediales();
        for (Object[] row : prediales) {
            BigDecimal monto = toBigDecimal(valorEn(row, 6));
            LocalDate fechaRegistro = toLocalDate(valorEn(row, 9));
            registrarSerie(dto.getChartPredial(), fechaRegistro, monto, anioActual);
            if (fechaRegistro != null && fechaRegistro.getYear() == anioActual) {
                totalRegistrado = totalRegistrado.add(monto);
            }

            int idPredial = toInt(valorEn(row, 0), 0);
            String estado = texto(valorEn(row, 7));
            if (!"ACTIVO".equalsIgnoreCase(estado)
                    || impuestosConFraccionamientoActivo.contains(key("PREDIAL", idPredial))) {
                continue;
            }

            BigDecimal cuota = monto.divide(new BigDecimal("4"), 2, RoundingMode.HALF_UP);
            BigDecimal saldo = monto.subtract(cuota).max(BigDecimal.ZERO);
            if (saldo.compareTo(BigDecimal.ZERO) <= 0) {
                continue;
            }

            Object[] detallePredial = impuestoService.obtenerPredialPorId(idPredial);
            LocalDate fechaInicio = toLocalDate(valorEn(detallePredial, 10));
            int anio = fechaInicio == null ? anioActual : fechaInicio.getYear();

            deudaPendiente = deudaPendiente.add(saldo);
            alertas.add(crearAlerta(
                    texto(valorEn(row, 1)),
                    "Predial " + anio,
                    saldo,
                    siguienteVencimientoPredial(anio, hoy),
                    hoy
            ));
        }

        List<Object[]> vehiculares = impuestoService.listarVehiculares();
        for (Object[] row : vehiculares) {
            BigDecimal monto = toBigDecimal(valorEn(row, 4));
            LocalDate fechaRegistro = toLocalDate(valorEn(row, 7));
            registrarSerie(dto.getChartVehicular(), fechaRegistro, monto, anioActual);
            if (fechaRegistro != null && fechaRegistro.getYear() == anioActual) {
                totalRegistrado = totalRegistrado.add(monto);
            }

            int idImpuesto = toInt(valorEn(row, 0), 0);
            if (impuestosConFraccionamientoActivo.contains(key("VEHICULAR", idImpuesto))) {
                continue;
            }

            List<Object[]> detalle = impuestoService.listarDetalle(idImpuesto);
            BigDecimal saldo = BigDecimal.ZERO;
            int anioPendiente = Integer.MAX_VALUE;
            for (Object[] item : detalle) {
                if ("PAGADO".equalsIgnoreCase(texto(valorEn(item, 3)))) {
                    continue;
                }
                saldo = saldo.add(toBigDecimal(valorEn(item, 2)));
                anioPendiente = Math.min(anioPendiente, toInt(valorEn(item, 1), Integer.MAX_VALUE));
            }

            if (saldo.compareTo(BigDecimal.ZERO) <= 0 || anioPendiente == Integer.MAX_VALUE) {
                continue;
            }

            deudaPendiente = deudaPendiente.add(saldo);
            alertas.add(crearAlerta(
                    texto(valorEn(row, 1)),
                    "Vehicular " + anioPendiente,
                    saldo,
                    LocalDate.of(anioPendiente, Month.JUNE, 30),
                    hoy
            ));
        }

        List<Object[]> alcabalas = impuestoService.listarAlcabalas();
        for (Object[] row : alcabalas) {
            BigDecimal monto = toBigDecimal(valorEn(row, 7));
            LocalDate fechaRegistro = toLocalDate(valorEn(row, 10));
            registrarSerie(dto.getChartAlcabala(), fechaRegistro, monto, anioActual);
            if (fechaRegistro != null && fechaRegistro.getYear() == anioActual) {
                totalRegistrado = totalRegistrado.add(monto);
            }

            int idAlcabala = toInt(valorEn(row, 0), 0);
            String estado = texto(valorEn(row, 8));
            if ((!esEstadoDeudaAlcabala(estado))
                    || impuestosConFraccionamientoActivo.contains(key("ALCABALA", idAlcabala))) {
                continue;
            }

            deudaPendiente = deudaPendiente.add(monto);
            LocalDate fechaVenta = toLocalDate(valorEn(row, 9));
            LocalDate fechaVencimiento = fechaVenta == null ? null : fechaVenta.plusDays(30);
            alertas.add(crearAlerta(
                    texto(valorEn(row, 1)),
                    "Alcabala",
                    monto,
                    fechaVencimiento,
                    hoy
            ));
        }

        alertas.sort(Comparator
                .comparing(DashboardPendienteItemDTO::getFechaVencimiento, Comparator.nullsLast(Comparator.naturalOrder()))
                .thenComparing(DashboardPendienteItemDTO::getContribuyente, Comparator.nullsLast(String.CASE_INSENSITIVE_ORDER)));

        for (int i = 0; i < alertas.size() && i < 5; i++) {
            dto.getAlertas().add(alertas.get(i));
        }

        dto.setDeudaPendiente(deudaPendiente);
        dto.setTotalRegistradoAnio(totalRegistrado);
        return dto;
    }

    private void inicializarGrafico(FuncionarioDashboardDTO dto) {
        for (String label : LABELS) {
            dto.getChartLabels().add(label);
            dto.getChartPredial().add(BigDecimal.ZERO);
            dto.getChartVehicular().add(BigDecimal.ZERO);
            dto.getChartAlcabala().add(BigDecimal.ZERO);
        }
    }

    private int contarPorEstado(List<Object[]> rows, int indexEstado, String estadoBuscado) {
        int total = 0;
        for (Object[] row : rows) {
            if (estadoBuscado.equalsIgnoreCase(texto(valorEn(row, indexEstado)))) {
                total++;
            }
        }
        return total;
    }

    private void registrarSerie(List<BigDecimal> serie, LocalDate fechaRegistro, BigDecimal monto, int anioActual) {
        if (fechaRegistro == null || fechaRegistro.getYear() != anioActual) {
            return;
        }
        int monthIndex = fechaRegistro.getMonthValue() - 1;
        if (monthIndex < 0 || monthIndex >= serie.size()) {
            return;
        }
        serie.set(monthIndex, serie.get(monthIndex).add(toBigDecimal(monto)));
    }

    private DashboardPendienteItemDTO crearAlerta(
            String contribuyente,
            String descripcion,
            BigDecimal monto,
            LocalDate fechaVencimiento,
            LocalDate hoy
    ) {
        DashboardPendienteItemDTO item = new DashboardPendienteItemDTO();
        item.setContribuyente(defaultText(contribuyente, "Sin contribuyente"));
        item.setDescripcion(descripcion);
        item.setMonto(monto);
        item.setFechaVencimiento(fechaVencimiento);
        item.setEstado(resolverEstadoAlerta(fechaVencimiento, hoy));
        return item;
    }

    private LocalDate siguienteVencimientoPredial(int anio, LocalDate hoy) {
        LocalDate[] vencimientos = {
                LocalDate.of(anio, 3, 31),
                LocalDate.of(anio, 6, 30),
                LocalDate.of(anio, 9, 30),
                LocalDate.of(anio, 12, 31)
        };

        for (LocalDate fecha : vencimientos) {
            if (!fecha.isBefore(hoy)) {
                return fecha;
            }
        }
        return vencimientos[vencimientos.length - 1];
    }

    private String descripcionFraccionamiento(String tipo) {
        if ("ALCABALA".equalsIgnoreCase(tipo)) {
            return "Alcabala en cuotas";
        }
        if ("VEHICULAR".equalsIgnoreCase(tipo)) {
            return "Vehicular en cuotas";
        }
        return "Predial en cuotas";
    }

    private boolean esEstadoDeudaAlcabala(String estado) {
        return "PENDIENTE".equalsIgnoreCase(estado)
                || "REGISTRADO".equalsIgnoreCase(estado)
                || "ACTIVO".equalsIgnoreCase(estado);
    }

    private String resolverEstadoAlerta(LocalDate fechaVencimiento, LocalDate hoy) {
        if (fechaVencimiento != null && fechaVencimiento.isBefore(hoy)) {
            return "Vencido";
        }
        return "Por vencer";
    }

    private String key(String tipo, int idReferencia) {
        String valorTipo = tipo == null ? "" : tipo.trim().toUpperCase();
        return valorTipo + ":" + idReferencia;
    }

    private Object valorEn(Object[] row, int index) {
        if (row == null || index < 0 || index >= row.length) {
            return null;
        }
        return row[index];
    }

    private String texto(Object value) {
        if (value == null) {
            return null;
        }
        String text = value.toString().trim();
        return text.isBlank() ? null : text;
    }

    private int toInt(Object value, int fallback) {
        if (value == null) {
            return fallback;
        }
        if (value instanceof Number) {
            return ((Number) value).intValue();
        }
        try {
            return Integer.parseInt(value.toString().trim());
        } catch (Exception ex) {
            return fallback;
        }
    }

    private BigDecimal toBigDecimal(Object value) {
        if (value == null) {
            return BigDecimal.ZERO;
        }
        if (value instanceof BigDecimal) {
            return ((BigDecimal) value).setScale(2, RoundingMode.HALF_UP);
        }
        if (value instanceof Number) {
            return new BigDecimal(value.toString()).setScale(2, RoundingMode.HALF_UP);
        }
        try {
            return new BigDecimal(value.toString().trim()).setScale(2, RoundingMode.HALF_UP);
        } catch (Exception ex) {
            return BigDecimal.ZERO.setScale(2, RoundingMode.HALF_UP);
        }
    }

    private LocalDate toLocalDate(Object value) {
        if (value == null) {
            return null;
        }
        if (value instanceof LocalDate) {
            return (LocalDate) value;
        }
        if (value instanceof LocalDateTime) {
            return ((LocalDateTime) value).toLocalDate();
        }
        if (value instanceof Date) {
            return ((Date) value).toLocalDate();
        }
        if (value instanceof java.util.Date) {
            return new Date(((java.util.Date) value).getTime()).toLocalDate();
        }
        try {
            return LocalDate.parse(value.toString().substring(0, 10));
        } catch (Exception ex) {
            return null;
        }
    }

    private String defaultText(String value, String fallback) {
        return value == null || value.isBlank() ? fallback : value;
    }
}
