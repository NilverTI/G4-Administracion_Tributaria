package com.tributaria.dto;

import java.math.BigDecimal;
import java.time.LocalDate;

public class MiImpuestoCuotaDTO {

    private String titulo;
    private LocalDate fechaVencimiento;
    private BigDecimal monto;
    private String estado;

    public MiImpuestoCuotaDTO(String titulo,
                              LocalDate fechaVencimiento,
                              BigDecimal monto,
                              String estado) {
        this.titulo = titulo;
        this.fechaVencimiento = fechaVencimiento;
        this.monto = monto;
        this.estado = estado;
    }

    public String getTitulo() {
        return titulo;
    }

    public LocalDate getFechaVencimiento() {
        return fechaVencimiento;
    }

    public BigDecimal getMonto() {
        return monto;
    }

    public String getEstado() {
        return estado;
    }
}
