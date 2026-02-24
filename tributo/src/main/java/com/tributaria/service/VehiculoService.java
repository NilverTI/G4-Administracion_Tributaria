package com.tributaria.service;

import com.tributaria.dao.VehiculoDAO;

import java.math.BigDecimal;
import java.util.List;

public class VehiculoService {

    private VehiculoDAO dao = new VehiculoDAO();

    public List<Object[]> listar() {
        return dao.listar();
    }

    public void crear(
            int idContribuyente,
            String placa,
            String marca,
            String modelo,
            int anio,
            String fechaInscripcion,
            BigDecimal valor,
            BigDecimal porcentaje) {
        dao.crear(idContribuyente, placa, marca, modelo, anio, fechaInscripcion, valor, porcentaje);
    }

    public void cambiarEstado(int idVehiculo, String estado) {
        dao.cambiarEstado(idVehiculo, estado);
    }

    public int contar() {
        return dao.contar();
    }

    public int contarActivos() {
        return dao.contarActivos();
    }
}