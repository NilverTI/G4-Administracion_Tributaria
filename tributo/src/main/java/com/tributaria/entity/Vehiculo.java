package com.tributaria.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "vehiculo")
public class Vehiculo {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_vehiculo")
    private Integer id;

    @ManyToOne
    @JoinColumn(name = "id_contribuyente")
    private Contribuyente contribuyente;

    private String placa;
    private String marca;
    private String modelo;
    private Integer anio;

    @Column(name = "fecha_inscripcion")
    private LocalDate fechaInscripcion;

    private BigDecimal valor;
    private BigDecimal porcentaje;

    private String estado;

    @Column(name = "fecha_registro")
    private LocalDateTime fechaRegistro;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Contribuyente getContribuyente() {
        return contribuyente;
    }

    public void setContribuyente(Contribuyente contribuyente) {
        this.contribuyente = contribuyente;
    }

    public String getPlaca() {
        return placa;
    }

    public void setPlaca(String placa) {
        this.placa = placa;
    }

    public String getMarca() {
        return marca;
    }

    public void setMarca(String marca) {
        this.marca = marca;
    }

    public String getModelo() {
        return modelo;
    }

    public void setModelo(String modelo) {
        this.modelo = modelo;
    }

    public Integer getAnio() {
        return anio;
    }

    public void setAnio(Integer anio) {
        this.anio = anio;
    }

    public LocalDate getFechaInscripcion() {
        return fechaInscripcion;
    }

    public void setFechaInscripcion(LocalDate fechaInscripcion) {
        this.fechaInscripcion = fechaInscripcion;
    }

    public BigDecimal getValor() {
        return valor;
    }

    public void setValor(BigDecimal valor) {
        this.valor = valor;
    }

    public BigDecimal getPorcentaje() {
        return porcentaje;
    }

    public void setPorcentaje(BigDecimal porcentaje) {
        this.porcentaje = porcentaje;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public LocalDateTime getFechaRegistro() {
        return fechaRegistro;
    }

    public void setFechaRegistro(LocalDateTime fechaRegistro) {
        this.fechaRegistro = fechaRegistro;
    }

    public Vehiculo(Integer id, Contribuyente contribuyente, String placa, String marca, String modelo, Integer anio,
            LocalDate fechaInscripcion, BigDecimal valor, BigDecimal porcentaje, String estado,
            LocalDateTime fechaRegistro) {
        this.id = id;
        this.contribuyente = contribuyente;
        this.placa = placa;
        this.marca = marca;
        this.modelo = modelo;
        this.anio = anio;
        this.fechaInscripcion = fechaInscripcion;
        this.valor = valor;
        this.porcentaje = porcentaje;
        this.estado = estado;
        this.fechaRegistro = fechaRegistro;
    }

    // getters y setters
}