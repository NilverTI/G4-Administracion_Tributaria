package com.tributaria.entity;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "contribuyentes")
public class Contribuyente {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_contribuyente")
    private Integer id;

    @ManyToOne
    @JoinColumn(name = "id_persona", nullable = false)
    private Persona persona;

    @Column(name = "fecha_registro_tributario")
    private LocalDate fechaRegistroTributario;

    @Column(name = "estado")
    private String estado;

    // Getters y Setters

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Persona getPersona() {
        return persona;
    }

    public void setPersona(Persona persona) {
        this.persona = persona;
    }

    public LocalDate getFechaRegistroTributario() {
        return fechaRegistroTributario;
    }

    public void setFechaRegistroTributario(LocalDate fechaRegistroTributario) {
        this.fechaRegistroTributario = fechaRegistroTributario;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }
}
