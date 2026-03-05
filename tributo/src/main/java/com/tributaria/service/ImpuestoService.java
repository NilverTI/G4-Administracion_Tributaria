package com.tributaria.service;

import com.tributaria.dao.ImpuestoDAO;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

public class ImpuestoService {

    private final ImpuestoDAO dao = new ImpuestoDAO();

    // =========================
    // Vehicular
    // =========================
    public List<Object[]> listarVehiculares() {
        return dao.listarVehiculares();
    }

    public void crearVehicular(int idVehiculo) {
        dao.crearImpuestoVehicular(idVehiculo);
    }

    public Object[] obtenerPorId(int idImpuesto) {
        return dao.obtenerPorId(idImpuesto);
    }

    public List<Object[]> listarDetalle(int idImpuesto) {
        return dao.listarDetalle(idImpuesto);
    }

    // =========================
    // Predial
    // =========================
    public List<Object[]> listarPrediales() {
        return dao.listarPrediales();
    }

    public List<Object[]> listarInmueblesPredialDisponibles() {
        return dao.listarInmueblesPredialDisponibles();
    }

    public void crearPredial(int idInmueble) {
        dao.crearImpuestoPredial(idInmueble);
    }

    public Object[] obtenerPredialPorId(int idPredial) {
        return dao.obtenerPredialPorId(idPredial);
    }

    public void cambiarEstadoPredial(int idPredial, String estado, String motivo, String detalleMotivo) {
        dao.cambiarEstadoPredial(idPredial, estado, motivo, detalleMotivo);
    }

    public List<Object[]> listarHistorialPredial(int idPredial) {
        return dao.listarHistorialPredial(idPredial);
    }

    public void aplicarReglasPredial(int edadLimite) {
        dao.aplicarReglasAutomaticasPredial(edadLimite);
    }

    public void actualizarPredialBasico(int idPredial, BigDecimal tasaAplicada, BigDecimal montoAnual) {
        dao.actualizarPredialBasico(idPredial, tasaAplicada, montoAnual);
    }

    // =========================
    // Alcabala
    // =========================
    public List<Object[]> listarAlcabalas() {
        return dao.listarAlcabalas();
    }

    public List<Object[]> listarInmueblesParaAlcabala() {
        return dao.listarInmueblesParaAlcabala();
    }

    public void crearAlcabala(int idInmueble, int idComprador, BigDecimal valorVenta, LocalDate fechaVenta) {
        dao.crearImpuestoAlcabala(idInmueble, idComprador, valorVenta, fechaVenta);
    }

    public Object[] obtenerAlcabalaPorId(int idAlcabala) {
        return dao.obtenerAlcabalaPorId(idAlcabala);
    }

    public Object[] obtenerAlcabalaEditablePorId(int idAlcabala) {
        return dao.obtenerAlcabalaEditablePorId(idAlcabala);
    }

    public void cambiarEstadoAlcabala(int idAlcabala, String estado) {
        dao.cambiarEstadoAlcabala(idAlcabala, estado);
    }

    public void actualizarAlcabalaBasico(int idAlcabala, BigDecimal valorVenta, LocalDate fechaVenta) {
        dao.actualizarAlcabalaBasico(idAlcabala, valorVenta, fechaVenta);
    }
}
