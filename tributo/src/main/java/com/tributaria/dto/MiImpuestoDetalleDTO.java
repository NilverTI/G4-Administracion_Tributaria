package com.tributaria.dto;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class MiImpuestoDetalleDTO {

    private String tipo;
    private int anio;
    private BigDecimal montoTotal;
    private String estado;
    private List<MiImpuestoCuotaDTO> cuotas = new ArrayList<>();

    public String getTipo() {
        return tipo;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }

    public int getAnio() {
        return anio;
    }

    public void setAnio(int anio) {
        this.anio = anio;
    }

    public BigDecimal getMontoTotal() {
        return montoTotal;
    }

    public void setMontoTotal(BigDecimal montoTotal) {
        this.montoTotal = montoTotal;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public List<MiImpuestoCuotaDTO> getCuotas() {
        return cuotas;
    }
}
