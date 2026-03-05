package com.tributaria.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "zona")
public class Zona {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_zona")
    private Integer id;

    private String codigo;

    private String nombre;

    @Column(name = "tasa_predial")
    private BigDecimal tasaPredial;

    private String estado;

    @Column(name = "fecha_creacion")
    private LocalDateTime fechaCreacion;

    public Zona() {}

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getCodigo() {
        return codigo;
    }

    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public BigDecimal getTasaPredial() {
        return tasaPredial;
    }

    public void setTasaPredial(BigDecimal tasaPredial) {
        this.tasaPredial = tasaPredial;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public LocalDateTime getFechaCreacion() {
        return fechaCreacion;
    }

    public void setFechaCreacion(LocalDateTime fechaCreacion) {
        this.fechaCreacion = fechaCreacion;
    }
}
