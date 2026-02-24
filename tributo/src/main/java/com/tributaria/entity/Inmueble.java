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

    private String estado;

    @Column(name = "fecha_registro")
    private LocalDateTime fechaRegistro;

    // ⚠️ CONSTRUCTOR VACÍO OBLIGATORIO
    public Inmueble() {
    }

    // Constructor con parámetros
    public Inmueble(Integer id, Contribuyente contribuyente, Zona zona, String direccion,
                    BigDecimal valorCatastral, String estado, LocalDateTime fechaRegistro) {
        this.id = id;
        this.contribuyente = contribuyente;
        this.zona = zona;
        this.direccion = direccion;
        this.valorCatastral = valorCatastral;
        this.estado = estado;
        this.fechaRegistro = fechaRegistro;
    }

    // Getters y setters...
}
