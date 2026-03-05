package com.tributaria.entity;

import jakarta.persistence.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "inmueble")
public class Inmueble {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_inmueble")
    private Integer id;

    @ManyToOne
    @JoinColumn(name = "id_contribuyente")
    private Contribuyente contribuyente;

    @ManyToOne
    @JoinColumn(name = "id_zona")
    private Zona zona;

    private String direccion;

    @Column(name = "valor_catastral")
    private BigDecimal valorCatastral;

    @Column(name = "tipo_uso")
    private String tipoUso;

    @Column(name = "area_terreno_m2")
    private BigDecimal areaTerrenoM2;

    @Column(name = "area_construida_m2")
    private BigDecimal areaConstruidaM2;

    @Column(name = "tipo_material")
    private String tipoMaterial;

    private String estado;

    @Column(name = "fecha_registro")
    private LocalDateTime fechaRegistro;

    public Inmueble() {
    }

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

    public Zona getZona() {
        return zona;
    }

    public void setZona(Zona zona) {
        this.zona = zona;
    }

    public String getDireccion() {
        return direccion;
    }

    public void setDireccion(String direccion) {
        this.direccion = direccion;
    }

    public BigDecimal getValorCatastral() {
        return valorCatastral;
    }

    public void setValorCatastral(BigDecimal valorCatastral) {
        this.valorCatastral = valorCatastral;
    }

    public String getTipoUso() {
        return tipoUso;
    }

    public void setTipoUso(String tipoUso) {
        this.tipoUso = tipoUso;
    }

    public BigDecimal getAreaTerrenoM2() {
        return areaTerrenoM2;
    }

    public void setAreaTerrenoM2(BigDecimal areaTerrenoM2) {
        this.areaTerrenoM2 = areaTerrenoM2;
    }

    public BigDecimal getAreaConstruidaM2() {
        return areaConstruidaM2;
    }

    public void setAreaConstruidaM2(BigDecimal areaConstruidaM2) {
        this.areaConstruidaM2 = areaConstruidaM2;
    }

    public String getTipoMaterial() {
        return tipoMaterial;
    }

    public void setTipoMaterial(String tipoMaterial) {
        this.tipoMaterial = tipoMaterial;
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
}
