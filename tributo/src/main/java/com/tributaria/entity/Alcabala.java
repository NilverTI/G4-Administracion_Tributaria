package com.tributaria.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "alcabala")
public class Alcabala {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_alcabala")
    private Integer id;

    @ManyToOne
    @JoinColumn(name = "id_inmueble")
    private Inmueble inmueble;

    @Column(name = "valor_venta")
    private BigDecimal valorVenta;

    @Column(name = "fecha_venta")
    private LocalDate fechaVenta;

    private String estado;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Inmueble getInmueble() {
        return inmueble;
    }

    public void setInmueble(Inmueble inmueble) {
        this.inmueble = inmueble;
    }

    public BigDecimal getValorVenta() {
        return valorVenta;
    }

    public void setValorVenta(BigDecimal valorVenta) {
        this.valorVenta = valorVenta;
    }

    public LocalDate getFechaVenta() {
        return fechaVenta;
    }

    public void setFechaVenta(LocalDate fechaVenta) {
        this.fechaVenta = fechaVenta;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public Alcabala(Integer id, Inmueble inmueble, BigDecimal valorVenta, LocalDate fechaVenta, String estado) {
        this.id = id;
        this.inmueble = inmueble;
        this.valorVenta = valorVenta;
        this.fechaVenta = fechaVenta;
        this.estado = estado;
    }

    // getters y setters
}
