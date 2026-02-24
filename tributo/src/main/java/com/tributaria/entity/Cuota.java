package com.tributaria.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "cuota")
public class Cuota {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_cuota")
    private Integer id;

    @Column(name = "codigo")
    private String codigo;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_impuesto", nullable = false)
    private Impuesto impuesto;

    // ✅ EN TU BD SE LLAMA "numero"
    @Column(name = "numero", nullable = false)
    private Integer numero;

    @Column(name = "total_cuotas", nullable = false)
    private Integer totalCuotas;

    @Column(name = "monto", nullable = false)
    private BigDecimal monto;

    // ✅ EN TU BD SE LLAMA "vencimiento"
    @Column(name = "vencimiento", nullable = false)
    private LocalDate vencimiento;

    @Column(name = "fecha_pago")
    private LocalDate fechaPago;

    @Column(name = "estado", nullable = false)
    private String estado;

    // ---------------- GETTERS / SETTERS ----------------

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public String getCodigo() { return codigo; }
    public void setCodigo(String codigo) { this.codigo = codigo; }

    public Impuesto getImpuesto() { return impuesto; }
    public void setImpuesto(Impuesto impuesto) { this.impuesto = impuesto; }

    // ✅ Getter real para JSP/Java
    public Integer getNumero() { return numero; }
    public void setNumero(Integer numero) { this.numero = numero; }

    // ✅ ALIAS para que NO se rompa tu JSP actual (${c.numeroCuota})
    @Transient
    public Integer getNumeroCuota() { return numero; }

    @Transient
    public void setNumeroCuota(Integer numeroCuota) { this.numero = numeroCuota; }

    public Integer getTotalCuotas() { return totalCuotas; }
    public void setTotalCuotas(Integer totalCuotas) { this.totalCuotas = totalCuotas; }

    public BigDecimal getMonto() { return monto; }
    public void setMonto(BigDecimal monto) { this.monto = monto; }

    public LocalDate getVencimiento() { return vencimiento; }
    public void setVencimiento(LocalDate vencimiento) { this.vencimiento = vencimiento; }

    // ✅ ALIAS para tu DAO viejo (si usa fechaVencimiento)
    @Transient
    public LocalDate getFechaVencimiento() { return vencimiento; }

    @Transient
    public void setFechaVencimiento(LocalDate fechaVencimiento) { this.vencimiento = fechaVencimiento; }

    public LocalDate getFechaPago() { return fechaPago; }
    public void setFechaPago(LocalDate fechaPago) { this.fechaPago = fechaPago; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }
}