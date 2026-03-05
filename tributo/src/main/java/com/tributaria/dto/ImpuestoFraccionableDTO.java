package com.tributaria.dto;

import java.math.BigDecimal;

public class ImpuestoFraccionableDTO {

    private String tipoImpuesto;
    private int idReferencia;
    private String codigoImpuesto;
    private String contribuyente;
    private String descripcion;
    private BigDecimal montoAnual;
    private String estado;

    public String getTipoImpuesto() {
        return tipoImpuesto;
    }

    public void setTipoImpuesto(String tipoImpuesto) {
        this.tipoImpuesto = tipoImpuesto;
    }

    public int getIdReferencia() {
        return idReferencia;
    }

    public void setIdReferencia(int idReferencia) {
        this.idReferencia = idReferencia;
    }

    public String getCodigoImpuesto() {
        return codigoImpuesto;
    }

    public void setCodigoImpuesto(String codigoImpuesto) {
        this.codigoImpuesto = codigoImpuesto;
    }

    public String getContribuyente() {
        return contribuyente;
    }

    public void setContribuyente(String contribuyente) {
        this.contribuyente = contribuyente;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public BigDecimal getMontoAnual() {
        return montoAnual;
    }

    public void setMontoAnual(BigDecimal montoAnual) {
        this.montoAnual = montoAnual;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }
}
