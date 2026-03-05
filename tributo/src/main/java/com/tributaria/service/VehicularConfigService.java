package com.tributaria.service;

import com.tributaria.dao.VehicularConfigDAO;

import java.math.BigDecimal;
import java.util.List;

public class VehicularConfigService {

    private VehicularConfigDAO dao = new VehicularConfigDAO();

    public List<Object[]> listar() {
        return dao.listar();
    }

    public void crear(int anio, double porcentaje) {
        dao.crear(anio, porcentaje);
    }

    public void cambiarEstado(int id, String estado) {
        dao.cambiarEstado(id, estado);
    }

    // 🔥 NUEVO → obtener porcentaje correcto para el año
    public BigDecimal obtenerPorcentajeVigente(int anio) {
        return dao.obtenerPorcentajeVigente(anio);
    }
}