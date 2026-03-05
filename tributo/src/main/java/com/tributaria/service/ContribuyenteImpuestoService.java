package com.tributaria.service;

import com.tributaria.dao.ContribuyenteImpuestoDAO;
import com.tributaria.dto.MiImpuestoCuotaDTO;
import com.tributaria.dto.MiImpuestoDetalleDTO;
import com.tributaria.dto.MiImpuestoItemDTO;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class ContribuyenteImpuestoService {

    private final ContribuyenteImpuestoDAO contribuyenteImpuestoDAO = new ContribuyenteImpuestoDAO();
    private final ImpuestoService impuestoService = new ImpuestoService();

    public List<MiImpuestoItemDTO> listarMisImpuestos(int idPersona, String filtroTipo) {
        String filtro = normalizarFiltro(filtroTipo);
        List<MiImpuestoItemDTO> resultado = new ArrayList<>();

        if ("TODOS".equals(filtro) || "PREDIAL".equals(filtro)) {
            resultado.addAll(listarPrediales(idPersona));
        }

        if ("TODOS".equals(filtro) || "VEHICULAR".equals(filtro)) {
            resultado.addAll(listarVehiculares(idPersona));
        }

        resultado.sort(Comparator
                .comparing(MiImpuestoItemDTO::getTipo)
                .thenComparing(MiImpuestoItemDTO::getAnio, Comparator.reverseOrder())
                .thenComparing(MiImpuestoItemDTO::getIdReferencia, Comparator.reverseOrder()));

        return resultado;
    }

    public MiImpuestoDetalleDTO obtenerDetalle(int idPersona, String tipoDetalle, int idDetalle) {
        String tipo = tipoDetalle == null ? "" : tipoDetalle.trim().toUpperCase();
        if ("PREDIAL".equals(tipo)) {
            return obtenerDetallePredial(idPersona, idDetalle);
        }
        if ("VEHICULAR".equals(tipo)) {
            return obtenerDetalleVehicular(idPersona, idDetalle);
        }
        return null;
    }

    private List<MiImpuestoItemDTO> listarPrediales(int idPersona) {
        List<Object[]> rows = contribuyenteImpuestoDAO.listarPredialesPorPersona(idPersona);
        List<MiImpuestoItemDTO> items = new ArrayList<>();

        for (Object[] row : rows) {
            int idPredial = toInt(valorEn(row, 0), 0);
            int anio = toInt(valorEn(row, 1), LocalDate.now().getYear());
            BigDecimal montoTotal = toBigDecimal(valorEn(row, 2));
            String estadoDb = texto(valorEn(row, 3));
            String estadoVisual = mapEstadoPredial(estadoDb);
            int cuotasPagadas = cuotasPagadasPredial(estadoDb);

            BigDecimal cuota = montoTotal
                    .divide(new BigDecimal("4"), 2, RoundingMode.HALF_UP);
            BigDecimal montoPagado = cuota
                    .multiply(BigDecimal.valueOf(cuotasPagadas))
                    .setScale(2, RoundingMode.HALF_UP);
            LocalDate vencimiento = LocalDate.of(anio, 12, 31);

            MiImpuestoItemDTO item = new MiImpuestoItemDTO();
            item.setTipo("Predial");
            item.setDetalleTipo("PREDIAL");
            item.setIdReferencia(idPredial);
            item.setAnio(anio);
            item.setEstado(estadoVisual);
            item.setMontoTotal(montoTotal);
            item.setMontoPagado(montoPagado);
            item.setFechaVencimiento(vencimiento);
            items.add(item);
        }

        return items;
    }

    private List<MiImpuestoItemDTO> listarVehiculares(int idPersona) {
        Set<String> placasPersona = new HashSet<>();
        for (String placa : contribuyenteImpuestoDAO.listarPlacasPorPersona(idPersona)) {
            if (placa != null && !placa.isBlank()) {
                placasPersona.add(placa.trim().toUpperCase());
            }
        }

        List<MiImpuestoItemDTO> items = new ArrayList<>();
        if (placasPersona.isEmpty()) {
            return items;
        }

        List<Object[]> impuestosVehicular = impuestoService.listarVehiculares();

        for (Object[] row : impuestosVehicular) {
            String placa = texto(valorEn(row, 2));
            if (placa == null || !placasPersona.contains(placa.toUpperCase())) {
                continue;
            }

            int idImpuesto = toInt(valorEn(row, 0), 0);
            if (idImpuesto <= 0) {
                continue;
            }

            List<Object[]> detalle = impuestoService.listarDetalle(idImpuesto);
            BigDecimal total = BigDecimal.ZERO;
            BigDecimal pagado = BigDecimal.ZERO;
            int anio = toInt(valorEn(row, 3), LocalDate.now().getYear());

            for (Object[] d : detalle) {
                int anioDetalle = toInt(valorEn(d, 1), anio);
                if (anioDetalle > anio) {
                    anio = anioDetalle;
                }

                BigDecimal monto = toBigDecimal(valorEn(d, 2));
                total = total.add(monto);

                String estado = texto(valorEn(d, 3));
                if ("PAGADO".equalsIgnoreCase(estado)) {
                    pagado = pagado.add(monto);
                }
            }

            String estadoVisual;
            if (total.compareTo(BigDecimal.ZERO) > 0 && pagado.compareTo(total) >= 0) {
                estadoVisual = "Pagado";
            } else if (pagado.compareTo(BigDecimal.ZERO) > 0) {
                estadoVisual = "Fraccionado";
            } else {
                estadoVisual = "Pendiente";
            }

            MiImpuestoItemDTO item = new MiImpuestoItemDTO();
            item.setTipo("Vehicular");
            item.setDetalleTipo("VEHICULAR");
            item.setIdReferencia(idImpuesto);
            item.setAnio(anio);
            item.setEstado(estadoVisual);
            item.setMontoTotal(total);
            item.setMontoPagado(pagado);
            item.setFechaVencimiento(LocalDate.of(anio, 6, 30));
            items.add(item);
        }

        return items;
    }

    private MiImpuestoDetalleDTO obtenerDetallePredial(int idPersona, int idPredial) {
        Object[] row = contribuyenteImpuestoDAO.obtenerPredialPorPersona(idPersona, idPredial);
        if (row == null) {
            return null;
        }

        int anio = toInt(valorEn(row, 1), LocalDate.now().getYear());
        BigDecimal montoTotal = toBigDecimal(valorEn(row, 2));
        String estadoDb = texto(valorEn(row, 3));
        String estadoVisual = mapEstadoPredial(estadoDb);
        int cuotasPagadas = cuotasPagadasPredial(estadoDb);

        MiImpuestoDetalleDTO detalle = new MiImpuestoDetalleDTO();
        detalle.setTipo("Predial");
        detalle.setAnio(anio);
        detalle.setMontoTotal(montoTotal);
        detalle.setEstado(estadoVisual);

        BigDecimal montoCuota = montoTotal
                .divide(new BigDecimal("4"), 2, RoundingMode.HALF_UP);
        int[] meses = {3, 6, 9, 12};
        int[] dias = {31, 30, 30, 31};

        for (int i = 0; i < 4; i++) {
            String estadoCuota = i < cuotasPagadas ? "Pagada" : "Pendiente";
            detalle.getCuotas().add(new MiImpuestoCuotaDTO(
                    "Cuota " + (i + 1) + "/4",
                    LocalDate.of(anio, meses[i], dias[i]),
                    montoCuota,
                    estadoCuota
            ));
        }

        return detalle;
    }

    private MiImpuestoDetalleDTO obtenerDetalleVehicular(int idPersona, int idImpuesto) {
        Object[] cabecera = impuestoService.obtenerPorId(idImpuesto);
        if (cabecera == null) {
            return null;
        }

        String placaCabecera = texto(valorEn(cabecera, 2));
        Set<String> placasPersona = new HashSet<>();
        for (String placa : contribuyenteImpuestoDAO.listarPlacasPorPersona(idPersona)) {
            if (placa != null && !placa.isBlank()) {
                placasPersona.add(placa.trim().toUpperCase());
            }
        }

        if (placaCabecera == null || !placasPersona.contains(placaCabecera.toUpperCase())) {
            return null;
        }

        List<Object[]> rows = impuestoService.listarDetalle(idImpuesto);
        if (rows == null || rows.isEmpty()) {
            return null;
        }

        MiImpuestoDetalleDTO detalle = new MiImpuestoDetalleDTO();
        detalle.setTipo("Vehicular");

        BigDecimal total = BigDecimal.ZERO;
        BigDecimal pagado = BigDecimal.ZERO;
        int anioMax = LocalDate.now().getYear();

        List<Object[]> detalleOrdenado = new ArrayList<>(rows);
        detalleOrdenado.sort(Comparator.comparingInt(r -> toInt(valorEn(r, 1), 0)));

        for (int i = 0; i < detalleOrdenado.size(); i++) {
            Object[] row = detalleOrdenado.get(i);

            int anio = toInt(valorEn(row, 1), anioMax);
            anioMax = Math.max(anioMax, anio);

            BigDecimal monto = toBigDecimal(valorEn(row, 2));
            String estadoDb = texto(valorEn(row, 3));
            String estado = "PAGADO".equalsIgnoreCase(estadoDb) ? "Pagada" : "Pendiente";

            total = total.add(monto);
            if ("Pagada".equalsIgnoreCase(estado)) {
                pagado = pagado.add(monto);
            }

            detalle.getCuotas().add(new MiImpuestoCuotaDTO(
                    "Cuota " + (i + 1) + "/" + detalleOrdenado.size(),
                    LocalDate.of(anio, 12, 31),
                    monto,
                    estado
            ));
        }

        detalle.setAnio(anioMax);
        detalle.setMontoTotal(total);
        if (pagado.compareTo(total) >= 0) {
            detalle.setEstado("Pagado");
        } else if (pagado.compareTo(BigDecimal.ZERO) > 0) {
            detalle.setEstado("Fraccionado");
        } else {
            detalle.setEstado("Pendiente");
        }

        return detalle;
    }

    private String normalizarFiltro(String filtro) {
        String value = filtro == null ? "TODOS" : filtro.trim().toUpperCase();
        if ("PREDIAL".equals(value) || "VEHICULAR".equals(value)) {
            return value;
        }
        return "TODOS";
    }

    private String mapEstadoPredial(String estadoDb) {
        if ("CERRADO".equalsIgnoreCase(estadoDb)) {
            return "Pagado";
        }
        if ("ACTIVO".equalsIgnoreCase(estadoDb)) {
            return "Fraccionado";
        }
        return "Pendiente";
    }

    private int cuotasPagadasPredial(String estadoDb) {
        if ("CERRADO".equalsIgnoreCase(estadoDb)) {
            return 4;
        }
        if ("ACTIVO".equalsIgnoreCase(estadoDb)) {
            return 1;
        }
        return 0;
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
            return (BigDecimal) value;
        }
        if (value instanceof Number) {
            return new BigDecimal(value.toString());
        }
        return new BigDecimal(value.toString().trim());
    }
}
