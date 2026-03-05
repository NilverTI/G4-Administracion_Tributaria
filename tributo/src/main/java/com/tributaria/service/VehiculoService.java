package com.tributaria.service;

import com.tributaria.dao.VehiculoDAO;

import java.math.BigDecimal;
import java.util.List;

public class VehiculoService {

    private final VehiculoDAO dao = new VehiculoDAO();
    private final VehicularConfigService configServ = new VehicularConfigService();

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
            BigDecimal porcentaje
    ) {
        dao.crear(idContribuyente, placa, marca, modelo, anio, fechaInscripcion, valor, porcentaje);
    }

    public void cambiarEstado(int idVehiculo, String estado) {
        dao.cambiarEstado(idVehiculo, estado);
    }

    public Object[] obtenerEditablePorId(int idVehiculo) {
        return dao.obtenerEditablePorId(idVehiculo);
    }

    public Object[] obtenerDetallePorId(int idVehiculo) {
        return dao.obtenerDetallePorId(idVehiculo);
    }

    public void actualizarDatosBasicos(
            int idVehiculo,
            String placa,
            String marca,
            String modelo,
            int anio,
            String fechaInscripcion,
            BigDecimal valor
    ) {
        dao.actualizarDatosBasicos(idVehiculo, placa, marca, modelo, anio, fechaInscripcion, valor);
    }

    public void actualizarDatosCompletos(
            int idVehiculo,
            int idContribuyente,
            String placa,
            String marca,
            String modelo,
            int anio,
            String fechaInscripcion,
            BigDecimal valor
    ) {
        dao.actualizarDatosCompletos(idVehiculo, idContribuyente, placa, marca, modelo, anio, fechaInscripcion, valor);
    }

    public BigDecimal porcentajePorAnio(int anio) {
        return configServ.obtenerPorcentajeVigente(anio);
    }
}
