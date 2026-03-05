package com.tributaria.dto;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.List;

public class ContribuyenteDashboardDTO {

    private BigDecimal deudaTotal = BigDecimal.ZERO;
    private int impuestosPendientes;
    private int impuestosPagados;
    private int proximasCuotas;
    private final List<MiImpuestoItemDTO> impuestosPendientesDetalle = new ArrayList<>();
    private final List<MiImpuestoCuotaDTO> proximasCuotasDetalle = new ArrayList<>();

    public BigDecimal getDeudaTotal() {
        return deudaTotal;
    }

    public void setDeudaTotal(BigDecimal deudaTotal) {
        this.deudaTotal = scale(deudaTotal);
    }

    public int getImpuestosPendientes() {
        return impuestosPendientes;
    }

    public void setImpuestosPendientes(int impuestosPendientes) {
        this.impuestosPendientes = impuestosPendientes;
    }

    public int getImpuestosPagados() {
        return impuestosPagados;
    }

    public void setImpuestosPagados(int impuestosPagados) {
        this.impuestosPagados = impuestosPagados;
    }

    public int getProximasCuotas() {
        return proximasCuotas;
    }

    public void setProximasCuotas(int proximasCuotas) {
        this.proximasCuotas = proximasCuotas;
    }

    public List<MiImpuestoItemDTO> getImpuestosPendientesDetalle() {
        return impuestosPendientesDetalle;
    }

    public List<MiImpuestoCuotaDTO> getProximasCuotasDetalle() {
        return proximasCuotasDetalle;
    }

    private BigDecimal scale(BigDecimal value) {
        if (value == null) {
            return BigDecimal.ZERO.setScale(2, RoundingMode.HALF_UP);
        }
        return value.setScale(2, RoundingMode.HALF_UP);
    }
}
