package com.tributaria.service;

import com.tributaria.dao.CuotaDAO;
import com.tributaria.entity.Cuota;

import java.time.LocalDate;
import java.util.List;

public class CuotaService {

    private final CuotaDAO cuotaDAO = new CuotaDAO();

    // ✅ Vista CUOTAS (SP sp_listar_cuotas)
    public List<Object[]> listarVista() {
        return cuotaDAO.listarVista();
    }

    // ✅ Combo de impuestos para fraccionar
    public List<Object[]> listarImpuestosParaFraccionar() {
        return cuotaDAO.listarImpuestosParaFraccionar();
    }

    // ✅ Crear fraccionamiento sobre impuesto existente
    public void crearFraccionamiento(Integer idImpuesto, Integer numeroCuotas, LocalDate fechaPrimeraCuota) {
        if (idImpuesto == null || numeroCuotas == null || fechaPrimeraCuota == null) {
            throw new IllegalArgumentException("Completa todos los campos");
        }
        if (numeroCuotas < 1 || numeroCuotas > 48) {
            throw new IllegalArgumentException("Número de cuotas inválido (1 a 48)");
        }
        cuotaDAO.fraccionarImpuesto(idImpuesto, numeroCuotas, fechaPrimeraCuota);
    }

    // ✅ Para PAGOS
    public List<Cuota> listarPendientes() {
        return cuotaDAO.listarPendientes();
    }

    public Cuota buscarPorId(int idCuota) {
        return cuotaDAO.buscarPorId(idCuota);
    }

    public void marcarComoPagada(Integer idCuota) {
        cuotaDAO.marcarComoPagada(idCuota);
    }
}