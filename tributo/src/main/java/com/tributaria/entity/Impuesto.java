package com.tributaria.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.util.List;

@Entity
@Table(name = "impuesto")
public class Impuesto {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_impuesto")
    private Integer id;

    @Column(name = "codigo")
    private String codigo;

    @ManyToOne
    @JoinColumn(name = "id_contribuyente")
    private Contribuyente contribuyente;

    @Column(name = "tipo")
    private String tipo;

    @Column(name = "anio")
    private Integer anio;

    @Column(name = "monto_total")
    private BigDecimal montoTotal;

    @Column(name = "estado")
    private String estado;

    @OneToMany(mappedBy = "impuesto")
    private List<Cuota> cuotas;

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public String getCodigo() { return codigo; }
    public void setCodigo(String codigo) { this.codigo = codigo; }

    public Contribuyente getContribuyente() { return contribuyente; }
    public void setContribuyente(Contribuyente contribuyente) { this.contribuyente = contribuyente; }

    public String getTipo() { return tipo; }
    public void setTipo(String tipo) { this.tipo = tipo; }

    public Integer getAnio() { return anio; }
    public void setAnio(Integer anio) { this.anio = anio; }

    public BigDecimal getMontoTotal() { return montoTotal; }
    public void setMontoTotal(BigDecimal montoTotal) { this.montoTotal = montoTotal; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }

    public List<Cuota> getCuotas() { return cuotas; }
    public void setCuotas(List<Cuota> cuotas) { this.cuotas = cuotas; }
}