package com.tributaria.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "uit")
public class UIT {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    private Integer anio;
    private BigDecimal valor;

    private String estado;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getAnio() {
        return anio;
    }

    public void setAnio(Integer anio) {
        this.anio = anio;
    }

    public BigDecimal getValor() {
        return valor;
    }

    public void setValor(BigDecimal valor) {
        this.valor = valor;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

   public UIT(Integer id, Integer anio, BigDecimal valor, String estado) {
        this.id = id;
        this.anio = anio;
        this.valor = valor;
        this.estado = estado;
    }
}