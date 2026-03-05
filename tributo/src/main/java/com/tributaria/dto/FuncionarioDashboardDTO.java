package com.tributaria.dto;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.List;

public class FuncionarioDashboardDTO {

    private int anioActual;
    private int totalContribuyentes;
    private int totalActivos;
    private int totalInmuebles;
    private int inmueblesActivos;
    private int totalVehiculos;
    private int vehiculosActivos;
    private BigDecimal deudaPendiente = BigDecimal.ZERO;
    private BigDecimal totalRegistradoAnio = BigDecimal.ZERO;
    private final List<String> chartLabels = new ArrayList<>();
    private final List<BigDecimal> chartPredial = new ArrayList<>();
    private final List<BigDecimal> chartVehicular = new ArrayList<>();
    private final List<BigDecimal> chartAlcabala = new ArrayList<>();
    private final List<DashboardPendienteItemDTO> alertas = new ArrayList<>();

    public int getAnioActual() {
        return anioActual;
    }

    public void setAnioActual(int anioActual) {
        this.anioActual = anioActual;
    }

    public int getTotalContribuyentes() {
        return totalContribuyentes;
    }

    public void setTotalContribuyentes(int totalContribuyentes) {
        this.totalContribuyentes = totalContribuyentes;
    }

    public int getTotalActivos() {
        return totalActivos;
    }

    public void setTotalActivos(int totalActivos) {
        this.totalActivos = totalActivos;
    }

    public int getTotalInmuebles() {
        return totalInmuebles;
    }

    public void setTotalInmuebles(int totalInmuebles) {
        this.totalInmuebles = totalInmuebles;
    }

    public int getInmueblesActivos() {
        return inmueblesActivos;
    }

    public void setInmueblesActivos(int inmueblesActivos) {
        this.inmueblesActivos = inmueblesActivos;
    }

    public int getTotalVehiculos() {
        return totalVehiculos;
    }

    public void setTotalVehiculos(int totalVehiculos) {
        this.totalVehiculos = totalVehiculos;
    }

    public int getVehiculosActivos() {
        return vehiculosActivos;
    }

    public void setVehiculosActivos(int vehiculosActivos) {
        this.vehiculosActivos = vehiculosActivos;
    }

    public BigDecimal getDeudaPendiente() {
        return deudaPendiente;
    }

    public void setDeudaPendiente(BigDecimal deudaPendiente) {
        this.deudaPendiente = scale(deudaPendiente);
    }

    public BigDecimal getTotalRegistradoAnio() {
        return totalRegistradoAnio;
    }

    public void setTotalRegistradoAnio(BigDecimal totalRegistradoAnio) {
        this.totalRegistradoAnio = scale(totalRegistradoAnio);
    }

    public List<String> getChartLabels() {
        return chartLabels;
    }

    public List<BigDecimal> getChartPredial() {
        return chartPredial;
    }

    public List<BigDecimal> getChartVehicular() {
        return chartVehicular;
    }

    public List<BigDecimal> getChartAlcabala() {
        return chartAlcabala;
    }

    public List<DashboardPendienteItemDTO> getAlertas() {
        return alertas;
    }

    public String getChartLabelsCsv() {
        return String.join(",", chartLabels);
    }

    public String getChartPredialCsv() {
        return numericCsv(chartPredial);
    }

    public String getChartVehicularCsv() {
        return numericCsv(chartVehicular);
    }

    public String getChartAlcabalaCsv() {
        return numericCsv(chartAlcabala);
    }

    private String numericCsv(List<BigDecimal> values) {
        StringBuilder builder = new StringBuilder();
        for (int i = 0; i < values.size(); i++) {
            if (i > 0) {
                builder.append(',');
            }
            builder.append(scale(values.get(i)).toPlainString());
        }
        return builder.toString();
    }

    private BigDecimal scale(BigDecimal value) {
        if (value == null) {
            return BigDecimal.ZERO.setScale(2, RoundingMode.HALF_UP);
        }
        return value.setScale(2, RoundingMode.HALF_UP);
    }
}
