package com.tributaria.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "alcabala")
public class Alcabala {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne
    @JoinColumn(name = "id_inmueble")
    private Inmueble inmueble;

    @Column(name = "valor_venta")
    private BigDecimal valorVenta;

    @Column(name = "fecha_venta")
    private LocalDate fechaVenta;

    private String estado;

    // getters y setters
}
