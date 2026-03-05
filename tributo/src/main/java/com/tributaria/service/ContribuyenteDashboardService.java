package com.tributaria.service;

import com.tributaria.dao.ContribuyenteImpuestoDAO;
import com.tributaria.dto.ContribuyenteDashboardDTO;
import com.tributaria.dto.MiImpuestoCuotaDTO;
import com.tributaria.dto.MiImpuestoItemDTO;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Date;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

public class ContribuyenteDashboardService {

    private final ContribuyenteImpuestoService impuestoService = new ContribuyenteImpuestoService();
    private final ContribuyenteImpuestoDAO impuestoDAO = new ContribuyenteImpuestoDAO();

    public ContribuyenteDashboardDTO obtenerResumen(int idPersona) {
        ContribuyenteDashboardDTO dto = new ContribuyenteDashboardDTO();
        LocalDate hoy = LocalDate.now();

        List<MiImpuestoItemDTO> items = impuestoService.listarMisImpuestos(idPersona, "TODOS");
        List<MiImpuestoItemDTO> pendientes = new ArrayList<>();
        BigDecimal deudaTotal = BigDecimal.ZERO;
        int pagados = 0;

        for (MiImpuestoItemDTO item : items) {
            BigDecimal montoTotal = safe(item.getMontoTotal());
            BigDecimal montoPagado = safe(item.getMontoPagado());
            BigDecimal saldo = montoTotal.subtract(montoPagado).max(BigDecimal.ZERO);

            if (saldo.compareTo(BigDecimal.ZERO) > 0) {
                deudaTotal = deudaTotal.add(saldo);
                pendientes.add(copiarPendiente(item, saldo));
            } else {
                pagados++;
            }
        }

        pendientes.sort(Comparator.comparing(
                MiImpuestoItemDTO::getFechaVencimiento,
                Comparator.nullsLast(Comparator.naturalOrder())
        ));

        dto.setDeudaTotal(deudaTotal);
        dto.setImpuestosPendientes(pendientes.size());
        dto.setImpuestosPagados(pagados);

        for (int i = 0; i < pendientes.size() && i < 3; i++) {
            dto.getImpuestosPendientesDetalle().add(pendientes.get(i));
        }

        List<Object[]> cuotasRows = impuestoDAO.listarCuotasPendientesPorPersona(idPersona);
        dto.setProximasCuotas(cuotasRows.size());

        for (int i = 0; i < cuotasRows.size() && i < 3; i++) {
            Object[] row = cuotasRows.get(i);
            int numeroCuota = toInt(valorEn(row, 1), 0);
            int totalCuotas = toInt(valorEn(row, 2), 0);
            LocalDate fechaVencimiento = toLocalDate(valorEn(row, 3));
            String estado = fechaVencimiento != null && fechaVencimiento.isBefore(hoy)
                    ? "Vencida"
                    : "Pendiente";

            dto.getProximasCuotasDetalle().add(new MiImpuestoCuotaDTO(
                    "Cuota " + numeroCuota + " de " + totalCuotas,
                    fechaVencimiento,
                    safe(valorEn(row, 4)),
                    estado
            ));
        }

        return dto;
    }

    private MiImpuestoItemDTO copiarPendiente(MiImpuestoItemDTO origen, BigDecimal saldo) {
        MiImpuestoItemDTO item = new MiImpuestoItemDTO();
        item.setTipo(origen.getTipo());
        item.setDetalleTipo(origen.getDetalleTipo());
        item.setIdReferencia(origen.getIdReferencia());
        item.setAnio(origen.getAnio());
        item.setEstado(origen.getEstado());
        item.setMontoTotal(safe(saldo));
        item.setMontoPagado(safe(origen.getMontoPagado()));
        item.setFechaVencimiento(origen.getFechaVencimiento());
        return item;
    }

    private Object valorEn(Object[] row, int index) {
        if (row == null || index < 0 || index >= row.length) {
            return null;
        }
        return row[index];
    }

    private BigDecimal safe(Object value) {
        if (value == null) {
            return BigDecimal.ZERO.setScale(2, RoundingMode.HALF_UP);
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
}
