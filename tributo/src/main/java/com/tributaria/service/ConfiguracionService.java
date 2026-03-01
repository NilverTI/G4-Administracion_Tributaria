package com.tributaria.service;

import com.tributaria.dao.ConfiguracionDAO;

import java.math.BigDecimal;
import java.util.List;

public class ConfiguracionService {

    private final ConfiguracionDAO dao = new ConfiguracionDAO();

    // =========================
    // UIT
    // =========================
    public List<Object[]> listarUIT() {
        return dao.listarUIT();
    }

    public void crearUIT(int anio, double valor) {
        dao.crearUIT(anio, valor);
    }

    public void actualizarUIT(int anio, double valor) {
        dao.actualizarUIT(anio, valor);
    }

    // =========================
    // ZONAS
    // =========================
    public List<Object[]> listarZonas() {
        return dao.listarZonas();
    }

    public void crearZona(String codigo, String nombre, double tasa) {
        dao.crearZona(codigo, nombre, tasa);
    }

    public void cambiarEstadoZona(int idZona, String estado) {
        dao.cambiarEstadoZona(idZona, estado);
    }

    // =========================
    // VEHICULAR CONFIG
    // =========================
    public List<Object[]> listarVehicularConfig() {
        return dao.listarVehicularConfig();
    }

    public void crearVehicularConfig(int anio, double porcentaje) {
        dao.crearVehicularConfig(anio, porcentaje);
    }

    public void cambiarEstadoVehicularConfig(int anio, String estado) {
        // en tu JSP tú mandas "anio", así que usamos ese valor como identificador
        dao.cambiarEstadoVehicularConfig(anio, estado);
    }

    public BigDecimal obtenerPorcentajeVehicularPorAnio(int anio) {
        return dao.obtenerPorcentajeVehicularPorAnio(anio);
    }
}